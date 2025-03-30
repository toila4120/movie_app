import 'package:movie_app/features/movie/data/model/movie_model.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieModel>> fetchMoviesByCategory(String categorySlug, int page);
  // Future<List<MovieModel>> fetchMoviesByList(String listSlug, int page);
  Future<MovieEntity> fetchMovieDetail(String slug);
}
