import '../entities/download_entity.dart';
import '../repositories/download_repository.dart';

class StartDownloadUsecase {
  final DownloadRepository repository;

  StartDownloadUsecase(this.repository);

  Future<DownloadEntity> call({
    required String movieName,
    required String episodeName,
    required String thumbnailUrl,
    required String m3u8Url,
  }) async {
    return await repository.startDownload(
      movieName: movieName,
      episodeName: episodeName,
      thumbnailUrl: thumbnailUrl,
      m3u8Url: m3u8Url,
    );
  }
}
