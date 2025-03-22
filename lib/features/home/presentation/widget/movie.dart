import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class Movie extends StatefulWidget {
  const Movie({super.key});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  String selectedEpisodeUrl =
      'https://s4.phim1280.tv/20241114/7iGKgSsN/index.m3u8';
  bool isError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() {
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(selectedEpisodeUrl))
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: 16 / 9,
            autoInitialize: true,
            autoPlay: false,
            startAt: const Duration(seconds: 5),
            looping: false,
            allowFullScreen: true,
            allowMuting: true,
            allowPlaybackSpeedChanging: true,
            playbackSpeeds: const [0.5, 1.0, 1.5, 2.0, 4.0],
            customControls: null,
            materialProgressColors: ChewieProgressColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
              bufferedColor: Colors.white30,
              backgroundColor: Colors.grey,
            ),
            showControls: true,
            showControlsOnInitialize: true,
            overlay: Container(
              color: Colors.black26,
              child: const Center(
                  child:
                      Text('Overlay', style: TextStyle(color: Colors.white))),
            ),
            isLive: false,
            subtitle: Subtitles([
              Subtitle(
                index: 0,
                start: Duration.zero,
                end: const Duration(seconds: 5),
                text: 'Xin chào!',
              ),
            ]),
            subtitleBuilder: (context, subtitle) => Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black54,
              child:
                  Text(subtitle, style: const TextStyle(color: Colors.white)),
            ),
            errorBuilder: (context, errorMessage) => Center(
              child: Text('Error: $errorMessage',
                  style: const TextStyle(color: Colors.red)),
            ),
            // additionalOptions: (context) => [
            //   OptionItem(
            //     onTap: () => debugPrint('Custom Option'),
            //     iconData: Icons.settings,
            //     title: 'Settings',
            //   ),
            // ],
            zoomAndPan: true,
            controlsSafeAreaMinimum: const EdgeInsets.all(10.0),
            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
            // deviceOrientationsOnFullScreen: [
            //   DeviceOrientation.landscapeLeft,
            //   DeviceOrientation.landscapeRight,
            // ],
            systemOverlaysAfterFullScreen: [
              SystemUiOverlay.top,
              SystemUiOverlay.bottom
            ],
            // systemOverlaysOnFullScreen: [],
          );
        });
      }).catchError((error) {
        debugPrint('Video error: $error');
        setState(() {
          isError = true;
          errorMessage = error.toString();
        });
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
    return Column(
      children: [
        Expanded(
          child: isError
              ? Center(
                  child: Text('Failed to load video: $errorMessage',
                      style: const TextStyle(color: Colors.red)))
              : (_videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController)
                  : const Center(child: CircularProgressIndicator())),
        ),
      ],
    );
  }
}
