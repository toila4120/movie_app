part of 'download_bloc.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

final class DownloadInitial extends DownloadState {}

final class DownloadLoading extends DownloadState {}

final class DownloadLoaded extends DownloadState {
  final List<DownloadEntity> downloads;

  const DownloadLoaded(this.downloads);

  @override
  List<Object> get props => [downloads];
}

final class DownloadError extends DownloadState {
  final String message;

  const DownloadError(this.message);

  @override
  List<Object> get props => [message];
}

final class DownloadStarted extends DownloadState {
  final String message;

  const DownloadStarted(this.message);

  @override
  List<Object> get props => [message];
}
