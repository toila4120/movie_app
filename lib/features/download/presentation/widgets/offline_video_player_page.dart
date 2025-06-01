import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'dart:async';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/features/mini_player/presentation/bloc/mini_player_bloc.dart';
import '../../domain/entities/download_entity.dart';

class OfflineVideoPlayerPage extends StatefulWidget {
  final DownloadEntity episode;
  final List<DownloadEntity> allEpisodes;
  final int currentIndex;

  const OfflineVideoPlayerPage({
    super.key,
    required this.episode,
    required this.allEpisodes,
    required this.currentIndex,
  });

  @override
  State<OfflineVideoPlayerPage> createState() => _OfflineVideoPlayerPageState();
}

class _OfflineVideoPlayerPageState extends State<OfflineVideoPlayerPage> {
  late final VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  Timer? _positionTimer;
  Duration _currentPosition = Duration.zero;
  bool _isControllerInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  int _currentEpisodeIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _currentEpisodeIndex = widget.currentIndex;
    _hideMiniPlayer();
    _initializePlayer();
  }

  void _hideMiniPlayer() {
    context.read<MiniPlayerBloc>().add(HideMiniPlayer());
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _isControllerInitialized = false;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final currentEpisode = widget.allEpisodes[_currentEpisodeIndex];

      // Check if file exists
      if (currentEpisode.localPath.isEmpty) {
        throw Exception('Đường dẫn file không hợp lệ');
      }

      final file = File(currentEpisode.localPath);
      if (!await file.exists()) {
        throw Exception(
            'File video không tồn tại: ${currentEpisode.localPath}');
      }

      // Dispose previous controllers
      _positionTimer?.cancel();
      if (_isControllerInitialized) {
        _chewieController.dispose();
        await _videoPlayerController.dispose();
      }

      // Set fullscreen orientation
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      // Initialize new controller
      _videoPlayerController = VideoPlayerController.file(file);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        autoPlay: false,
        allowFullScreen: false,
        fullScreenByDefault: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColor.primaryDark,
          handleColor: AppColor.primaryDark,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white70,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'Lỗi phát video',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _initializePlayer(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryDark,
                  ),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        },
      );

      await _restoreWatchedPosition();
      _startTrackingPosition();

      setState(() {
        _isControllerInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _restoreWatchedPosition() async {
    try {

      // Cho offline video, có thể lưu position trong SharedPreferences
      // Hiện tại sẽ bắt đầu từ đầu
      await _videoPlayerController.initialize();
      await _videoPlayerController.seekTo(Duration.zero);
      _currentPosition = Duration.zero;

      _chewieController.enterFullScreen();
    } catch (e) {
      print('Error restoring position: $e');
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
    // TODO: Implement saving position for offline videos
    // Có thể lưu vào SharedPreferences hoặc local database
    print(
        'Saving position: $_currentPosition for episode: ${widget.allEpisodes[_currentEpisodeIndex].episodeName}');
  }

  void _playNextEpisode() {
    if (_currentEpisodeIndex < widget.allEpisodes.length - 1) {
      setState(() {
        _currentEpisodeIndex++;
      });
      _initializePlayer();
    }
  }

  void _playPreviousEpisode() {
    if (_currentEpisodeIndex > 0) {
      setState(() {
        _currentEpisodeIndex--;
      });
      _initializePlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Restore portrait orientation
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        // Pause video
        await _videoPlayerController.pause();

        if (context.mounted) {
          // Show mini player
          context.read<MiniPlayerBloc>().add(
                ShowMiniPlayer(
                  movie: _createMovieEntityFromEpisode(),
                  controller: _videoPlayerController,
                  episodeIndex: _currentEpisodeIndex,
                  serverIndex: 0, // For offline, we don't have server index
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
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // Main video player
              if (_isControllerInitialized && !_hasError)
                Chewie(controller: _chewieController)
              else if (_hasError)
                _buildErrorWidget()
              else
                _buildLoadingWidget(),

              // Episode navigation overlay
              if (_isControllerInitialized && !_hasError)
                _buildEpisodeNavigationOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColor.primaryDark),
            SizedBox(height: 16),
            Text(
              'Đang khởi tạo video player...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Lỗi phát video offline',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Không thể phát video này',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initializePlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryDark,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeNavigationOverlay() {
    if (widget.allEpisodes.length <= 1) return const SizedBox.shrink();

    return Positioned(
      top: 50,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            // Previous episode
            if (_currentEpisodeIndex > 0)
              IconButton(
                onPressed: _playPreviousEpisode,
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 30,
                ),
              ),

            // Episode info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Text(
                '${_currentEpisodeIndex + 1}/${widget.allEpisodes.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Next episode
            if (_currentEpisodeIndex < widget.allEpisodes.length - 1)
              IconButton(
                onPressed: _playNextEpisode,
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Create a mock movie entity for mini player
  dynamic _createMovieEntityFromEpisode() {
    final currentEpisode = widget.allEpisodes[_currentEpisodeIndex];

    // Create a mock movie entity with necessary fields for mini player
    return MockMovieEntity(
      name: currentEpisode.movieName,
      thumbUrl: currentEpisode.thumbnailUrl,
      episodeTotal: widget.allEpisodes.length.toString(),
      episodes: widget.allEpisodes
          .map((e) => MockEpisode(
                serverName: 'Offline',
                serverData: [
                  MockEpisodeData(
                    name: e.episodeName,
                    linkM3u8: e.localPath, // Use local path for offline
                  )
                ],
              ))
          .toList(),
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

    // Restore orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }
}

// Mock classes for mini player compatibility
class MockMovieEntity {
  final String name;
  final String thumbUrl;
  final String episodeTotal;
  final List<MockEpisode> episodes;

  MockMovieEntity({
    required this.name,
    required this.thumbUrl,
    required this.episodeTotal,
    required this.episodes,
  });
}

class MockEpisode {
  final String serverName;
  final List<MockEpisodeData> serverData;

  MockEpisode({
    required this.serverName,
    required this.serverData,
  });
}

class MockEpisodeData {
  final String name;
  final String linkM3u8;

  MockEpisodeData({
    required this.name,
    required this.linkM3u8,
  });
}
