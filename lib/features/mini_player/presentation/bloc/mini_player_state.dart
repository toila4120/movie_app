part of 'mini_player_bloc.dart';

class MiniPlayerState extends Equatable {
  final bool isVisible;
  final MovieEntity? movie;
  final VideoPlayerController? controller;
  final ChewieController? chewieController;
  final int? episodeIndex;
  final int? serverIndex;
  final Duration? position;
  final Offset miniPlayerPosition;
  final bool isPlay;
  final Duration? currentPosition;

  const MiniPlayerState({
    this.isVisible = false,
    this.movie,
    this.controller,
    this.chewieController,
    this.episodeIndex,
    this.serverIndex,
    this.position,
    this.miniPlayerPosition = const Offset(0, 0),
    this.isPlay = true,
    this.currentPosition,
  });

  MiniPlayerState copyWith({
    bool? isVisible,
    MovieEntity? movie,
    VideoPlayerController? controller,
    ChewieController? chewieController,
    int? episodeIndex,
    int? serverIndex,
    Duration? position,
    Offset? miniPlayerPosition,
    bool? isPlay,
    Duration? currentPosition,
  }) {
    return MiniPlayerState(
      isVisible: isVisible ?? this.isVisible,
      movie: movie ?? this.movie,
      controller: controller ?? this.controller,
      chewieController: chewieController ?? this.chewieController,
      episodeIndex: episodeIndex ?? this.episodeIndex,
      serverIndex: serverIndex ?? this.serverIndex,
      position: position ?? this.position,
      miniPlayerPosition: miniPlayerPosition ?? this.miniPlayerPosition,
      isPlay: isPlay ?? this.isPlay,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }

  @override
  List<Object?> get props => [
        isVisible,
        movie,
        controller,
        chewieController,
        episodeIndex,
        serverIndex,
        position,
        miniPlayerPosition,
        isPlay,
        currentPosition,
      ];
}
