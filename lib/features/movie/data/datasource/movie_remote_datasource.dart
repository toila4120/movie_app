import 'package:dio/dio.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';

abstract class MovieRemoteDatasource {
  Future<List<MovieModel>> fetchMoviesByCategory(String categorySlug, int page);
  Future<MovieModel> fetchMovieDetail(String slug);
  Future<List<MovieModel>> fetchMoviesByList(String listSlug, int page);
}

class MovieRemoteDatasourceImpl implements MovieRemoteDatasource {
  final Dio dio;

  MovieRemoteDatasourceImpl(this.dio);

  @override
  Future<List<MovieModel>> fetchMoviesByCategory(
      String categorySlug, int page) async {
    try {
      final response = await dio.get(
        'https://phimapi.com/v1/api/the-loai/$categorySlug',
        queryParameters: {'page': page},
      );
      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] != 'success') {
          throw Exception('Failed to fetch movies: ${jsonData['msg']}');
        }

        final List<dynamic> items = jsonData['data']['items'];
        return items
            .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch movies: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<MovieModel> fetchMovieDetail(String slug) async {
    try {
      final response = await dio.get('https://phimapi.com/phim/$slug');
      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] != true) {
          throw Exception('Failed to fetch movie detail: ${jsonData['msg']}');
        }

        // Lấy danh sách episodes
        final movieJson = jsonData['movie'] as Map<String, dynamic>;
        movieJson['episodes'] = jsonData['episodes'];

        return MovieModel.fromJson(movieJson);
      } else {
        throw Exception('Failed to fetch movie detail: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<MovieModel>> fetchMoviesByList(String listSlug, int page) async {
    try {
      final response = await dio.get(
        'https://phimapi.com/v1/api/danh-sach/$listSlug',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] != 'success') {
          throw Exception('Failed to fetch movies: ${jsonData['msg']}');
        }

        final List<dynamic> items = jsonData['data']['items'];
        return items
            .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch movies: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
