import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/download_entity.dart';
import '../../domain/repositories/download_repository.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadRepository downloadRepository;
  StreamSubscription<List<DownloadEntity>>? _downloadsSubscription;

  DownloadBloc({required this.downloadRepository}) : super(DownloadInitial()) {
    on<StartDownloadEvent>(_onStartDownload);
    on<LoadDownloadsEvent>(_onLoadDownloads);
    on<PauseDownloadEvent>(_onPauseDownload);
    on<ResumeDownloadEvent>(_onResumeDownload);
    on<CancelDownloadEvent>(_onCancelDownload);
    on<DeleteDownloadEvent>(_onDeleteDownload);
    on<ClearAllDownloadsEvent>(_onClearAllDownloads);
    on<DownloadUpdatedEvent>(_onDownloadUpdated);

    // Đăng ký stream để lắng nghe cập nhật downloads
    _downloadsSubscription = downloadRepository.getAllDownloads().listen(
          (downloads) => add(DownloadUpdatedEvent(downloads)),
        );
  }

  Future<void> _onStartDownload(
    StartDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      emit(DownloadLoading());
      await downloadRepository.startDownload(
        movieName: event.movieName,
        episodeName: event.episodeName,
        thumbnailUrl: event.thumbnailUrl,
        m3u8Url: event.m3u8Url,
      );
      emit(const DownloadStarted('Đã bắt đầu tải video'));
    } catch (e) {
      emit(DownloadError('Lỗi khi bắt đầu tải: ${e.toString()}'));
    }
  }

  Future<void> _onLoadDownloads(
    LoadDownloadsEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      emit(DownloadLoading());
      // Stream sẽ tự động emit dữ liệu thông qua DownloadUpdatedEvent
    } catch (e) {
      emit(DownloadError('Lỗi khi tải danh sách: ${e.toString()}'));
    }
  }

  Future<void> _onPauseDownload(
    PauseDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await downloadRepository.pauseDownload(event.downloadId);
    } catch (e) {
      emit(DownloadError('Lỗi khi tạm dừng: ${e.toString()}'));
    }
  }

  Future<void> _onResumeDownload(
    ResumeDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await downloadRepository.resumeDownload(event.downloadId);
    } catch (e) {
      emit(DownloadError('Lỗi khi tiếp tục: ${e.toString()}'));
    }
  }

  Future<void> _onCancelDownload(
    CancelDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await downloadRepository.cancelDownload(event.downloadId);
    } catch (e) {
      emit(DownloadError('Lỗi khi hủy: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteDownload(
    DeleteDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await downloadRepository.deleteDownload(event.downloadId);
    } catch (e) {
      emit(DownloadError('Lỗi khi xóa: ${e.toString()}'));
    }
  }

  Future<void> _onClearAllDownloads(
    ClearAllDownloadsEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await downloadRepository.clearAllDownloads();
    } catch (e) {
      emit(DownloadError('Lỗi khi xóa tất cả: ${e.toString()}'));
    }
  }

  void _onDownloadUpdated(
    DownloadUpdatedEvent event,
    Emitter<DownloadState> emit,
  ) {
    emit(DownloadLoaded(event.downloads));
  }

  @override
  Future<void> close() {
    _downloadsSubscription?.cancel();
    return super.close();
  }
}
