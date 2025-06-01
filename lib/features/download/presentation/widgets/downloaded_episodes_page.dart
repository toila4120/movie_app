import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import '../../domain/entities/download_entity.dart';
import 'offline_video_helper.dart';

class DownloadedEpisodesPage extends StatefulWidget {
  final String movieName;
  final List<DownloadEntity> episodes;

  const DownloadedEpisodesPage({
    super.key,
    required this.movieName,
    required this.episodes,
  });

  @override
  State<DownloadedEpisodesPage> createState() => _DownloadedEpisodesPageState();
}

class _DownloadedEpisodesPageState extends State<DownloadedEpisodesPage> {
  late String movieName;
  late List<DownloadEntity> episodes;

  @override
  void initState() {
    super.initState();

    // Use temp data if available, otherwise use widget parameters
    movieName = OfflineVideoHelper.tempMovieName ?? widget.movieName;
    episodes = OfflineVideoHelper.tempEpisodes ?? widget.episodes;

    // Clear temp data after use
    OfflineVideoHelper.clearTempData();
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
              'Phim đã tải',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              movieName,
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'play_all':
                  _playAllEpisodes();
                  break;
                case 'delete_all':
                  _showDeleteAllDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'play_all',
                child: Row(
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 8),
                    Text('Phát tất cả'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie header info
            _buildMovieHeader(),
            SizedBox(height: 16.h),

            // Episodes list
            Expanded(
              child: ListView.separated(
                itemCount: episodes.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final episode = episodes[index];
                  return _buildEpisodeItem(episode, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieHeader() {
    final firstEpisode = episodes.first;
    final totalSize =
        episodes.fold(0, (sum, episode) => sum + (episode.fileSize));

    return Container(
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
              imageUrl: firstEpisode.thumbnailUrl,
              width: 80.w,
              height: 100.h,
              fit: BoxFit.cover,
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
                debugPrint(
                    'CachedNetworkImage error in downloaded episodes: $error');
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
              cacheKey: firstEpisode.thumbnailUrl.isNotEmpty
                  ? 'ep_${Uri.parse(firstEpisode.thumbnailUrl).pathSegments.last}'
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
                  movieName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.download_done,
                      color: Colors.green,
                      size: 16.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${episodes.length} tập đã tải',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.storage,
                      color: AppColor.primaryDark,
                      size: 16.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _formatFileSize(totalSize),
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

  Widget _buildEpisodeItem(DownloadEntity episode, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.greyScale800,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => _playEpisode(episode, index),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                // Episode thumbnail
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl: episode.thumbnailUrl,
                        width: 80.w,
                        height: 60.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80.w,
                          height: 60.h,
                          color: AppColor.greyScale700,
                          child: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 20.r,
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          // Log error for debugging
                          debugPrint(
                              'CachedNetworkImage error in episode item: $error');
                          return Container(
                            width: 80.w,
                            height: 60.h,
                            color: AppColor.greyScale700,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 16.r,
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
                        // Add cache options to handle corrupted cache
                        cacheKey: episode.thumbnailUrl.isNotEmpty
                            ? 'item_${Uri.parse(episode.thumbnailUrl).pathSegments.last}'
                            : null,
                        fadeInDuration: const Duration(milliseconds: 150),
                        fadeOutDuration: const Duration(milliseconds: 150),
                      ),
                    ),

                    // Play overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 24.r,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),

                // Episode info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        episode.episodeName,
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
                            'Đã tải xuống',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatFileSize(episode.fileSize),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                      if (episode.completedAt != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Tải lúc: ${_formatDate(episode.completedAt!)}',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Action buttons
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _playEpisode(episode, index),
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: AppColor.primaryDark,
                        size: 32.r,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showDeleteEpisodeDialog(episode),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20.r,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _playEpisode(DownloadEntity episode, int index) {
    // Check if local file exists
    if (episode.localPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy file video'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Use OfflineVideoHelper to ensure proper BlocProvider setup
    OfflineVideoHelper.playOfflineVideo(
      context,
      episode: episode,
      playlist: episodes,
      currentIndex: index,
    );
  }

  void _playAllEpisodes() {
    if (episodes.isNotEmpty) {
      _playEpisode(episodes.first, 0);
    }
  }

  void _showDeleteEpisodeDialog(DownloadEntity episode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.greyScale800,
        title: const Text(
          'Xóa tập phim',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Bạn có chắc muốn xóa "${episode.episodeName}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEpisode(episode);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.greyScale800,
        title: const Text(
          'Xóa tất cả',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Bạn có chắc muốn xóa tất cả ${episodes.length} tập của "$movieName"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllEpisodes();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
  }

  void _deleteEpisode(DownloadEntity episode) {
    // TODO: Implement delete episode logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${episode.episodeName}"'),
        backgroundColor: Colors.green,
      ),
    );

    // Remove from list and update UI
    setState(() {
      episodes.remove(episode);
    });

    // If no episodes left, go back
    if (episodes.isEmpty) {
      GoRouter.of(context).pop();
    }
  }

  void _deleteAllEpisodes() {
    // TODO: Implement delete all episodes logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa tất cả tập của "$movieName"'),
        backgroundColor: Colors.green,
      ),
    );

    GoRouter.of(context).pop();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
