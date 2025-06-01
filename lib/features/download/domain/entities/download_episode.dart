class DownloadEpisode {
  final String episodeId;
  final String title;
  final String url;
  final bool isDownloading;
  final double progress;
  final String? localPath;

  DownloadEpisode({
    required this.episodeId,
    required this.title,
    required this.url,
    this.isDownloading = false,
    this.progress = 0.0,
    this.localPath,
  });

  DownloadEpisode copyWith({
    String? episodeId,
    String? title,
    String? url,
    bool? isDownloading,
    double? progress,
    String? localPath,
  }) {
    return DownloadEpisode(
      episodeId: episodeId ?? this.episodeId,
      title: title ?? this.title,
      url: url ?? this.url,
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      localPath: localPath ?? this.localPath,
    );
  }
}
