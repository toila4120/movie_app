import 'package:equatable/equatable.dart';

enum DownloadStatus {
  pending,
  downloading,
  completed,
  failed,
  paused,
  cancelled
}

class DownloadEntity extends Equatable {
  final String id;
  final String movieName;
  final String episodeName;
  final String thumbnailUrl;
  final String m3u8Url;
  final String localPath;
  final DownloadStatus status;
  final double progress;
  final int totalFiles;
  final int downloadedFiles;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final int fileSize; // Tính bằng bytes

  const DownloadEntity({
    required this.id,
    required this.movieName,
    required this.episodeName,
    required this.thumbnailUrl,
    required this.m3u8Url,
    required this.localPath,
    required this.status,
    required this.progress,
    required this.totalFiles,
    required this.downloadedFiles,
    required this.createdAt,
    this.completedAt,
    this.errorMessage,
    required this.fileSize,
  });

  DownloadEntity copyWith({
    String? id,
    String? movieName,
    String? episodeName,
    String? thumbnailUrl,
    String? m3u8Url,
    String? localPath,
    DownloadStatus? status,
    double? progress,
    int? totalFiles,
    int? downloadedFiles,
    DateTime? createdAt,
    DateTime? completedAt,
    String? errorMessage,
    int? fileSize,
  }) {
    return DownloadEntity(
      id: id ?? this.id,
      movieName: movieName ?? this.movieName,
      episodeName: episodeName ?? this.episodeName,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      m3u8Url: m3u8Url ?? this.m3u8Url,
      localPath: localPath ?? this.localPath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      totalFiles: totalFiles ?? this.totalFiles,
      downloadedFiles: downloadedFiles ?? this.downloadedFiles,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  @override
  List<Object?> get props => [
        id,
        movieName,
        episodeName,
        thumbnailUrl,
        m3u8Url,
        localPath,
        status,
        progress,
        totalFiles,
        downloadedFiles,
        createdAt,
        completedAt,
        errorMessage,
        fileSize,
      ];
}
