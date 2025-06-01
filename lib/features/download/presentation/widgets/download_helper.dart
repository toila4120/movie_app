import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/config/theme/theme.dart';
import '../bloc/download_bloc.dart';
import '../../di/download_injection.dart';
import '../../download.dart';
import 'download_episodes_page.dart';

class DownloadHelper {
  /// Hiển thị bottom sheet để chọn tập download nhanh (4 tập đầu)
  static void showDownloadBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => downloadGetIt<DownloadBloc>(),
        child: const DownloadBottomSheet(),
      ),
    );
  }

  /// Điều hướng tới trang download episodes đầy đủ
  static void navigateToDownloadEpisodes(BuildContext context, dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => downloadGetIt<DownloadBloc>(),
          child: DownloadEpisodesPage(movie: movie),
        ),
      ),
    );
  }

  /// Hiển thị dialog xác nhận download nhiều tập
  static void showBatchDownloadDialog(
    BuildContext context,
    List<dynamic> episodes,
    dynamic movie,
    String serverName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.greyScale800,
        title: const Text(
          'Tải xuống hàng loạt',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn có muốn tải xuống ${episodes.length} tập từ server "$serverName"?',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'Phim: ${movie.name}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              'Server: $serverName',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startBatchDownload(context, episodes, movie, serverName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryDark,
            ),
            child: const Text('Tải xuống'),
          ),
        ],
      ),
    );
  }

  static void _startBatchDownload(
    BuildContext context,
    List<dynamic> episodes,
    dynamic movie,
    String serverName,
  ) {
    final downloadBloc = context.read<DownloadBloc>();

    for (final episode in episodes) {
      final episodeNameWithServer = '${episode.name} ($serverName)';

      downloadBloc.add(
        StartDownloadEvent(
          movieName: movie.name,
          episodeName: episodeNameWithServer,
          thumbnailUrl: movie.thumbUrl,
          m3u8Url: episode.linkM3u8,
        ),
      );

      // Delay nhỏ giữa các request để tránh overload
      Future.delayed(const Duration(milliseconds: 500));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã bắt đầu tải ${episodes.length} tập'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
