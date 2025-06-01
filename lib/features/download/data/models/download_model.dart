import '../../domain/entities/download_entity.dart';

class DownloadModel extends DownloadEntity {
  const DownloadModel({
    required super.id,
    required super.movieName,
    required super.episodeName,
    required super.thumbnailUrl,
    required super.m3u8Url,
    required super.localPath,
    required super.status,
    required super.progress,
    required super.totalFiles,
    required super.downloadedFiles,
    required super.createdAt,
    super.completedAt,
    super.errorMessage,
    required super.fileSize,
  });

  factory DownloadModel.fromJson(Map<String, dynamic> json) {
    return DownloadModel(
      id: json['id'] as String,
      movieName: json['movieName'] as String,
      episodeName: json['episodeName'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      m3u8Url: json['m3u8Url'] as String,
      localPath: json['localPath'] as String,
      status: DownloadStatus.values[json['status'] as int],
      progress: (json['progress'] as num).toDouble(),
      totalFiles: json['totalFiles'] as int,
      downloadedFiles: json['downloadedFiles'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      errorMessage: json['errorMessage'] as String?,
      fileSize: json['fileSize'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieName': movieName,
      'episodeName': episodeName,
      'thumbnailUrl': thumbnailUrl,
      'm3u8Url': m3u8Url,
      'localPath': localPath,
      'status': status.index,
      'progress': progress,
      'totalFiles': totalFiles,
      'downloadedFiles': downloadedFiles,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorMessage': errorMessage,
      'fileSize': fileSize,
    };
  }

  factory DownloadModel.fromEntity(DownloadEntity entity) {
    return DownloadModel(
      id: entity.id,
      movieName: entity.movieName,
      episodeName: entity.episodeName,
      thumbnailUrl: entity.thumbnailUrl,
      m3u8Url: entity.m3u8Url,
      localPath: entity.localPath,
      status: entity.status,
      progress: entity.progress,
      totalFiles: entity.totalFiles,
      downloadedFiles: entity.downloadedFiles,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      errorMessage: entity.errorMessage,
      fileSize: entity.fileSize,
    );
  }
}
