import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/theme/theme.dart';
import '../../domain/entities/download_entity.dart';
import '../../data/services/download_cache_service.dart';
import '../../di/download_injection.dart';

/// Optimized widget để hiển thị episode download status với cache
class OptimizedEpisodeStatusWidget extends StatefulWidget {
  final String movieName;
  final String episodeName;
  final String? serverName;
  final Widget child;
  final VoidCallback? onTap;
  final bool showBorder;

  const OptimizedEpisodeStatusWidget({
    super.key,
    required this.movieName,
    required this.episodeName,
    this.serverName,
    required this.child,
    this.onTap,
    this.showBorder = true,
  });

  @override
  State<OptimizedEpisodeStatusWidget> createState() =>
      _OptimizedEpisodeStatusWidgetState();
}

class _OptimizedEpisodeStatusWidgetState
    extends State<OptimizedEpisodeStatusWidget> {
  final DownloadCacheService _cacheService =
      downloadGetIt<DownloadCacheService>();
  DownloadStatus? _status;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
    _listenToStatusUpdates();
  }

  void _loadStatus() async {
    try {
      final episodeNameWithServer = widget.serverName != null
          ? '${widget.episodeName} (${widget.serverName})'
          : widget.episodeName;

      final status = await _cacheService.getEpisodeStatus(
        widget.movieName,
        episodeNameWithServer,
      );

      if (mounted) {
        setState(() {
          _status = status;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = null;
          _isLoading = false;
        });
      }
    }
  }

  void _listenToStatusUpdates() {
    _cacheService.episodeStatusUpdates.listen((updates) {
      final episodeNameWithServer = widget.serverName != null
          ? '${widget.episodeName} (${widget.serverName})'
          : widget.episodeName;

      if (updates.containsKey(episodeNameWithServer) ||
          updates.containsKey(widget.episodeName)) {
        final newStatus =
            updates[episodeNameWithServer] ?? updates[widget.episodeName];

        if (mounted && newStatus != _status) {
          setState(() {
            _status = newStatus;
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    final isDownloaded = _status == DownloadStatus.completed;
    final isDownloading = _status == DownloadStatus.downloading;
    final isPaused = _status == DownloadStatus.paused;
    final isFailed = _status == DownloadStatus.failed;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: widget.showBorder ? _getBorder() : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: (isDownloaded || isDownloading) ? null : widget.onTap,
          child: Stack(
            children: [
              widget.child,

              // Status indicator overlay
              Positioned(
                top: 8.r,
                right: 8.r,
                child: _buildStatusIndicator(),
              ),

              // Disabled overlay
              if (isDownloaded || isDownloading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.greyScale800,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          widget.child,
          Positioned(
            top: 8.r,
            right: 8.r,
            child: SizedBox(
              width: 16.r,
              height: 16.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.greyScale500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    switch (_status) {
      case DownloadStatus.completed:
        return Container(
          padding: EdgeInsets.all(4.r),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 12.r,
          ),
        );

      case DownloadStatus.downloading:
        return Container(
          padding: EdgeInsets.all(4.r),
          decoration: const BoxDecoration(
            color: AppColor.primaryDark,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: 12.r,
            height: 12.r,
            child: const CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.white,
            ),
          ),
        );

      case DownloadStatus.failed:
        return Container(
          padding: EdgeInsets.all(4.r),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 12.r,
          ),
        );

      case DownloadStatus.paused:
        return Container(
          padding: EdgeInsets.all(4.r),
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.pause,
            color: Colors.white,
            size: 12.r,
          ),
        );

      default:
        return Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColor.greyScale600,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.download,
            color: Colors.white,
            size: 12.r,
          ),
        );
    }
  }

  Border? _getBorder() {
    switch (_status) {
      case DownloadStatus.completed:
        return Border.all(color: Colors.green, width: 2);
      case DownloadStatus.downloading:
        return Border.all(color: AppColor.primaryDark, width: 2);
      case DownloadStatus.failed:
        return Border.all(color: Colors.red, width: 2);
      case DownloadStatus.paused:
        return Border.all(color: Colors.orange, width: 2);
      default:
        return null;
    }
  }
}

/// Batch status loader cho multiple episodes
class EpisodeStatusBatchLoader extends StatefulWidget {
  final String movieName;
  final List<String> episodeNames;
  final Widget Function(Map<String, DownloadStatus> statusMap) builder;

  const EpisodeStatusBatchLoader({
    super.key,
    required this.movieName,
    required this.episodeNames,
    required this.builder,
  });

  @override
  State<EpisodeStatusBatchLoader> createState() =>
      _EpisodeStatusBatchLoaderState();
}

class _EpisodeStatusBatchLoaderState extends State<EpisodeStatusBatchLoader> {
  final DownloadCacheService _cacheService =
      downloadGetIt<DownloadCacheService>();
  Map<String, DownloadStatus> _statusMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBatchStatus();
    _listenToStatusUpdates();
  }

  void _loadBatchStatus() async {
    try {
      final statusMap = await _cacheService.getEpisodesStatusBatch(
        widget.movieName,
        widget.episodeNames,
      );

      if (mounted) {
        setState(() {
          _statusMap = statusMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMap = {};
          _isLoading = false;
        });
      }
    }
  }

  void _listenToStatusUpdates() {
    _cacheService.episodeStatusUpdates.listen((updates) {
      bool hasUpdate = false;
      final newStatusMap = Map<String, DownloadStatus>.from(_statusMap);

      for (final episodeName in widget.episodeNames) {
        if (updates.containsKey(episodeName)) {
          newStatusMap[episodeName] = updates[episodeName]!;
          hasUpdate = true;
        }
      }

      if (mounted && hasUpdate) {
        setState(() {
          _statusMap = newStatusMap;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryDark),
      );
    }

    return widget.builder(_statusMap);
  }
}

/// Helper methods để dễ sử dụng status
extension DownloadStatusHelpers on DownloadStatus? {
  bool get isCompleted => this == DownloadStatus.completed;
  bool get isDownloading => this == DownloadStatus.downloading;
  bool get isFailed => this == DownloadStatus.failed;
  bool get isPaused => this == DownloadStatus.paused;
  bool get isPending => this == null || this == DownloadStatus.pending;

  Color get statusColor {
    switch (this) {
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.downloading:
        return AppColor.primaryDark;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.paused:
        return Colors.orange;
      default:
        return AppColor.greyScale500;
    }
  }

  IconData get statusIcon {
    switch (this) {
      case DownloadStatus.completed:
        return Icons.check_circle;
      case DownloadStatus.downloading:
        return Icons.downloading;
      case DownloadStatus.failed:
        return Icons.error;
      case DownloadStatus.paused:
        return Icons.pause_circle;
      default:
        return Icons.download;
    }
  }
}
