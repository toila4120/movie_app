import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/download_entity.dart';
import '../datasources/download_local_datasource.dart';
import 'package:movie_app/features/download/domain/entities/download_episode.dart';

/// Service để cache download status và tối ưu hóa database queries
class DownloadCacheService {
  final DownloadLocalDataSource _localDataSource;

  // Cache cho episode status theo movie
  final Map<String, Map<String, DownloadStatus>> _episodeStatusCache = {};

  // Cache cho movie downloads
  final Map<String, List<DownloadEntity>> _movieDownloadsCache = {};

  // Cache cho completed downloads grouped
  Map<String, List<DownloadEntity>>? _completedDownloadsCache;

  // Cache expiry time (giảm xuống 3 phút để tăng tính real-time)
  static const Duration _cacheExpiry = Duration(minutes: 3);
  final Map<String, DateTime> _cacheTimestamps = {};

  // Stream cho real-time updates
  final StreamController<Map<String, DownloadStatus>> _episodeStatusController =
      StreamController<Map<String, DownloadStatus>>.broadcast();

  final Map<String, DownloadEpisode> _cache = {};
  final Map<String, bool> _isDownloadingCache = {};

  DownloadCacheService(this._localDataSource);

  /// Lấy episode status với cache (optimized cho UI)
  Future<DownloadStatus?> getEpisodeStatus(
      String movieName, String episodeName) async {
    final cacheKey = _getCacheKey(movieName);

    // Kiểm tra cache trước
    if (_episodeStatusCache.containsKey(cacheKey) && _isCacheValid(cacheKey)) {
      return _episodeStatusCache[cacheKey]![episodeName];
    }

    // Cache miss hoặc expired - refresh từ database
    await _refreshEpisodeStatusCache(movieName);

    return _episodeStatusCache[cacheKey]?[episodeName];
  }

  /// Lấy batch episode status (tối ưu cho danh sách episodes)
  Future<Map<String, DownloadStatus>> getEpisodesStatusBatch(
      String movieName, List<String> episodeNames) async {
    if (episodeNames.isEmpty) return {};

    final cacheKey = _getCacheKey(movieName);

    // Kiểm tra cache trước - nhưng không dựa hoàn toàn vào cache
    if (_episodeStatusCache.containsKey(cacheKey) && _isCacheValid(cacheKey)) {
      final cachedStatuses = _episodeStatusCache[cacheKey]!;
      final result = <String, DownloadStatus>{};

      for (final episodeName in episodeNames) {
        if (cachedStatuses.containsKey(episodeName)) {
          result[episodeName] = cachedStatuses[episodeName]!;
        }
      }

      // Nếu có đủ data trong cache và cache còn fresh (< 1 phút)
      final cacheAge = DateTime.now().difference(_cacheTimestamps[cacheKey]!);
      if (result.length == episodeNames.length && cacheAge.inMinutes < 1) {
        return result;
      }
    }

    // Load từ database với timeout
    try {
      final dbResult = await _localDataSource
          .getEpisodesStatusBatch(movieName, episodeNames)
          .timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          debugPrint('Database query timeout for episodes status batch');
          return <String, DownloadStatus>{};
        },
      );

      // Update cache
      if (!_episodeStatusCache.containsKey(cacheKey)) {
        _episodeStatusCache[cacheKey] = {};
      }
      _episodeStatusCache[cacheKey]!.addAll(dbResult);
      _cacheTimestamps[cacheKey] = DateTime.now();

      // Emit update cho listeners (chỉ emit khi có update thật sự)
      if (dbResult.isNotEmpty) {
        _episodeStatusController.add(dbResult);
      }

      return dbResult;
    } catch (e) {
      debugPrint('Error getting episodes status batch: $e');

      // Fallback to cache nếu có lỗi
      if (_episodeStatusCache.containsKey(cacheKey)) {
        final cachedStatuses = _episodeStatusCache[cacheKey]!;
        final result = <String, DownloadStatus>{};

        for (final episodeName in episodeNames) {
          if (cachedStatuses.containsKey(episodeName)) {
            result[episodeName] = cachedStatuses[episodeName]!;
          }
        }
        return result;
      }

      return {};
    }
  }

  /// Lấy downloads của một movie với cache
  Future<List<DownloadEntity>> getMovieDownloads(String movieName) async {
    final cacheKey = _getCacheKey(movieName);

    if (_movieDownloadsCache.containsKey(cacheKey) && _isCacheValid(cacheKey)) {
      return _movieDownloadsCache[cacheKey]!;
    }

    final downloads = await _localDataSource.getDownloadsByMovie(movieName);
    _movieDownloadsCache[cacheKey] = downloads;
    _cacheTimestamps[cacheKey] = DateTime.now();

    return downloads;
  }

  /// Lấy completed downloads grouped với cache
  Future<Map<String, List<DownloadEntity>>>
      getCompletedDownloadsGrouped() async {
    const cacheKey = 'completed_downloads';

    if (_completedDownloadsCache != null && _isCacheValid(cacheKey)) {
      return _completedDownloadsCache!;
    }

    final downloads = await _localDataSource.getCompletedDownloadsGrouped();
    _completedDownloadsCache = downloads;
    _cacheTimestamps[cacheKey] = DateTime.now();

    return downloads;
  }

  /// Update cache khi có download status change
  void updateEpisodeStatus(
      String movieName, String episodeName, DownloadStatus status) {
    final cacheKey = _getCacheKey(movieName);

    if (!_episodeStatusCache.containsKey(cacheKey)) {
      _episodeStatusCache[cacheKey] = {};
    }

    _episodeStatusCache[cacheKey]![episodeName] = status;
    _cacheTimestamps[cacheKey] = DateTime.now();

    // Emit update
    _episodeStatusController.add({episodeName: status});

    // Invalidate related caches
    _invalidateCompletedDownloadsCache();
    _movieDownloadsCache.remove(cacheKey);
  }

  /// Invalidate cache khi có thay đổi lớn - cải tiến
  void invalidateCache([String? movieName]) {
    if (movieName != null) {
      final cacheKey = _getCacheKey(movieName);
      _episodeStatusCache.remove(cacheKey);
      _movieDownloadsCache.remove(cacheKey);
      _cacheTimestamps.remove(cacheKey);
      debugPrint('Invalidated cache for movie: $movieName');
    } else {
      // Clear all cache
      _episodeStatusCache.clear();
      _movieDownloadsCache.clear();
      _cacheTimestamps.clear();
      _invalidateCompletedDownloadsCache();
      debugPrint('Invalidated all cache');
    }
  }

  /// Stream để listen real-time episode status updates
  Stream<Map<String, DownloadStatus>> get episodeStatusUpdates =>
      _episodeStatusController.stream;

  /// Preload cache cho một movie (background loading) - tối ưu hóa
  Future<void> preloadMovieCache(String movieName) async {
    final cacheKey = _getCacheKey(movieName);

    if (_isCacheValid(cacheKey)) return; // Cache still valid

    try {
      // Load song song để tăng tốc
      final futures = [
        _refreshEpisodeStatusCache(movieName),
        getMovieDownloads(movieName),
      ];

      await Future.wait(futures, eagerError: false);
    } catch (e) {
      debugPrint('Error preloading movie cache: $e');
    }
  }

  /// Preload nhanh cho specific episodes
  Future<void> preloadEpisodesStatus(
      String movieName, List<String> episodeNames) async {
    if (episodeNames.isEmpty) return;

    final cacheKey = _getCacheKey(movieName);

    // Chỉ load nếu cache expired hoặc chưa có
    if (_isCacheValid(cacheKey)) {
      final cachedStatuses = _episodeStatusCache[cacheKey];
      if (cachedStatuses != null) {
        // Kiểm tra xem có đủ episodes trong cache không
        final hasAllEpisodes = episodeNames
            .every((episodeName) => cachedStatuses.containsKey(episodeName));
        if (hasAllEpisodes) return; // Đã có đủ trong cache
      }
    }

    // Load từ database
    try {
      await getEpisodesStatusBatch(movieName, episodeNames);
    } catch (e) {
      debugPrint('Error preloading episodes status: $e');
    }
  }

  /// Clean expired cache entries
  void cleanExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > _cacheExpiry) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      _episodeStatusCache.remove(key);
      _movieDownloadsCache.remove(key);
      _cacheTimestamps.remove(key);
    }

    // Check completed downloads cache
    if (_cacheTimestamps['completed_downloads'] != null &&
        now.difference(_cacheTimestamps['completed_downloads']!) >
            _cacheExpiry) {
      _invalidateCompletedDownloadsCache();
    }
  }

  Future<DownloadEpisode?> getEpisode(String episodeId) async {
    if (_cache.containsKey(episodeId)) {
      return _cache[episodeId];
    }

    final episode = await _localDataSource.getEpisode(episodeId);
    if (episode != null) {
      _cache[episodeId] = episode;
    }
    return episode;
  }

  Future<bool> isDownloading(String episodeId) async {
    if (_isDownloadingCache.containsKey(episodeId)) {
      return _isDownloadingCache[episodeId]!;
    }

    final isDownloading = await _localDataSource.isDownloading(episodeId);
    _isDownloadingCache[episodeId] = isDownloading;
    return isDownloading;
  }

  void updateCache(DownloadEpisode episode) {
    _cache[episode.episodeId] = episode;
    _isDownloadingCache[episode.episodeId] = episode.isDownloading;
  }

  void clearCache() {
    _cache.clear();
    _isDownloadingCache.clear();
  }

  void removeFromCache(String episodeId) {
    _cache.remove(episodeId);
    _isDownloadingCache.remove(episodeId);
  }

  // === PRIVATE METHODS ===

  String _getCacheKey(String movieName) => 'movie_$movieName';

  bool _isCacheValid(String cacheKey) {
    final timestamp = _cacheTimestamps[cacheKey];
    if (timestamp == null) return false;

    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  Future<void> _refreshEpisodeStatusCache(String movieName) async {
    try {
      final downloads = await _localDataSource.getDownloadsByMovie(movieName);
      final cacheKey = _getCacheKey(movieName);

      final statusMap = <String, DownloadStatus>{};
      for (final download in downloads) {
        // Handle both original episode name and episode name with server
        final episodeName = download.episodeName;
        statusMap[episodeName] = download.status;

        // Also cache original name if it has server suffix
        final match = RegExp(r'^(.+) \([^)]+\)$').firstMatch(episodeName);
        if (match != null) {
          final originalName = match.group(1)!;
          statusMap[originalName] = download.status;
        }
      }

      _episodeStatusCache[cacheKey] = statusMap;
      _cacheTimestamps[cacheKey] = DateTime.now();
    } catch (e) {
      // Nếu có lỗi, không crash app
      debugPrint('Error refreshing episode status cache: $e');
    }
  }

  void _invalidateCompletedDownloadsCache() {
    _completedDownloadsCache = null;
    _cacheTimestamps.remove('completed_downloads');
  }

  /// Dispose resources
  void dispose() {
    _episodeStatusController.close();
    invalidateCache(); // Clear all cache
  }

  /// Force refresh cache cho một movie
  Future<void> forceRefreshMovieCache(String movieName) async {
    final cacheKey = _getCacheKey(movieName);

    // Clear existing cache
    _episodeStatusCache.remove(cacheKey);
    _movieDownloadsCache.remove(cacheKey);
    _cacheTimestamps.remove(cacheKey);

    // Refresh
    try {
      await _refreshEpisodeStatusCache(movieName);
    } catch (e) {
      debugPrint('Error force refreshing movie cache: $e');
    }
  }
}

/// Helper extension để dễ sử dụng
extension DownloadCacheServiceExtension on DownloadCacheService {
  /// Quick check if episode is downloaded
  Future<bool> isEpisodeDownloaded(String movieName, String episodeName) async {
    final status = await getEpisodeStatus(movieName, episodeName);
    return status == DownloadStatus.completed;
  }

  /// Quick check if episode is downloading
  Future<bool> isEpisodeDownloading(
      String movieName, String episodeName) async {
    final status = await getEpisodeStatus(movieName, episodeName);
    return status == DownloadStatus.downloading;
  }

  /// Get episode status with fallback
  Future<DownloadStatus> getEpisodeStatusWithFallback(
      String movieName, String episodeName) async {
    final status = await getEpisodeStatus(movieName, episodeName);
    return status ?? DownloadStatus.pending;
  }
}
