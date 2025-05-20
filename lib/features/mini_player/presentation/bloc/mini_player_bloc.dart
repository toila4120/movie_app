import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:video_player/video_player.dart';

part 'mini_player_event.dart';
part 'mini_player_state.dart';

class MiniPlayerBloc extends Bloc<MiniPlayerEvent, MiniPlayerState> {
  Timer? _positionTimer;
  final AuthenticationBloc authenticationBloc;

  MiniPlayerBloc({
    required this.authenticationBloc,
  }) : super(const MiniPlayerState()) {
    on<ShowMiniPlayer>(_onShowMiniPlayer);
    on<HideMiniPlayer>(_onHideMiniPlayer);
    on<UpdateMiniPlayerPosition>(_onUpdateMiniPlayerPosition);
    on<SetPlay>(_onSetPlay);
    on<UpdateCurrentPosition>(_onUpdateCurrentPosition);
    on<MaximizeMiniPlayer>(_onMaximizeMiniPlayer);
  }

  void _onShowMiniPlayer(ShowMiniPlayer event, Emitter<MiniPlayerState> emit) {
    _positionTimer?.cancel();

    final chewieController = ChewieController(
      videoPlayerController: event.controller,
      autoInitialize: false,
      autoPlay: true,
      looping: false,
      showControls: false,
      showControlsOnInitialize: false,
      allowPlaybackSpeedChanging: false,
      allowFullScreen: false,
      allowMuting: false,
    );

    emit(state.copyWith(
      isVisible: true,
      movie: event.movie,
      controller: event.controller,
      chewieController: chewieController,
      episodeIndex: event.episodeIndex,
      serverIndex: event.serverIndex,
      position: event.position,
      currentPosition: event.position,
      miniPlayerPosition: Offset(
        event.size.width - 200.w,
        event.size.height - 120.w - 50.w,
      ),
    ));

    _startTrackingPosition(event.controller, emit);
  }

  void _onHideMiniPlayer(HideMiniPlayer event, Emitter<MiniPlayerState> emit) {
    _positionTimer?.cancel();
    state.controller?.pause();
    state.chewieController?.dispose();
    emit(const MiniPlayerState());
  }

  void _onUpdateMiniPlayerPosition(
      UpdateMiniPlayerPosition event, Emitter<MiniPlayerState> emit) {
    emit(state.copyWith(miniPlayerPosition: event.position));
  }

  void _onSetPlay(SetPlay event, Emitter<MiniPlayerState> emit) {
    emit(state.copyWith(isPlay: event.isPlay));
  }

  void _onUpdateCurrentPosition(
      UpdateCurrentPosition event, Emitter<MiniPlayerState> emit) {
    emit(state.copyWith(currentPosition: event.position));
    _saveWatchedPosition();
  }

  void _onMaximizeMiniPlayer(
      MaximizeMiniPlayer event, Emitter<MiniPlayerState> emit) {
    AppRouter.router.push(AppRouter.playMoviePath, extra: {
      'movie': state.movie,
      'episodeIndex': state.episodeIndex,
      'serverIndex': state.serverIndex,
      'currentPosition': state.controller!.value.position.inSeconds,
    });

    _positionTimer?.cancel();
    state.controller?.pause();
    state.chewieController?.dispose();
    emit(const MiniPlayerState());
  }

  void _startTrackingPosition(
      VideoPlayerController controller, Emitter<MiniPlayerState> emit) {
    _positionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (controller.value.isPlaying) {
        add(UpdateCurrentPosition(controller.value.position));
      }
    });
  }

  void _saveWatchedPosition() {
    if (state.movie == null || state.currentPosition == null) return;

    final server = state.movie!.episodes[state.serverIndex!];
    authenticationBloc.add(
      UpdateWatchedMovieEvent(
        movieId: state.movie!.slug,
        isSeries: state.movie!.episodeTotal != '1',
        episode: state.episodeIndex! + 1,
        watchedDuration: state.currentPosition!,
        name: state.movie!.name,
        thumbUrl: state.movie!.thumbUrl,
        episodeTotal: int.tryParse(state.movie!.episodeTotal) ?? 0,
        serverName: server.serverName,
        time:
            int.tryParse(state.movie!.time.replaceAll(RegExp(r'[^0-9]'), '')) ??
                60,
      ),
    );
  }

  @override
  Future<void> close() {
    _positionTimer?.cancel();
    return super.close();
  }
}
