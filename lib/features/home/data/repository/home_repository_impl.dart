import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/home/data/datasource/home_remote_datasource.dart';
import 'package:movie_app/features/home/domain/entities/movie_for_banner_entity.dart';
import 'package:movie_app/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource homeRemoteDatasource;

  HomeRepositoryImpl(this.homeRemoteDatasource);

  @override
  Future<List<MovieForBannerEntity>> getMovieForBanner() async {
    try {
      final movies = await homeRemoteDatasource.fetchMoviesForBanner();
      return movies
          .map((movie) => MovieForBannerEntity(
                name: movie.name,
                posterUrl: movie.posterUrl,
                thumbUrl: movie.thumbUrl,
                slug: movie.slug,
                episodeCurrent: movie.episodeCurrent,
                year: movie.year,
                category: movie.categories
                    .map((category) => CategoryEntity(
                          id: category.id,
                          name: category.name,
                          slug: category.slug,
                        ))
                    .toList(),
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MovieForBannerEntity>> getMoviesByGenre(String genre) async {
    try {
      final movies = await homeRemoteDatasource.fetchMoviesForBanner();
      return movies
          .map((movie) => MovieForBannerEntity(
                name: movie.name,
                posterUrl: movie.posterUrl,
                thumbUrl: movie.thumbUrl,
                slug: movie.slug,
                episodeCurrent: movie.episodeCurrent,
                year: movie.year,
                category: movie.categories
                    .map((category) => CategoryEntity(
                          id: category.id,
                          name: category.name,
                          slug: category.slug,
                        ))
                    .toList(),
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
