// lib/features/home/data/datasource/home_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';

abstract class HomeRemoteDatasource {
  Future<List<MovieModel>> fetchMoviesForBanner();
  Future<List<MovieModel>> fetchMoviesByGenre(String genre);
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final Dio dio;

  HomeRemoteDatasourceImpl(this.dio);

  @override
  Future<List<MovieModel>> fetchMoviesForBanner() async {
    try {
      final response = await dio.get(
        'https://phimapi.com/danh-sach/phim-moi-cap-nhat-v3',
        queryParameters: {'page': 1},
      );
      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] != true) {
          throw Exception('Failed to fetch movies');
        }

        final List<dynamic> items = jsonData['items'];
        return items.map((item) => MovieModel.fromJson(item)).toList();
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
  Future<List<MovieModel>> fetchMoviesByGenre(String genre) async {
    try {
      final response = await dio.get('https://phimapi.com/v1/api/the-loai/$genre',
          queryParameters: {'page': 1});
      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] != true) {
          throw Exception('Failed to fetch movies by genre');
        }

        final List<dynamic> items = jsonData['items'];
        return items.map((item) => MovieModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch movies by genre: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
