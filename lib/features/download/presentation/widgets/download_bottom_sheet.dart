part of '../../download.dart';

class DownloadBottomSheet extends StatefulWidget {
  const DownloadBottomSheet({super.key});

  @override
  State<DownloadBottomSheet> createState() => _DownloadBottomSheetState();
}

class _DownloadBottomSheetState extends State<DownloadBottomSheet> {
  int _selectedServerIndex = 0;

  // Cache service for optimized status checking
  late final DownloadCacheService _cacheService;
  bool _isLoadingStatus = false;
  Map<String, DownloadStatus> _cachedStatusMap = {};

  @override
  void initState() {
    super.initState();
    _cacheService = downloadGetIt<DownloadCacheService>();

    // Clear cached status để lấy data mới nhất
    _cachedStatusMap.clear();

    // Load downloads để kiểm tra trạng thái
    context.read<DownloadBloc>().add(LoadDownloadsEvent());

    // Listen to cache updates for real-time status
    _listenToCacheUpdates();
  }

  void _listenToCacheUpdates() {
    _cacheService.episodeStatusUpdates.listen((updates) {
      if (mounted && updates.isNotEmpty) {
        setState(() {
          _cachedStatusMap.addAll(updates);
        });
      }
    });
  }

  Future<void> _preloadEpisodeStatus(dynamic movie) async {
    if (movie?.name == null || movie.episodes == null || movie.episodes.isEmpty)
      return;

    setState(() {
      _isLoadingStatus = true;
    });

    try {
      final selectedServer = movie.episodes[_selectedServerIndex];
      final episodes = selectedServer.serverData ?? [];

      if (episodes.isNotEmpty) {
        // Chỉ load 4 tập đầu tiên cho bottom sheet
        final displayEpisodes = episodes.take(4).toList();
        final episodeNames = displayEpisodes.map<String>((episode) {
          final serverName = selectedServer.serverName;
          return serverName != null
              ? '${episode.name} (${serverName})'
              : episode.name;
        }).toList();

        // Force refresh cache để lấy status mới nhất
        await _cacheService.forceRefreshMovieCache(movie.name);

        final statusMap = await _cacheService
            .getEpisodesStatusBatch(
          movie.name,
          episodeNames,
        )
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('Bottom sheet episodes status timeout');
            return <String, DownloadStatus>{};
          },
        );

        if (mounted) {
          setState(() {
            _cachedStatusMap = statusMap;
            _isLoadingStatus = false;
          });

          // Debug print để kiểm tra cache
          debugPrint('Bottom sheet cache updated: $_cachedStatusMap');
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingStatus = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error preloading bottom sheet episode status: $e');
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    }
  }

  Future<void> _onServerChanged(int newIndex, dynamic movie) async {
    if (newIndex == _selectedServerIndex) return;

    setState(() {
      _selectedServerIndex = newIndex;
    });

    // Preload status cho server mới
    await _preloadEpisodeStatus(movie);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, movieState) {
        // Kiểm tra xem có movie data không
        if (movieState.movie == null) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColor.scaffoldDark,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppBorderRadius.r28.w),
              ),
            ),
            child: const Center(
              child: Text(
                'Không tìm thấy thông tin phim',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return BlocListener<DownloadBloc, DownloadState>(
          listener: (context, state) {
            if (state is DownloadLoaded) {
              setState(() {});

              // Refresh cache khi có downloads mới
              if (!_isLoadingStatus) {
                _preloadEpisodeStatus(movieState.movie!);
              }
            } else if (state is DownloadStarted) {
              // Refresh cache khi có download mới bắt đầu
              if (!_isLoadingStatus) {
                _preloadEpisodeStatus(movieState.movie!);
              }
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, authState) {
              final movie = movieState.movie!;
              final watchedMovies = authState.user?.watchedMovies ?? [];
              final watchedMovie = watchedMovies.firstWhere(
                (m) => m.movieId == movie.id,
                orElse: () => WatchedMovie(
                  movieId: movie.slug,
                  isSeries: movie.episodeTotal != "1",
                  name: movie.name,
                  thumbUrl: movie.thumbUrl,
                  episodeTotal: int.tryParse(movie.episodeTotal) ?? 0,
                  time: int.tryParse(
                          movie.time.replaceAll(RegExp(r'[^0-9]'), '')) ??
                      60,
                ),
              );

              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  minHeight: 200,
                ),
                decoration: BoxDecoration(
                  color: AppColor.scaffoldDark,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppBorderRadius.r28.w),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Content
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(AppPadding.medium),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Chọn tập để tải xuống",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        movie.name,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white70,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                // Button xem tất cả tập
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    OfflineVideoHelper.openDownloadEpisodes(
                                      context,
                                      movie: movie,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryDark,
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.list,
                                          color: Colors.white,
                                          size: 16.r,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Xem tất cả',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Server selection với UI cải thiện
                            if (movie.episodes.length > 1) ...[
                              SizedBox(height: AppPadding.medium),
                              _buildServerSelection(movie),
                            ],

                            SizedBox(height: AppPadding.medium),

                            // Episodes list (chỉ hiển thị 4 tập đầu tiên)
                            Flexible(
                              child: movie.episodes.isEmpty ||
                                      movie.episodes[_selectedServerIndex]
                                          .serverData.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Không có tập nào để tải xuống',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : _buildEpisodesList(movie, watchedMovie),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildServerSelection(dynamic movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Server tải xuống:',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movie.episodes.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final server = movie.episodes[index];
              final isSelected = index == _selectedServerIndex;
              final episodeCount = server.serverData?.length ?? 0;

              return GestureDetector(
                onTap: () {
                  _onServerChanged(index, movie);
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
                        ? Border.all(color: AppColor.primaryDark, width: 2)
                        : Border.all(color: Colors.transparent, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dns,
                        color: isSelected ? Colors.white : Colors.white70,
                        size: 14.r,
                      ),
                      SizedBox(width: 6.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            server.serverName ?? 'Server ${index + 1}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$episodeCount tập',
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white70 : Colors.white60,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodesList(dynamic movie, dynamic watchedMovie) {
    final episodes = movie.episodes[_selectedServerIndex].serverData;
    final serverName = movie.episodes[_selectedServerIndex].serverName;

    // Force preload mỗi khi build để đảm bảo có status mới nhất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isLoadingStatus) {
        _preloadEpisodeStatus(movie);
      }
    });

    // Chỉ hiển thị 4 tập đầu tiên trong bottom sheet
    final displayEpisodes = episodes.take(4).toList();

    return Column(
      children: [
        // Loading indicator
        if (_isLoadingStatus)
          Container(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.primaryDark,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Đang tải trạng thái...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

        // Episodes list
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: displayEpisodes.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: AppPadding.small),
            itemBuilder: (context, index) {
              final episode = displayEpisodes[index];
              final watchedEpisode = watchedMovie.watchedEpisodes[index + 1];

              return _buildEpisodeItem(
                movie,
                episode,
                watchedEpisode,
                serverName,
              );
            },
          ),
        ),

        // Show more button nếu có nhiều hơn 4 tập
        if (episodes.length > 4) ...[
          SizedBox(height: AppPadding.small),
          Container(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                OfflineVideoHelper.openDownloadEpisodes(
                  context,
                  movie: movie,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColor.greyScale700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'Xem thêm ${episodes.length - 4} tập',
                style: TextStyle(
                  color: AppColor.primaryDark,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEpisodeItem(dynamic movie, dynamic episode,
      dynamic watchedEpisode, String? serverName) {
    // Kiểm tra trạng thái download từ cache
    final episodeNameWithServer =
        serverName != null ? '${episode.name} (${serverName})' : episode.name;

    // Sử dụng cached status thay vì loop qua _downloads
    final downloadStatus = _cachedStatusMap[episodeNameWithServer];
    final isDownloaded = downloadStatus == DownloadStatus.completed;
    final isDownloading = downloadStatus == DownloadStatus.downloading;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColor.greyScale800,
        borderRadius: BorderRadius.circular(12.r),
        border: isDownloaded
            ? Border.all(color: Colors.green, width: 2)
            : isDownloading
                ? Border.all(color: AppColor.primaryDark, width: 2)
                : null,
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: movie?.posterUrl ?? '',
              height: 50.h,
              width: 50.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 50.h,
                width: 50.w,
                color: AppColor.greyScale700,
                child: Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: 16.r,
                ),
              ),
              errorWidget: (context, url, error) {
                return Container(
                  height: 50.h,
                  width: 50.w,
                  color: AppColor.greyScale700,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 14.r,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Lỗi',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 6.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
              cacheKey: movie?.posterUrl?.isNotEmpty == true
                  ? 'bs_${Uri.parse(movie.posterUrl).pathSegments.last}'
                  : null,
              fadeInDuration: const Duration(milliseconds: 150),
              fadeOutDuration: const Duration(milliseconds: 150),
            ),
          ),
          SizedBox(width: 12.w),

          // Episode info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDownloaded ? Colors.green : Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),

                // Status text
                Row(
                  children: [
                    if (serverName != null) ...[
                      Icon(
                        Icons.dns,
                        color: AppColor.greyScale500,
                        size: 12.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        serverName,
                        style: TextStyle(
                          color: AppColor.greyScale500,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '•',
                        style: TextStyle(
                          color: AppColor.greyScale500,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],

                    // Download status indicator
                    Icon(
                      _getStatusIcon(downloadStatus),
                      color: _getStatusColor(downloadStatus),
                      size: 12.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _getStatusText(downloadStatus),
                      style: TextStyle(
                        color: _getStatusColor(downloadStatus),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Download button với status icon
          BlocConsumer<DownloadBloc, DownloadState>(
            listener: (context, state) {
              if (state is DownloadStarted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
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
            builder: (context, state) {
              final isLoading = state is DownloadLoading;

              return _buildDownloadButton(
                isDownloaded: isDownloaded,
                isDownloading: isDownloading,
                isLoading: isLoading,
                onPressed: (isDownloaded || isDownloading || isLoading)
                    ? null
                    : () => _startDownload(movie, episode, serverName),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton({
    required bool isDownloaded,
    required bool isDownloading,
    required bool isLoading,
    required VoidCallback? onPressed,
  }) {
    Widget icon;
    Color backgroundColor;
    String tooltip = '';

    if (isDownloaded) {
      icon = Icon(Icons.check_circle, color: Colors.white, size: 20.r);
      backgroundColor = Colors.green;
      tooltip = 'Đã tải xong';
    } else if (isDownloading) {
      icon = SizedBox(
        width: 20.w,
        height: 20.h,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
      backgroundColor = AppColor.primaryDark;
      tooltip = 'Đang tải xuống';
    } else if (isLoading) {
      icon = SizedBox(
        width: 20.w,
        height: 20.h,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
      backgroundColor = AppColor.primaryDark;
      tooltip = 'Đang chuẩn bị tải';
    } else {
      icon = Icon(Icons.download, color: Colors.white, size: 20.r);
      backgroundColor = AppColor.primary500;
      tooltip = 'Tải xuống';
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color:
                    onPressed == null ? AppColor.greyScale600 : backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  void _startDownload(dynamic movie, dynamic episode, String? serverName) {
    try {
      // Kiểm tra tính hợp lệ của dữ liệu
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

      // Update cache ngay lập tức để UI phản hồi
      setState(() {
        _cachedStatusMap[episodeNameWithServer] = DownloadStatus.downloading;
      });

      // Update cache service
      _cacheService.updateEpisodeStatus(
        movie.name,
        episodeNameWithServer,
        DownloadStatus.downloading,
      );

      context.read<DownloadBloc>().add(
            StartDownloadEvent(
              movieName: movie.name,
              episodeName: episodeNameWithServer,
              thumbnailUrl: movie.thumbUrl,
              m3u8Url: episode.linkM3u8,
            ),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi bắt đầu tải: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper methods để hiển thị status
  IconData _getStatusIcon(DownloadStatus? status) {
    switch (status) {
      case DownloadStatus.completed:
        return Icons.check_circle;
      case DownloadStatus.downloading:
        return Icons.downloading;
      case DownloadStatus.paused:
        return Icons.pause_circle;
      case DownloadStatus.failed:
        return Icons.error;
      case DownloadStatus.pending:
        return Icons.schedule;
      default:
        return Icons.download;
    }
  }

  Color _getStatusColor(DownloadStatus? status) {
    switch (status) {
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.downloading:
        return AppColor.primaryDark;
      case DownloadStatus.paused:
        return Colors.orange;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.pending:
        return Colors.yellow;
      default:
        return AppColor.greyScale500;
    }
  }

  String _getStatusText(DownloadStatus? status) {
    switch (status) {
      case DownloadStatus.completed:
        return 'Đã tải';
      case DownloadStatus.downloading:
        return 'Đang tải';
      case DownloadStatus.paused:
        return 'Tạm dừng';
      case DownloadStatus.failed:
        return 'Lỗi';
      case DownloadStatus.pending:
        return 'Chờ tải';
      default:
        return 'Chưa tải';
    }
  }

  @override
  void dispose() {
    // Không cần invalidate cache ở đây vì bottom sheet chỉ hiển thị tạm thời
    super.dispose();
  }
}
