import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/mini_player/presentation/bloc/mini_player_bloc.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      builder: (context, state) {
        if (!state.isVisible ||
            state.controller == null ||
            state.chewieController == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: state.miniPlayerPosition.dx,
          top: state.miniPlayerPosition.dy,
          child: Draggable(
            feedback: _buildMiniPlayer(context, state),
            childWhenDragging: const SizedBox.shrink(),
            onDragEnd: (details) {
              final screenSize = MediaQuery.of(context).size;
              double newDx = details.offset.dx.clamp(
                0,
                screenSize.width - 200.w,
              );
              double newDy = details.offset.dy.clamp(
                  0,
                  screenSize.height -
                      120 -
                      MediaQuery.of(context).padding.bottom.w);
              context
                  .read<MiniPlayerBloc>()
                  .add(UpdateMiniPlayerPosition(Offset(newDx, newDy)));
            },
            child: _buildMiniPlayer(context, state),
          ),
        );
      },
    );
  }

  Widget _buildMiniPlayer(BuildContext context, MiniPlayerState state) {
    return Container(
      width: 200.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Chewie(
              controller: state.chewieController!,
            ),
          ),
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.zoom_out_map_outlined,
                    color: Colors.white,
                    size: 20.w,
                  ),
                  onPressed: () {
                    context
                        .read<MiniPlayerBloc>()
                        .add(const MaximizeMiniPlayer());
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20.w,
                  ),
                  onPressed: () {
                    context.read<MiniPlayerBloc>().add(HideMiniPlayer());
                  },
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Center(
              child: BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(
                      state.isPlay ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      context
                          .read<MiniPlayerBloc>()
                          .add(SetPlay(isPlay: !state.isPlay));
                      if (state.isPlay) {
                        state.controller!.pause();
                      } else {
                        state.controller!.play();
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
