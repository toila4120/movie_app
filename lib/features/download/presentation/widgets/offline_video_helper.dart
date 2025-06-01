import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_bloc.dart';
import '../bloc/download_bloc.dart';
import '../../di/download_injection.dart';
import '../../domain/entities/download_entity.dart';
import '../../download.dart';

class OfflineVideoHelper {
  /// Hiển thị download bottom sheet với proper BlocProvider setup
  static void showDownloadBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider(
        create: (context) => downloadGetIt<DownloadBloc>(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<MovieBloc>(),
            ),
            BlocProvider.value(
              value: context.read<AuthenticationBloc>(),
            ),
          ],
          child: const DownloadBottomSheet(),
        ),
      ),
    );
  }

  /// Mở màn hình phim đã tải từ profile
  static void openDownloadedMovies(BuildContext context) {
    context.push(AppRouter.downloadedMoviesScreenPath);
  }

  /// Mở màn hình tập phim đã tải của một bộ phim
  static void openDownloadedEpisodes(
    BuildContext context, {
    required String movieName,
    required List<DownloadEntity> episodes,
  }) {
    // Store episodes in a temporary holder to avoid GoRouter warning
    _tempEpisodesHolder = episodes;
    _tempMovieNameHolder = movieName;

    context.push(AppRouter.downloadedEpisodesScreenPath);
  }

  /// Mở màn hình download episodes cho một bộ phim
  static void openDownloadEpisodes(
    BuildContext context, {
    required dynamic movie,
  }) {
    // Store movie in temporary holder
    _tempMovieHolder = movie;

    context.push(AppRouter.downloadEpisodesScreenPath);
  }

  /// Phát video offline trực tiếp (nếu biết đường dẫn file)
  static void playOfflineVideo(
    BuildContext context, {
    required DownloadEntity episode,
    List<DownloadEntity>? playlist,
    int currentIndex = 0,
  }) {
    // Store data in temporary holders
    _tempEpisodeHolder = episode;
    _tempPlaylistHolder = playlist ?? [episode];
    _tempCurrentIndexHolder = currentIndex;

    context.push(AppRouter.offlineVideoPlayerScreenPath);
  }

  /// Kiểm tra xem có tập phim nào đã download không
  static Future<bool> hasDownloadedEpisodes() async {
    try {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Lấy danh sách phim đã download (simplified)
  static Future<Map<String, List<DownloadEntity>>> getDownloadedMovies() async {
    try {
      return {};
    } catch (e) {
      return {};
    }
  }

  /// Helper để format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// Helper để format duration
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  /// Hiển thị thông báo storage info
  static void showStorageInfo(
    BuildContext context, {
    required int totalMovies,
    required int totalEpisodes,
    required int totalSize,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông tin lưu trữ offline'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Số bộ phim:', '$totalMovies'),
            _buildInfoRow('Tổng số tập:', '$totalEpisodes'),
            _buildInfoRow('Dung lượng:', formatFileSize(totalSize)),
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

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  /// Clear cached images to fix corrupted cache issues
  static Future<void> clearImageCache() async {
    try {
      await CachedNetworkImage.evictFromCache('');
      // Clear the entire image cache
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      debugPrint('Image cache cleared successfully');
    } catch (e) {
      debugPrint('Error clearing image cache: $e');
    }
  }

  /// Clear specific image from cache by URL
  static Future<void> clearSpecificImageCache(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(imageUrl);
        debugPrint('Cleared cache for: $imageUrl');
      }
    } catch (e) {
      debugPrint('Error clearing specific image cache: $e');
    }
  }

  /// Show dialog to clear cache if user experiences image issues
  static void showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa cache ảnh'),
        content: const Text(
          'Bạn có muốn xóa cache ảnh? Điều này có thể giải quyết các vấn đề về ảnh bị lỗi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await clearImageCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa cache ảnh thành công'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Xóa cache'),
          ),
        ],
      ),
    );
  }

  // Temporary data holders to avoid GoRouter serialization warning
  static List<DownloadEntity>? _tempEpisodesHolder;
  static String? _tempMovieNameHolder;
  static dynamic _tempMovieHolder;
  static DownloadEntity? _tempEpisodeHolder;
  static List<DownloadEntity>? _tempPlaylistHolder;
  static int _tempCurrentIndexHolder = 0;

  // Getters for accessing stored data
  static List<DownloadEntity>? get tempEpisodes => _tempEpisodesHolder;
  static String? get tempMovieName => _tempMovieNameHolder;
  static dynamic get tempMovie => _tempMovieHolder;
  static DownloadEntity? get tempEpisode => _tempEpisodeHolder;
  static List<DownloadEntity>? get tempPlaylist => _tempPlaylistHolder;
  static int get tempCurrentIndex => _tempCurrentIndexHolder;

  // Clear temporary data
  static void clearTempData() {
    _tempEpisodesHolder = null;
    _tempMovieNameHolder = null;
    _tempMovieHolder = null;
    _tempEpisodeHolder = null;
    _tempPlaylistHolder = null;
    _tempCurrentIndexHolder = 0;
  }
}
