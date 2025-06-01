import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/download_model.dart';
import '../../domain/entities/download_entity.dart';
import '../../domain/entities/download_episode.dart';

abstract class DownloadLocalDataSource {
  Future<void> insertDownload(DownloadModel download);
  Future<void> updateDownload(DownloadModel download);
  Future<void> deleteDownload(String id);
  Future<DownloadModel?> getDownload(String id);
  Future<List<DownloadModel>> getAllDownloads();
  Future<void> clearAllDownloads();
  Future<List<DownloadModel>> getDownloadsByMovie(String movieName);
  Future<DownloadModel?> checkEpisodeDownload(
      String movieName, String episodeName);
  Future<Map<String, DownloadStatus>> getEpisodesStatusBatch(
      String movieName, List<String> episodeNames);
  Future<Map<DownloadStatus, int>> getDownloadStatusCount();
  Future<Map<String, int>> getMovieFileSizes();
  Future<Map<String, List<DownloadModel>>> getCompletedDownloadsGrouped();
  Future<void> createIndexes();
  Future<DownloadEpisode?> getEpisode(String episodeId);
  Future<bool> isDownloading(String episodeId);
}

class DownloadLocalDataSourceImpl implements DownloadLocalDataSource {
  static Database? _database;
  static const String tableName = 'downloads';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'downloads.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id TEXT PRIMARY KEY,
        movieName TEXT NOT NULL,
        episodeName TEXT NOT NULL,
        thumbnailUrl TEXT NOT NULL,
        m3u8Url TEXT NOT NULL,
        localPath TEXT NOT NULL,
        status INTEGER NOT NULL,
        progress REAL NOT NULL,
        totalFiles INTEGER NOT NULL,
        downloadedFiles INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        completedAt TEXT,
        errorMessage TEXT,
        fileSize INTEGER NOT NULL
      )
    ''');

    // Tạo indexes ngay khi tạo database
    await _createIndexesInternal(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Tạo indexes cho version 2
      await _createIndexesInternal(db);
    }
  }

  Future<void> _createIndexesInternal(Database db) async {
    // Index cho movie name (thường xuyên query theo movie)
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_movie_name 
      ON $tableName (movieName)
    ''');

    // Index cho episode lookup
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_movie_episode 
      ON $tableName (movieName, episodeName)
    ''');

    // Index cho status queries
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_status 
      ON $tableName (status)
    ''');

    // Composite index cho completed downloads
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_movie_status 
      ON $tableName (movieName, status)
    ''');
  }

  @override
  Future<void> insertDownload(DownloadModel download) async {
    final db = await database;
    await db.insert(
      tableName,
      download.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateDownload(DownloadModel download) async {
    final db = await database;
    await db.update(
      tableName,
      download.toJson(),
      where: 'id = ?',
      whereArgs: [download.id],
    );
  }

  @override
  Future<void> deleteDownload(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DownloadModel?> getDownload(String id) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DownloadModel.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<List<DownloadModel>> getAllDownloads() async {
    final db = await database;
    final maps = await db.query(tableName, orderBy: 'createdAt DESC');
    return maps.map((map) => DownloadModel.fromJson(map)).toList();
  }

  @override
  Future<void> clearAllDownloads() async {
    final db = await database;
    await db.delete(tableName);
  }

  @override
  Future<List<DownloadModel>> getDownloadsByMovie(String movieName) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'movieName = ?',
      whereArgs: [movieName],
      orderBy: 'episodeName ASC',
    );
    return maps.map((map) => DownloadModel.fromJson(map)).toList();
  }

  @override
  Future<DownloadModel?> checkEpisodeDownload(
      String movieName, String episodeName) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'movieName = ? AND (episodeName = ? OR episodeName LIKE ?)',
      whereArgs: [movieName, episodeName, '$episodeName (%'],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return DownloadModel.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<Map<String, DownloadStatus>> getEpisodesStatusBatch(
      String movieName, List<String> episodeNames) async {
    final db = await database;
    final result = <String, DownloadStatus>{};

    final placeholders = episodeNames.map((_) => '?').join(',');
    final whereClause = '''
      movieName = ? AND (
        episodeName IN ($placeholders) OR
        episodeName REGEXP ?
      )
    ''';

    final regexPattern =
        '^(${episodeNames.map((name) => name.replaceAll(RegExp(r'[.*+?^${}()|[\]\\]'), r'\$&')).join('|')}) \\([^)]+\\)\$';

    final maps = await db.query(
      tableName,
      columns: ['episodeName', 'status'],
      where: whereClause,
      whereArgs: [movieName, ...episodeNames, regexPattern],
    );

    for (final map in maps) {
      final episodeName = map['episodeName'] as String;
      final status = DownloadStatus.values[map['status'] as int];

      for (final originalName in episodeNames) {
        if (episodeName == originalName ||
            episodeName.startsWith('$originalName (')) {
          result[originalName] = status;
          break;
        }
      }
    }

    return result;
  }

  @override
  Future<Map<DownloadStatus, int>> getDownloadStatusCount() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT status, COUNT(*) as count 
      FROM $tableName 
      GROUP BY status
    ''');

    final result = <DownloadStatus, int>{};
    for (final map in maps) {
      final status = DownloadStatus.values[map['status'] as int];
      final count = map['count'] as int;
      result[status] = count;
    }

    return result;
  }

  @override
  Future<Map<String, int>> getMovieFileSizes() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT movieName, SUM(fileSize) as totalSize 
      FROM $tableName 
      WHERE status = ?
      GROUP BY movieName
    ''', [DownloadStatus.completed.index]);

    final result = <String, int>{};
    for (final map in maps) {
      final movieName = map['movieName'] as String;
      final totalSize = map['totalSize'] as int;
      result[movieName] = totalSize;
    }

    return result;
  }

  @override
  Future<Map<String, List<DownloadModel>>>
      getCompletedDownloadsGrouped() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'status = ?',
      whereArgs: [DownloadStatus.completed.index],
      orderBy: 'movieName ASC, episodeName ASC',
    );

    final downloads = maps.map((map) => DownloadModel.fromJson(map)).toList();
    final grouped = <String, List<DownloadModel>>{};

    for (final download in downloads) {
      if (grouped.containsKey(download.movieName)) {
        grouped[download.movieName]!.add(download);
      } else {
        grouped[download.movieName] = [download];
      }
    }

    return grouped;
  }

  @override
  Future<void> createIndexes() async {
    final db = await database;
    await _createIndexesInternal(db);
  }

  @override
  Future<DownloadEpisode?> getEpisode(String episodeId) async {
    // Implementation needed
    throw UnimplementedError();
  }

  @override
  Future<bool> isDownloading(String episodeId) async {
    // Implementation needed
    throw UnimplementedError();
  }
}
