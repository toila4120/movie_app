import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

abstract class ProfileRepository {
  Future<MovieEntity> getMovieBySlug(String slug);
  Future<List<MovieEntity>> getFavoriteMovies(List<String> slug);
}
