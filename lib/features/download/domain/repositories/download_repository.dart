import '../entities/download_entity.dart';

abstract class DownloadRepository {
  // Bắt đầu download video
  Future<DownloadEntity> startDownload({
    required String movieName,
    required String episodeName,
    required String thumbnailUrl,
    required String m3u8Url,
  });

  // Lấy danh sách tất cả downloads
  Stream<List<DownloadEntity>> getAllDownloads();

  // Tạm dừng download
  Future<void> pauseDownload(String downloadId);

  // Tiếp tục download
  Future<void> resumeDownload(String downloadId);

  // Hủy download
  Future<void> cancelDownload(String downloadId);

  // Xóa download đã hoàn thành
  Future<void> deleteDownload(String downloadId);

  // Lấy chi tiết một download
  Future<DownloadEntity?> getDownload(String downloadId);

  // Xóa tất cả downloads
  Future<void> clearAllDownloads();
}
