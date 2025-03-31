import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class Movie extends StatefulWidget {
  final String url;

  const Movie({
    super.key,
    required this.url,
  });

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool isError = false;
  String errorMessage = '';
  bool isBuffering = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url))
          ..initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController,
                autoPlay: false,
                showControls: true,
                aspectRatio: _videoPlayerController.value.aspectRatio,
                hideControlsTimer: const Duration(milliseconds: 3000),
                placeholder: Container(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      'Đang tải video...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                showOptions: true,
                allowMuting: true,
                allowPlaybackSpeedChanging: true,
                allowedScreenSleep: false,
              );
            });
          }).catchError((error) {
            setState(() {
              isError = true;
              errorMessage = error.toString();
            });
          });

    _videoPlayerController.addListener(() {
      final newBufferingState = _videoPlayerController.value.isBuffering;
      if (isBuffering != newBufferingState) {
        setState(() {
          isBuffering = newBufferingState;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isError
                ? Center(
                    child: Text(
                      'Failed to load video: $errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : (_videoPlayerController.value.isInitialized
                    ? Stack(
                        children: [
                          Chewie(controller: _chewieController),
                          if (isBuffering)
                            Container(
                              color: Colors.black54,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ),
                        ],
                      )
                    : Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
