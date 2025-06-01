part of 'download_bloc.dart';

sealed class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class StartDownloadEvent extends DownloadEvent {
  final String movieName;
  final String episodeName;
  final String thumbnailUrl;
  final String m3u8Url;

  const StartDownloadEvent({
    required this.movieName,
    required this.episodeName,
    required this.thumbnailUrl,
    required this.m3u8Url,
  });

  @override
  List<Object> get props => [movieName, episodeName, thumbnailUrl, m3u8Url];
}

class LoadDownloadsEvent extends DownloadEvent {}

class PauseDownloadEvent extends DownloadEvent {
  final String downloadId;

  const PauseDownloadEvent(this.downloadId);

  @override
  List<Object> get props => [downloadId];
}

class ResumeDownloadEvent extends DownloadEvent {
  final String downloadId;

  const ResumeDownloadEvent(this.downloadId);

  @override
  List<Object> get props => [downloadId];
}

class CancelDownloadEvent extends DownloadEvent {
  final String downloadId;

  const CancelDownloadEvent(this.downloadId);

  @override
  List<Object> get props => [downloadId];
}

class DeleteDownloadEvent extends DownloadEvent {
  final String downloadId;

  const DeleteDownloadEvent(this.downloadId);

  @override
  List<Object> get props => [downloadId];
}

class ClearAllDownloadsEvent extends DownloadEvent {}

class DownloadUpdatedEvent extends DownloadEvent {
  final List<DownloadEntity> downloads;

  const DownloadUpdatedEvent(this.downloads);

  @override
  List<Object> get props => [downloads];
}
