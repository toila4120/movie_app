import 'dart:async';
import 'dart:io';
import '../../domain/entities/download_entity.dart';
import '../../domain/repositories/download_repository.dart';
import '../datasources/download_local_datasource.dart';
import '../services/hls_download_service.dart';
import '../models/download_model.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  final DownloadLocalDataSource localDataSource;
  final HlsDownloadService downloadService;
  final StreamController<List<DownloadEntity>> _downloadsController =
      StreamController<List<DownloadEntity>>.broadcast();

  DownloadRepositoryImpl({
    required this.localDataSource,
    required this.downloadService,
  }) {
    _initDownloadsStream();
  }

  void _initDownloadsStream() async {
    // Emit initial data
    final downloads = await localDataSource.getAllDownloads();
    _downloadsController.add(downloads);
  }

  @override
  Future<DownloadEntity> startDownload({
    required String movieName,
    required String episodeName,
    required String thumbnailUrl,
    required String m3u8Url,
  }) async {
    try {
      // Tạo unique ID cho download
      final downloadId =
          '${DateTime.now().millisecondsSinceEpoch}_${movieName}_$episodeName'
              .replaceAll(' ', '_')
              .replaceAll(RegExp(r'[^\w\-_]'), '');

      // Tạo download entity ban đầu
      final downloadEntity = DownloadModel(
        id: downloadId,
        movieName: movieName,
        episodeName: episodeName,
        thumbnailUrl: thumbnailUrl,
        m3u8Url: m3u8Url,
        localPath: '',
        status: DownloadStatus.pending,
        progress: 0.0,
        totalFiles: 0,
        downloadedFiles: 0,
        createdAt: DateTime.now(),
        fileSize: 0,
      );

      // Lưu vào database
      await localDataSource.insertDownload(downloadEntity);
      _emitDownloadsUpdate();

      // Bắt đầu download
      downloadService.getDownloadProgress(downloadId).listen((progress) async {
        await localDataSource
            .updateDownload(DownloadModel.fromEntity(progress));
        _emitDownloadsUpdate();
      });

      final result = await downloadService.startDownload(
        downloadId: downloadId,
        movieName: movieName,
        episodeName: episodeName,
        thumbnailUrl: thumbnailUrl,
        m3u8Url: m3u8Url,
      );

      // Cập nhật database với kết quả cuối cùng
      await localDataSource.updateDownload(DownloadModel.fromEntity(result));
      _emitDownloadsUpdate();

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<DownloadEntity>> getAllDownloads() {
    return _downloadsController.stream;
  }

  @override
  Future<void> pauseDownload(String downloadId) async {
    // Tạm dừng download (implementation sẽ được mở rộng)
    downloadService.cancelDownload(downloadId);

    final download = await localDataSource.getDownload(downloadId);
    if (download != null) {
      final updatedDownload = download.copyWith(status: DownloadStatus.paused);
      await localDataSource
          .updateDownload(DownloadModel.fromEntity(updatedDownload));
      _emitDownloadsUpdate();
    }
  }

  @override
  Future<void> resumeDownload(String downloadId) async {
    final download = await localDataSource.getDownload(downloadId);
    if (download != null && download.status == DownloadStatus.paused) {
      // Khởi động lại download
      await startDownload(
        movieName: download.movieName,
        episodeName: download.episodeName,
        thumbnailUrl: download.thumbnailUrl,
        m3u8Url: download.m3u8Url,
      );
    }
  }

  @override
  Future<void> cancelDownload(String downloadId) async {
    downloadService.cancelDownload(downloadId);

    final download = await localDataSource.getDownload(downloadId);
    if (download != null) {
      // Xóa file đã tải
      final directory = Directory(download.localPath);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }

      final updatedDownload =
          download.copyWith(status: DownloadStatus.cancelled);
      await localDataSource
          .updateDownload(DownloadModel.fromEntity(updatedDownload));
      _emitDownloadsUpdate();
    }
  }

  @override
  Future<void> deleteDownload(String downloadId) async {
    final download = await localDataSource.getDownload(downloadId);
    if (download != null) {
      // Xóa file đã tải
      final directory = Directory(download.localPath);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }

      // Xóa khỏi database
      await localDataSource.deleteDownload(downloadId);
      _emitDownloadsUpdate();
    }
  }

  @override
  Future<DownloadEntity?> getDownload(String downloadId) async {
    return await localDataSource.getDownload(downloadId);
  }

  @override
  Future<void> clearAllDownloads() async {
    // Lấy tất cả downloads để xóa file
    final downloads = await localDataSource.getAllDownloads();
    for (final download in downloads) {
      final directory = Directory(download.localPath);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }

    // Xóa tất cả khỏi database
    await localDataSource.clearAllDownloads();
    _emitDownloadsUpdate();
  }

  Future<void> _emitDownloadsUpdate() async {
    final downloads = await localDataSource.getAllDownloads();
    _downloadsController.add(downloads);
  }

  void dispose() {
    _downloadsController.close();
    downloadService.dispose();
  }
}
