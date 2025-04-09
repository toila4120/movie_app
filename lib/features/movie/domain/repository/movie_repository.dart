import 'package:movie_app/features/movie/domain/entities/actor_entity.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> fetchMoviesByCategory(
      String categorySlug, int page);
  Future<List<MovieEntity>> fetchMoviesByList(String listSlug, int page);
  Future<MovieEntity> fetchMovieDetail(String slug);
  Future<List<ActorEntity>> fetchMovieActors(String slug);
}
