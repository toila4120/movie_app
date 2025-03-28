import 'package:movie_app/features/movie/data/model/movie_model.dart';

abstract class MovieRepository {
  Future<List<MovieModel>> fetchMoviesByCategory(String categorySlug, int page);
}