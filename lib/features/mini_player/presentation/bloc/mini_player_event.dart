part of 'mini_player_bloc.dart';

abstract class MiniPlayerEvent extends Equatable {
  const MiniPlayerEvent();

  @override
  List<Object?> get props => [];
}

class ShowMiniPlayer extends MiniPlayerEvent {
  final MovieEntity movie;
  final VideoPlayerController controller;
  final int episodeIndex;
  final int serverIndex;
  final Duration position;
  final Size size;

  const ShowMiniPlayer({
    required this.movie,
    required this.controller,
    required this.episodeIndex,
    required this.serverIndex,
    required this.position,
    required this.size,
  });

  @override
  List<Object?> get props => [
        movie,
        controller,
        episodeIndex,
        serverIndex,
        position,
        size,
      ];
}

class HideMiniPlayer extends MiniPlayerEvent {}

class UpdateMiniPlayerPosition extends MiniPlayerEvent {
  final Offset position;

  const UpdateMiniPlayerPosition(this.position);

  @override
  List<Object?> get props => [position];
}

class SetPlay extends MiniPlayerEvent {
  final bool isPlay;

  const SetPlay({required this.isPlay});

  @override
  List<Object?> get props => [isPlay];
}

class UpdateCurrentPosition extends MiniPlayerEvent {
  final Duration position;

  const UpdateCurrentPosition(this.position);

  @override
  List<Object?> get props => [position];
}

class MaximizeMiniPlayer extends MiniPlayerEvent {
  const MaximizeMiniPlayer();

  @override
  List<Object?> get props => [];
}