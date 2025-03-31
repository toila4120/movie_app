import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/core.dart';
import 'package:video_player/video_player.dart';

class Movie extends StatefulWidget {
  final String url;

  const Movie({super.key, required this.url});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  late FlickManager flickManager;
  late FlickPlayToggle playToggle;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse(widget.url)),
      autoPlay: false,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: const FlickVideoWithControls(
                controls: FlickPortraitControls(),
                videoFit: BoxFit.contain,
                aspectRatioWhenLoading: 16 / 9,
              ),
              flickVideoWithControlsFullscreen: const FlickVideoWithControls(
                controls: FlickLandscapeControls(),
              ),
              preferredDeviceOrientation: const [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ],
            ),
            Positioned(
              top: 8,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomAppButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      AppImage.icBack,
                      color: AppColor.white,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  CustomAppButton(
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                    child: Image.asset(
                      AppImage.icEdit,
                      color: AppColor.white,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
