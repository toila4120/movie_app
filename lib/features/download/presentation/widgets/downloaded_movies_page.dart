import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_app/config/theme/theme.dart';
import '../../domain/entities/download_entity.dart';
import '../bloc/download_bloc.dart';
import 'offline_video_helper.dart';

class DownloadedMoviesPage extends StatefulWidget {
  const DownloadedMoviesPage({super.key});

  @override
  State<DownloadedMoviesPage> createState() => _DownloadedMoviesPageState();
}

class _DownloadedMoviesPageState extends State<DownloadedMoviesPage> {
  List<DownloadEntity> _downloads = [];
  Map<String, List<DownloadEntity>> _groupedMovies = {};

  @override
  void initState() {
    super.initState();
    context.read<DownloadBloc>().add(LoadDownloadsEvent());
  }

  void _groupDownloadsByMovie() {
    _groupedMovies.clear();

    // Chỉ lấy những download đã hoàn thành
    final completedDownloads = _downloads
        .where((download) => download.status == DownloadStatus.completed)
        .toList();

    for (final download in completedDownloads) {
      if (_groupedMovies.containsKey(download.movieName)) {
        _groupedMovies[download.movieName]!.add(download);
      } else {
        _groupedMovies[download.movieName] = [download];
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Phim đã tải',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.storage, color: Colors.white),
            onPressed: () => _showStorageInfo(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'clear_cache':
                  OfflineVideoHelper.showClearCacheDialog(context);
                  break;
                case 'storage_info':
                  _showStorageInfo();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'storage_info',
                child: Row(
                  children: [
                    Icon(Icons.storage),
                    SizedBox(width: 8),
                    Text('Thông tin lưu trữ'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_cache',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Xóa cache ảnh'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<DownloadBloc, DownloadState>(
        listener: (context, state) {
          if (state is DownloadLoaded) {
            setState(() {
              _downloads = state.downloads;
              _groupDownloadsByMovie();
            });
          }
        },
        child: _groupedMovies.isEmpty ? _buildEmptyState() : _buildMoviesList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_for_offline_outlined,
            size: 80.r,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có phim nào được tải',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Hãy tải một số phim để xem offline',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesList() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats header
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColor.greyScale800,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.movie,
                  color: AppColor.primaryDark,
                  size: 24.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_groupedMovies.length} bộ phim',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_getTotalEpisodes()} tập đã tải',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColor.primaryDark,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    _getFormattedFileSize(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Movies grid
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: _groupedMovies.length,
              itemBuilder: (context, index) {
                final movieName = _groupedMovies.keys.elementAt(index);
                final episodes = _groupedMovies[movieName]!;
                return _buildMovieCard(movieName, episodes);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(String movieName, List<DownloadEntity> episodes) {
    final firstEpisode = episodes.first;
    final episodeCount = episodes.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.greyScale800,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => _navigateToEpisodes(movieName, episodes),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie thumbnail
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12.r)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12.r)),
                    child: CachedNetworkImage(
                      imageUrl: firstEpisode.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColor.greyScale700,
                        child: Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 32.r,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        // Log error for debugging
                        debugPrint(
                            'CachedNetworkImage error in movie card: $error');
                        return Container(
                          color: AppColor.greyScale700,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 28.r,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Ảnh lỗi',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      // Add cache options to handle corrupted cache
                      cacheKey: firstEpisode.thumbnailUrl.isNotEmpty
                          ? 'movie_${Uri.parse(firstEpisode.thumbnailUrl).pathSegments.last}'
                          : null,
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: const Duration(milliseconds: 200),
                    ),
                  ),
                ),
              ),

              // Movie info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 14.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '$episodeCount tập',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        _getMovieFileSize(episodes),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEpisodes(String movieName, List<DownloadEntity> episodes) {
    OfflineVideoHelper.openDownloadedEpisodes(
      context,
      movieName: movieName,
      episodes: episodes,
    );
  }

  void _showStorageInfo() {
    final totalSize = _getTotalFileSize();
    final formattedSize = _formatFileSize(totalSize);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.greyScale800,
        title: const Text(
          'Thông tin lưu trữ',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStorageRow('Tổng dung lượng:', formattedSize),
            _buildStorageRow('Số bộ phim:', '${_groupedMovies.length}'),
            _buildStorageRow('Tổng số tập:', '${_getTotalEpisodes()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  int _getTotalEpisodes() {
    return _downloads.where((d) => d.status == DownloadStatus.completed).length;
  }

  int _getTotalFileSize() {
    return _downloads
        .where((d) => d.status == DownloadStatus.completed)
        .fold(0, (sum, download) => sum + (download.fileSize));
  }

  String _getFormattedFileSize() {
    return _formatFileSize(_getTotalFileSize());
  }

  String _getMovieFileSize(List<DownloadEntity> episodes) {
    final totalSize =
        episodes.fold(0, (sum, episode) => sum + (episode.fileSize));
    return _formatFileSize(totalSize);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}
