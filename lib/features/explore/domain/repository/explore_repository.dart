import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

abstract class ExploreRepository {
  Future<List<MovieEntity>> searchMovie(String query, int page);
}