import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/home/domain/entities/movie_with_genre.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

abstract class HomeRepository {
  Future<List<MovieEntity>> getMovieForBanner();
  Future<List<MovieEntity>> getMoviesByGenre(String genre);
  Future<List<MovieWithGenre>> getMoviesByListGenre(List<CategoryEntity> genre);
}
