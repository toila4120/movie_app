import 'package:flutter/material.dart';
import 'download_helper.dart';

// CÁCH SỬ DỤNG DOWNLOAD BOTTOM SHEET VÀ EPISODES PAGE
//
// 1. Download Bottom Sheet (chọn nhanh 4 tập đầu):
void showDownloadDialog(BuildContext context) {
  DownloadHelper.showDownloadBottomSheet(context);
}

// 2. Download Episodes Page (xem tất cả tập):
void showAllEpisodes(BuildContext context, dynamic movie) {
  DownloadHelper.navigateToDownloadEpisodes(context, movie);
}

// 3. Batch Download Dialog (tải nhiều tập cùng lúc):
void showBatchDownload(BuildContext context, List<dynamic> episodes,
    dynamic movie, String serverName) {
  DownloadHelper.showBatchDownloadDialog(context, episodes, movie, serverName);
}

// VÍ DỤ TRONG MOVIE DETAIL PAGE:
class MovieDetailUsageExample extends StatelessWidget {
  final dynamic movie; // Movie object từ API

  const MovieDetailUsageExample({super.key, this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Detail')),
      body: Column(
        children: [
          // Movie info hiển thị ở đây...

          // Buttons section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Quick download (bottom sheet)
              ElevatedButton.icon(
                onPressed: () =>
                    DownloadHelper.showDownloadBottomSheet(context),
                icon: const Icon(Icons.download),
                label: const Text('Tải nhanh'),
              ),

              // View all episodes
              ElevatedButton.icon(
                onPressed: () =>
                    DownloadHelper.navigateToDownloadEpisodes(context, movie),
                icon: const Icon(Icons.list),
                label: const Text('Tất cả tập'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// VÍ DỤ TRONG APP BAR ACTION:
class AppBarDownloadAction extends StatelessWidget {
  final dynamic movie;

  const AppBarDownloadAction({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.download),
      onSelected: (value) {
        switch (value) {
          case 'quick':
            DownloadHelper.showDownloadBottomSheet(context);
            break;
          case 'all':
            DownloadHelper.navigateToDownloadEpisodes(context, movie);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'quick',
          child: Row(
            children: [
              Icon(Icons.flash_on),
              SizedBox(width: 8),
              Text('Tải nhanh'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'all',
          child: Row(
            children: [
              Icon(Icons.list),
              SizedBox(width: 8),
              Text('Xem tất cả tập'),
            ],
          ),
        ),
      ],
    );
  }
}

// VÍ DỤ FLOATING ACTION BUTTON:
class DownloadFAB extends StatelessWidget {
  final dynamic movie;

  const DownloadFAB({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () =>
          DownloadHelper.navigateToDownloadEpisodes(context, movie),
      icon: const Icon(Icons.download_for_offline),
      label: const Text('Tải xuống'),
    );
  }
}
