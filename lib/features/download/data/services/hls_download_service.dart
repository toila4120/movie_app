import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/download_entity.dart';
import '../models/download_model.dart';

class HlsDownloadService {
  static const int maxConcurrentDownloads = 20;
  final Map<String, StreamController<DownloadEntity>> _progressControllers = {};
  final Map<String, bool> _cancelTokens = {};

  // Stream để theo dõi tiến độ download
  Stream<DownloadEntity> getDownloadProgress(String downloadId) {
    if (!_progressControllers.containsKey(downloadId)) {
      _progressControllers[downloadId] =
          StreamController<DownloadEntity>.broadcast();
    }
    return _progressControllers[downloadId]!.stream;
  }

  // Hủy download
  void cancelDownload(String downloadId) {
    _cancelTokens[downloadId] = true;
    _progressControllers[downloadId]?.close();
    _progressControllers.remove(downloadId);
  }

  // Bắt đầu download video HLS
  Future<DownloadEntity> startDownload({
    required String downloadId,
    required String movieName,
    required String episodeName,
    required String thumbnailUrl,
    required String m3u8Url,
  }) async {
    try {
      // Khởi tạo download entity
      final directory = await getApplicationDocumentsDirectory();
      final localDir = Directory('${directory.path}/video_files/$downloadId');

      // Xóa thư mục cũ nếu có
      if (await localDir.exists()) {
        await localDir.delete(recursive: true);
      }
      await localDir.create(recursive: true);

      var downloadEntity = DownloadModel(
        id: downloadId,
        movieName: movieName,
        episodeName: episodeName,
        thumbnailUrl: thumbnailUrl,
        m3u8Url: m3u8Url,
        localPath: localDir.path,
        status: DownloadStatus.downloading,
        progress: 0.0,
        totalFiles: 0,
        downloadedFiles: 0,
        createdAt: DateTime.now(),
        fileSize: 0,
      );

      _emitProgress(downloadEntity);

      // Tải master playlist
      await _downloadFile(m3u8Url, File('${localDir.path}/index.m3u8'));
      final localM3u8Path = '${localDir.path}/index.m3u8';

      if (_isCancelled(downloadId)) {
        throw Exception('Download đã bị hủy');
      }

      // Phân tích master playlist
      String m3u8Content = await File(localM3u8Path).readAsString();
      debugPrint('Nội dung master .m3u8:\n$m3u8Content');
      final lines = m3u8Content.split('\n');

      // Tìm và tải media playlist
      String? mediaM3u8Path;
      for (var line in lines) {
        if (line.trim().endsWith('.m3u8')) {
          final relativePath = line.trim();
          final mediaM3u8Url =
              Uri.parse(m3u8Url).resolve(relativePath).toString();

          // Tạo thư mục con và tải media .m3u8
          final pathSegments = relativePath.split('/');
          final mediaDirPath =
              '${localDir.path}/${pathSegments.sublist(0, pathSegments.length - 1).join('/')}';
          final mediaDir = Directory(mediaDirPath);
          if (!await mediaDir.exists()) {
            await mediaDir.create(recursive: true);
          }

          final localMediaM3u8Path = '$mediaDirPath/${pathSegments.last}';
          await _downloadFile(mediaM3u8Url, File(localMediaM3u8Path));

          if (_isCancelled(downloadId)) {
            throw Exception('Download đã bị hủy');
          }

          // Phân tích media playlist và tải tất cả file .ts
          final mediaContent = await File(localMediaM3u8Path).readAsString();
          final mediaLines = mediaContent.split('\n');
          final tsFiles =
              mediaLines.where((line) => line.trim().endsWith('.ts')).toList();

          // Cập nhật tổng số file
          downloadEntity = DownloadModel.fromEntity(
              downloadEntity.copyWith(totalFiles: tsFiles.length));
          _emitProgress(downloadEntity);

          // Tải đồng thời với số lượng giới hạn
          int downloadedFiles = 0;
          int totalFileSize = 0;

          for (int i = 0; i < tsFiles.length; i += maxConcurrentDownloads) {
            if (_isCancelled(downloadId)) {
              throw Exception('Download đã bị hủy');
            }

            final batch = tsFiles.sublist(
              i,
              i + maxConcurrentDownloads > tsFiles.length
                  ? tsFiles.length
                  : i + maxConcurrentDownloads,
            );

            final downloads = batch.map((tsRelativePath) async {
              final tsUrl = Uri.parse(mediaM3u8Url)
                  .resolve(tsRelativePath.trim())
                  .toString();

              final tsPathSegments = tsRelativePath.trim().split('/');
              final tsFileName = tsPathSegments.last;
              final tsDirPath = tsPathSegments.length > 1
                  ? '${localDir.path}/${tsPathSegments.sublist(0, tsPathSegments.length - 1).join('/')}'
                  : mediaDirPath;

              final tsDir = Directory(tsDirPath);
              if (!await tsDir.exists()) {
                await tsDir.create(recursive: true);
              }

              final tsFile = File('$tsDirPath/$tsFileName');
              await _downloadFile(tsUrl, tsFile);

              // Cập nhật file size
              final fileSize = await tsFile.length();
              totalFileSize += fileSize;

              downloadedFiles++;

              // Cập nhật tiến độ
              downloadEntity = DownloadModel.fromEntity(downloadEntity.copyWith(
                downloadedFiles: downloadedFiles,
                progress: downloadedFiles / tsFiles.length,
                fileSize: totalFileSize,
              ));
              _emitProgress(downloadEntity);
            });

            await Future.wait(downloads);
          }

          mediaM3u8Path = localMediaM3u8Path;
          break; // Chỉ xử lý luồng đầu tiên
        }
      }

      // Hoàn thành download
      downloadEntity = DownloadModel.fromEntity(downloadEntity.copyWith(
        status: DownloadStatus.completed,
        progress: 1.0,
        completedAt: DateTime.now(),
        localPath: mediaM3u8Path ?? localM3u8Path,
      ));

      _emitProgress(downloadEntity);
      _progressControllers[downloadId]?.close();
      _progressControllers.remove(downloadId);

      return downloadEntity;
    } catch (e) {
      final errorEntity = DownloadModel(
        id: downloadId,
        movieName: movieName,
        episodeName: episodeName,
        thumbnailUrl: thumbnailUrl,
        m3u8Url: m3u8Url,
        localPath: '',
        status: DownloadStatus.failed,
        progress: 0.0,
        totalFiles: 0,
        downloadedFiles: 0,
        createdAt: DateTime.now(),
        errorMessage: e.toString(),
        fileSize: 0,
      );

      _emitProgress(errorEntity);
      _progressControllers[downloadId]?.close();
      _progressControllers.remove(downloadId);

      rethrow;
    }
  }

  // Tải file từ URL với retry logic
  Future<void> _downloadFile(String url, File file, {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {'User-Agent': 'Mozilla/5.0'}, // Giả lập trình duyệt
        );
        await file.writeAsBytes(response.bodyBytes);
        debugPrint('Đã tải: ${file.path}');
        return;
      } catch (e) {
        debugPrint('Lỗi tải $url (lần ${i + 1}/$retries): $e');
        if (i == retries - 1) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  // Phát progress event
  void _emitProgress(DownloadEntity entity) {
    final controller = _progressControllers[entity.id];
    if (controller != null && !controller.isClosed) {
      controller.add(entity);
    }
  }

  // Kiểm tra xem download có bị hủy không
  bool _isCancelled(String downloadId) {
    return _cancelTokens[downloadId] == true;
  }

  // Dọn dẹp resources
  void dispose() {
    for (var controller in _progressControllers.values) {
      if (!controller.isClosed) {
        controller.close();
      }
    }
    _progressControllers.clear();
    _cancelTokens.clear();
  }
}
