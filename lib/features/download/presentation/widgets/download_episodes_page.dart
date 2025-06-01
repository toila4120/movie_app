import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import '../../domain/entities/download_entity.dart';
import '../../data/services/download_cache_service.dart';
import '../../di/download_injection.dart';
import '../bloc/download_bloc.dart';
import 'offline_video_helper.dart';
import 'optimized_episode_status_widget.dart';

class DownloadEpisodesPage extends StatefulWidget {
  final dynamic movie;

  const DownloadEpisodesPage({
    super.key,
    required this.movie,
  });

  @override
  State<DownloadEpisodesPage> createState() => _DownloadEpisodesPageState();
}

class _DownloadEpisodesPageState extends State<DownloadEpisodesPage> {
  late final DownloadCacheService _cacheService;
  int _selectedServerIndex = 0;
  List<DownloadEntity> _downloads = [];
  late dynamic movie;
  bool _isLoadingStatus = false;
  Map<String, DownloadStatus> _cachedStatusMap = {};

  @override
  void initState() {
    super.initState();
    _cacheService = downloadGetIt<DownloadCacheService>();
    movie = widget.movie;

    // Preload cache for this movie ngay khi init
    _preloadMovieCache();
  }

  Future<void> _preloadMovieCache() async {
    if (movie?.name == null) return;

    setState(() {
      _isLoadingStatus = true;
    });

    try {
      // Load trạng thái của server đầu tiên
      if (movie.episodes != null && movie.episodes.isNotEmpty) {
        final firstServer = movie.episodes[0];
        final episodes = firstServer.serverData ?? [];

        if (episodes.isNotEmpty) {
          final episodeNames = episodes.map<String>((episode) {
            return episode.name ?? 'Episode ${episode.filename ?? ''}';
          }).toList();

          // Timeout để tránh loading vô hạn
          final statusMap = await _cacheService
              .getEpisodesStatusBatch(
            movie.name,
            episodeNames,
          )
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint('Load episodes status timeout');
              return <String, DownloadStatus>{};
            },
          );

          if (mounted) {
            setState(() {
              _cachedStatusMap = statusMap;
              _isLoadingStatus = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoadingStatus = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingStatus = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error preloading movie cache: $e');
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    }
  }

  Future<void> _onServerChanged(int newIndex) async {
    if (newIndex == _selectedServerIndex) return;

    setState(() {
      _selectedServerIndex = newIndex;
      _isLoadingStatus = true;
    });

    try {
      final selectedServer = movie.episodes[newIndex];
      final episodes = selectedServer.serverData ?? [];

      if (episodes.isNotEmpty) {
        final episodeNames = episodes.map<String>((episode) {
          return episode.name ?? 'Episode ${episode.filename ?? ''}';
        }).toList();

        // Timeout để tránh loading vô hạn
        final statusMap = await _cacheService
            .getEpisodesStatusBatch(
          movie.name,
          episodeNames,
        )
            .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('Load episodes status timeout on server change');
            return <String, DownloadStatus>{};
          },
        );

        if (mounted) {
          setState(() {
            _cachedStatusMap = statusMap;
            _isLoadingStatus = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingStatus = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error changing server: $e');
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tải xuống',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              movie?.name ?? 'Unknown',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              OfflineVideoHelper.openDownloadedMovies(context);
            },
          ),
        ],
      ),
      body: BlocListener<DownloadBloc, DownloadState>(
        listener: (context, state) {
          if (state is DownloadLoaded) {
            setState(() {
              _downloads = state.downloads;
            });
          } else if (state is DownloadStarted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is DownloadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Column(
          children: [
            // Movie info header
            _buildMovieHeader(movie),

            // Server selection
            if (movie?.episodes != null && movie.episodes.length > 1)
              _buildServerSelection(movie),

            // Episodes grid
            Expanded(
              child: _buildEpisodesGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieHeader(dynamic movie) {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.greyScale800,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Movie thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: movie?.posterUrl ?? '',
              width: 80.w,
              height: 100.h,
              fit: BoxFit.fill,
              placeholder: (context, url) => Container(
                width: 80.w,
                height: 100.h,
                color: AppColor.greyScale700,
                child: Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: 24.r,
                ),
              ),
              errorWidget: (context, url, error) {
                // Log error for debugging
                debugPrint('CachedNetworkImage error: $error');
                return Container(
                  width: 80.w,
                  height: 100.h,
                  color: AppColor.greyScale700,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 20.r,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Ảnh lỗi',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
              // Add cache options to handle corrupted cache
              cacheKey: movie?.posterUrl?.isNotEmpty == true
                  ? Uri.parse(movie.posterUrl).pathSegments.last
                  : null,
              fadeInDuration: const Duration(milliseconds: 200),
              fadeOutDuration: const Duration(milliseconds: 200),
            ),
          ),
          SizedBox(width: 16.w),

          // Movie info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie?.name ?? 'Unknown Movie',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                if (movie?.episodeTotal != null)
                  Row(
                    children: [
                      Icon(
                        Icons.video_collection,
                        color: AppColor.primaryDark,
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${movie.episodeTotal} tập',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 4.h),
                if (movie?.time != null)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColor.primaryDark,
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        movie.time,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerSelection(dynamic movie) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.greyScale800,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn server tải xuống',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: movie.episodes.asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final server = entry.value;
              final isSelected = index == _selectedServerIndex;

              return GestureDetector(
                onTap: () {
                  _onServerChanged(index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.primaryDark
                        : AppColor.greyScale700,
                    borderRadius: BorderRadius.circular(20.r),
                    border: isSelected
                        ? Border.all(color: AppColor.primaryDark)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dns,
                        color: isSelected ? Colors.white : Colors.white70,
                        size: 16.r,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        server.serverName ?? 'Server ${index + 1}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 14.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesGrid() {
    if (movie.episodes == null ||
        movie.episodes.isEmpty ||
        _selectedServerIndex >= movie.episodes.length) {
      return const Center(
        child: Text(
          'Không có tập nào để tải xuống',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final selectedServer = movie.episodes[_selectedServerIndex];
    final episodes = selectedServer.serverData ?? [];

    if (episodes.isEmpty) {
      return const Center(
        child: Text(
          'Server này không có tập nào',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tập phim - ${selectedServer.serverName}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: _isLoadingStatus
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                            color: AppColor.primaryDark),
                        const SizedBox(height: 16),
                        const Text(
                          'Đang tải trạng thái tập phim...',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            // Force refresh khi user bấm
                            setState(() {
                              _isLoadingStatus = true;
                            });

                            try {
                              await _cacheService
                                  .forceRefreshMovieCache(movie.name);
                              await _preloadMovieCache();
                            } catch (e) {
                              // Fallback: hiển thị episodes không có status
                              setState(() {
                                _isLoadingStatus = false;
                                _cachedStatusMap = {};
                              });
                            }
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: episodes.length,
                    itemBuilder: (context, index) {
                      final episode = episodes[index];
                      final episodeName =
                          episode.name ?? 'Episode ${episode.filename ?? ''}';
                      return _buildOptimizedEpisodeCard(
                        movie,
                        episode,
                        selectedServer.serverName,
                        _cachedStatusMap[episodeName],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizedEpisodeCard(
    dynamic movie,
    dynamic episode,
    String? serverName,
    DownloadStatus? status,
  ) {
    return OptimizedEpisodeStatusWidget(
      movieName: movie.name ?? '',
      episodeName: episode.name ?? '',
      serverName: serverName,
      onTap: status?.isCompleted == true || status?.isDownloading == true
          ? null
          : () => _startDownload(movie, episode, serverName),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColor.greyScale800,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                episode.name ?? 'Episode ${episode.filename ?? ''}',
                style: TextStyle(
                  color:
                      status?.isCompleted == true ? Colors.green : Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeCard(dynamic movie, dynamic episode, String? serverName) {
    // Kiểm tra xem tập này đã được download chưa
    final isDownloaded =
        _isEpisodeDownloaded(movie.name, episode.name, serverName);
    final downloadStatus =
        _getEpisodeDownloadStatus(movie.name, episode.name, serverName);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.greyScale800,
        borderRadius: BorderRadius.circular(12.r),
        border: isDownloaded ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: isDownloaded || downloadStatus == DownloadStatus.downloading
              ? null
              : () => _startDownload(movie, episode, serverName),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    episode.name ?? 'Episode ${episode.filename ?? ''}',
                    style: TextStyle(
                      color: isDownloaded ? Colors.green : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8.w),
                _buildDownloadIcon(downloadStatus),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadIcon(DownloadStatus? status) {
    switch (status) {
      case DownloadStatus.completed:
        return Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 20.r,
        );
      case DownloadStatus.downloading:
        return SizedBox(
          width: 20.r,
          height: 20.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor.primaryDark,
          ),
        );
      case DownloadStatus.failed:
        return Icon(
          Icons.error,
          color: Colors.red,
          size: 20.r,
        );
      case DownloadStatus.paused:
        return Icon(
          Icons.pause_circle,
          color: Colors.orange,
          size: 20.r,
        );
      default:
        return Icon(
          Icons.download,
          color: AppColor.primaryDark,
          size: 20.r,
        );
    }
  }

  bool _isEpisodeDownloaded(
      String movieName, String episodeName, String? serverName) {
    // Tạo episode name với server để so sánh
    final episodeNameWithServer =
        serverName != null ? '$episodeName ($serverName)' : episodeName;

    return _downloads.any((download) =>
        download.movieName == movieName &&
        (download.episodeName == episodeName ||
            download.episodeName == episodeNameWithServer) &&
        download.status == DownloadStatus.completed);
  }

  DownloadStatus? _getEpisodeDownloadStatus(
      String movieName, String episodeName, String? serverName) {
    final download = _findDownload(movieName, episodeName, serverName);
    return download?.status;
  }

  DownloadEntity? _findDownload(
      String movieName, String episodeName, String? serverName) {
    // Tạo episode name với server để so sánh
    final episodeNameWithServer =
        serverName != null ? '$episodeName ($serverName)' : episodeName;

    return _downloads.cast<DownloadEntity?>().firstWhere(
          (download) =>
              download?.movieName == movieName &&
              (download?.episodeName == episodeName ||
                  download?.episodeName == episodeNameWithServer),
          orElse: () => null,
        );
  }

  void _startDownload(dynamic movie, dynamic episode, String? serverName) {
    if (movie?.name == null ||
        episode?.name == null ||
        movie?.thumbUrl == null ||
        episode?.linkM3u8 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thông tin tập phim không đầy đủ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Thêm server name vào episode name để phân biệt
    final episodeNameWithServer =
        serverName != null ? '${episode.name} (${serverName})' : episode.name;

    context.read<DownloadBloc>().add(
          StartDownloadEvent(
            movieName: movie.name,
            episodeName: episodeNameWithServer,
            thumbnailUrl: movie.thumbUrl,
            m3u8Url: episode.linkM3u8,
          ),
        );
  }

  @override
  void dispose() {
    // Clear cache khi dispose để tránh stale data
    _cacheService.invalidateCache(movie?.name);
    super.dispose();
  }
}
