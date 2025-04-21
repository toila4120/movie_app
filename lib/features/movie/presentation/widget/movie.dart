part of '../../movie.dart';

class Movie extends StatefulWidget {
  final String url;

  const Movie({super.key, required this.url});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  late final VideoPlayerController _videoPlayerController;
  late final ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      allowFullScreen: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Chewie(controller: _chewieController),
            ),
          ],
        ),
      ),
    );
  }
}
