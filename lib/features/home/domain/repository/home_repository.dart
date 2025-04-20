import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/home/domain/entities/movie_for_banner_entity.dart';
import 'package:movie_app/features/home/domain/entities/movie_with_genre.dart';

abstract class HomeRepository {
  Future<List<MovieForBannerEntity>> getMovieForBanner();
  Future<List<MovieForBannerEntity>> getMoviesByGenre(String genre);
  Future<List<MovieWithGenre>> getMoviesByListGenre(List<CategoryEntity> genre);
}
