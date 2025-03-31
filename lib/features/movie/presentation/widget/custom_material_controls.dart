import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomMaterialControls extends StatefulWidget {
  final ChewieController controller; // Thêm tham số controller

  const CustomMaterialControls({
    super.key,
    required this.controller, // Đánh dấu là bắt buộc
  });

  @override
  State<CustomMaterialControls> createState() => _CustomMaterialControlsState();
}

class _CustomMaterialControlsState extends State<CustomMaterialControls> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChewieControllerProvider(
      controller:
          widget.controller, // Truyền controller vào ChewieControllerProvider
      child: Builder(
        builder: (context) {
          final chewieController = ChewieController.of(context);
          final videoPlayerController = chewieController.videoPlayerController;

          return GestureDetector(
            onTap: _toggleControls,
            child: Stack(
              children: [
                // Hiển thị video
                Center(
                  child: AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController),
                  ),
                ),
                // Điều khiển video (play, pause, seek, v.v.)
                _buildControls(
                    context, chewieController, videoPlayerController),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    ChewieController chewieController,
    VideoPlayerController videoPlayerController,
  ) {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Stack(
        children: [
          // Nền điều khiển
          Container(
            color: Colors.black54,
          ),
          // Nút tua lùi, play/pause, tua tiến ở giữa
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10,
                      color: Colors.white, size: 32.0),
                  onPressed: () {
                    final currentPosition =
                        videoPlayerController.value.position;
                    videoPlayerController
                        .seekTo(currentPosition - const Duration(seconds: 10));
                    _startHideControlsTimer();
                  },
                ),
                IconButton(
                  icon: Icon(
                    videoPlayerController.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 48.0,
                  ),
                  onPressed: () {
                    if (videoPlayerController.value.isPlaying) {
                      chewieController.pause();
                    } else {
                      chewieController.play();
                    }
                    _startHideControlsTimer();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10,
                      color: Colors.white, size: 32.0),
                  onPressed: () {
                    final currentPosition =
                        videoPlayerController.value.position;
                    videoPlayerController
                        .seekTo(currentPosition + const Duration(seconds: 10));
                    _startHideControlsTimer();
                  },
                ),
              ],
            ),
          ),
          // Thanh điều khiển dưới cùng (seek bar, time, v.v.)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  // Thời gian hiện tại
                  Text(
                    _formatDuration(videoPlayerController.value.position),
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                  const SizedBox(width: 8.0),
                  // Thanh tua video
                  Expanded(
                    child: VideoProgressIndicator(
                      videoPlayerController,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Thời gian tổng
                  Text(
                    _formatDuration(videoPlayerController.value.duration),
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                  const SizedBox(width: 8.0),
                  // Nút toàn màn hình
                  IconButton(
                    icon: Icon(
                      chewieController.isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (chewieController.isFullScreen) {
                        chewieController.exitFullScreen();
                      } else {
                        chewieController.enterFullScreen();
                      }
                      _startHideControlsTimer();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
