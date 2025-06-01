import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_app/config/theme/theme.dart';
import '../../domain/entities/download_entity.dart';
import '../bloc/download_bloc.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DownloadBloc>().add(LoadDownloadsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldDark,
        title: Text(
          'Tải xuống',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showClearAllDialog();
            },
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<DownloadBloc, DownloadState>(
        builder: (context, state) {
          if (state is DownloadLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryDark),
            );
          }

          if (state is DownloadError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.r,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DownloadBloc>().add(LoadDownloadsEvent());
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is DownloadLoaded) {
            if (state.downloads.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_outlined,
                      size: 64.r,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Chưa có video nào được tải xuống',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: state.downloads.length,
              itemBuilder: (context, index) {
                final download = state.downloads[index];
                return DownloadItem(
                  download: download,
                  onPause: () {
                    context
                        .read<DownloadBloc>()
                        .add(PauseDownloadEvent(download.id));
                  },
                  onResume: () {
                    context
                        .read<DownloadBloc>()
                        .add(ResumeDownloadEvent(download.id));
                  },
                  onCancel: () {
                    context
                        .read<DownloadBloc>()
                        .add(CancelDownloadEvent(download.id));
                  },
                  onDelete: () {
                    _showDeleteDialog(download);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showDeleteDialog(DownloadEntity download) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.greyScale800,
        title: const Text('Xóa video', style: TextStyle(color: Colors.white)),
        content: Text(
          'Bạn có muốn xóa "${download.movieName} - ${download.episodeName}" không?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<DownloadBloc>()
                  .add(DeleteDownloadEvent(download.id));
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.greyScale800,
        title: const Text('Xóa tất cả', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Bạn có muốn xóa tất cả video đã tải không?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DownloadBloc>().add(ClearAllDownloadsEvent());
            },
            child:
                const Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class DownloadItem extends StatelessWidget {
  final DownloadEntity download;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const DownloadItem({
    super.key,
    required this.download,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColor.greyScale800,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: download.thumbnailUrl,
                  width: 80.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80.w,
                    height: 60.h,
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryDark,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80.w,
                    height: 60.h,
                    color: Colors.grey[800],
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      download.movieName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      download.episodeName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    _buildStatusWidget(),
                  ],
                ),
              ),
              // Action buttons
              _buildActionButtons(),
            ],
          ),
          if (download.status == DownloadStatus.downloading ||
              download.status == DownloadStatus.paused) ...[
            SizedBox(height: 12.h),
            _buildProgressBar(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusWidget() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (download.status) {
      case DownloadStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Đang chờ';
        statusIcon = Icons.schedule;
        break;
      case DownloadStatus.downloading:
        statusColor = AppColor.primaryDark;
        statusText =
            'Đang tải (${download.downloadedFiles}/${download.totalFiles})';
        statusIcon = Icons.download;
        break;
      case DownloadStatus.completed:
        statusColor = Colors.green;
        statusText = 'Hoàn thành';
        statusIcon = Icons.check_circle;
        break;
      case DownloadStatus.failed:
        statusColor = Colors.red;
        statusText = 'Lỗi';
        statusIcon = Icons.error;
        break;
      case DownloadStatus.paused:
        statusColor = Colors.yellow;
        statusText = 'Tạm dừng';
        statusIcon = Icons.pause;
        break;
      case DownloadStatus.cancelled:
        statusColor = Colors.grey;
        statusText = 'Đã hủy';
        statusIcon = Icons.cancel;
        break;
    }

    return Row(
      children: [
        Icon(statusIcon, size: 16.r, color: statusColor),
        SizedBox(width: 4.w),
        Text(
          statusText,
          style: TextStyle(
            color: statusColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(download.progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
            Text(
              _formatFileSize(download.fileSize),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        LinearProgressIndicator(
          value: download.progress,
          backgroundColor: Colors.grey[700],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primaryDark),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    switch (download.status) {
      case DownloadStatus.downloading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onPause,
              icon: const Icon(Icons.pause, color: Colors.white),
            ),
            IconButton(
              onPressed: onCancel,
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      case DownloadStatus.paused:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onResume,
              icon: const Icon(Icons.play_arrow, color: Colors.white),
            ),
            IconButton(
              onPressed: onCancel,
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      case DownloadStatus.completed:
        return IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete, color: Colors.red),
        );
      case DownloadStatus.failed:
      case DownloadStatus.cancelled:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onResume,
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
