part of '../../movie.dart';

class Movie extends StatefulWidget {
  final String url;

  const Movie({super.key, required this.url});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        widget.url,
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PodVideoPlayer(controller: controller),
        ],
      ),
    );
  }
}
