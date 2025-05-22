part of '../../movie.dart';

class Movie extends StatefulWidget {
  final MovieEntity movie;
  final int episodeIndex;
  final int serverIndex;
  final int currentPosition;

  const Movie({
    super.key,
    required this.movie,
    required this.episodeIndex,
    required this.serverIndex,
    required this.currentPosition,
  });

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  late final VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  Timer? _positionTimer;
  Duration _currentPosition = Duration.zero;
  AuthenticationBloc? _authBloc;
  bool _isControllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = context.read<AuthenticationBloc>();
  }

  @override
  void initState() {
    super.initState();
    _hideMiniPlayer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final server = widget.movie.episodes[widget.serverIndex];
    final episode = server.serverData[widget.episodeIndex];
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(episode.linkM3u8));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      allowFullScreen: false,
      fullScreenByDefault: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    _restoreWatchedPosition();
    _startTrackingPosition();
  }

  void _hideMiniPlayer() {
    context.read<MiniPlayerBloc>().add(HideMiniPlayer());
  }

  Future<void> _restoreWatchedPosition() async {
    final currentPositionDuration = Duration(seconds: widget.currentPosition);
    final authState =
        _authBloc?.state ?? context.read<AuthenticationBloc>().state;
    final watchedMovies = authState.user?.watchedMovies ?? [];
    final watchedMovie = watchedMovies.firstWhere(
      (m) => m.movieId == widget.movie.slug,
      orElse: () => WatchedMovie(
        movieId: widget.movie.slug,
        isSeries: widget.movie.episodeTotal != '1',
        name: widget.movie.name,
        thumbUrl: widget.movie.thumbUrl,
        episodeTotal: int.tryParse(widget.movie.episodeTotal) ?? 0,
        time:
            int.tryParse(widget.movie.time.replaceAll(RegExp(r'[^0-9]'), '')) ??
                60,
      ),
    );
    final watchedEpisode =
        watchedMovie.watchedEpisodes[widget.episodeIndex + 1];
    final watchedDuration = watchedEpisode?.duration ?? Duration.zero;

    final initialPosition =
        widget.currentPosition > 0 ? currentPositionDuration : watchedDuration;

    await _videoPlayerController.initialize();
    final videoDuration = _videoPlayerController.value.duration;
    if (initialPosition > videoDuration) {
      _videoPlayerController.seekTo(Duration.zero);
      _currentPosition = Duration.zero;
    } else {
      _videoPlayerController.seekTo(initialPosition);
      _currentPosition = initialPosition;
    }
    _chewieController.enterFullScreen();
    if (mounted) {
      setState(() {
        _isControllerInitialized = true;
      });
    }
  }

  void _startTrackingPosition() {
    _positionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (_videoPlayerController.value.isPlaying) {
        final newPosition = _videoPlayerController.value.position;
        if (newPosition != _currentPosition) {
          setState(() {
            _currentPosition = newPosition;
          });
          _saveWatchedPosition();
        }
      }
    });
  }

  void _saveWatchedPosition() {
    if (_authBloc == null) {
      return;
    }
    final server = widget.movie.episodes[widget.serverIndex];
    _authBloc!.add(
      UpdateWatchedMovieEvent(
        movieId: widget.movie.slug,
        isSeries: widget.movie.episodeTotal != '1',
        episode: widget.episodeIndex + 1,
        watchedDuration: _currentPosition,
        name: widget.movie.name,
        thumbUrl: widget.movie.thumbUrl,
        episodeTotal: int.tryParse(widget.movie.episodeTotal) ?? 0,
        serverName: server.serverName,
        time:
            int.tryParse(widget.movie.time.replaceAll(RegExp(r'[^0-9]'), '')) ??
                60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        await _videoPlayerController.pause();

        if (context.mounted) {
          context.read<MiniPlayerBloc>().add(
                ShowMiniPlayer(
                  movie: widget.movie,
                  controller: _videoPlayerController,
                  episodeIndex: widget.episodeIndex,
                  serverIndex: widget.serverIndex,
                  position: _currentPosition,
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                  ),
                ),
              );
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: _isControllerInitialized
            ? Chewie(
                controller: _chewieController,
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    if (_isControllerInitialized &&
        !context.read<MiniPlayerBloc>().state.isVisible) {
      _videoPlayerController.pause();
      _chewieController.dispose();
      _videoPlayerController.dispose();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
