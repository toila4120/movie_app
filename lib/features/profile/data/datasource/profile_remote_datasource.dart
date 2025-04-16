import 'package:dio/dio.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';

abstract class ProfileRemoteDatasource {
  Future<MovieModel> getMovieBySlug(String slug);
  Future<List<MovieModel>> getFavoriteMovies(List<String> slugs);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio _dio;

  ProfileRemoteDatasourceImpl(this._dio);

  @override
  Future<MovieModel> getMovieBySlug(String slug) async {
    try {
      final response = await _dio.get('https://phimapi.com/phim/$slug');
      if (response.statusCode == 200 && response.data['movie'] != null) {
        return MovieModel.fromJson(response.data['movie']);
      } else {
        throw Exception('Failed to fetch movie with slug: $slug');
      }
    } catch (e) {
      throw Exception('Error fetching movie: $e');
    }
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies(List<String> slugs) async {
    try {
      final List<MovieModel> favoriteMovies = [];
      for (final slug in slugs) {
        final movie = await getMovieBySlug(slug);
        favoriteMovies.add(movie);
      }
      return favoriteMovies;
    } catch (e) {
      throw Exception('Error fetching favorite movies: $e');
    }
  }
}
