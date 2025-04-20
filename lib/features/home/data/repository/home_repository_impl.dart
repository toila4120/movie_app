import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/home/data/datasource/home_remote_datasource.dart';
import 'package:movie_app/features/home/domain/entities/movie_with_genre.dart';
import 'package:movie_app/features/home/domain/repository/home_repository.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource homeRemoteDatasource;

  HomeRepositoryImpl(this.homeRemoteDatasource);

  @override
  Future<List<MovieEntity>> getMovieForBanner() async {
    try {
      final movies = await homeRemoteDatasource.fetchMoviesForBanner();
      return movies;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MovieEntity>> getMoviesByGenre(String genre) async {
    try {
      final movies = await homeRemoteDatasource.fetchMoviesForBanner();
      return movies;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MovieWithGenre>> getMoviesByListGenre(
      List<CategoryEntity> genre) async {
    try {
      return await homeRemoteDatasource.fetchMoviesByListGenre(genre);
    } catch (e) {
      throw Exception('Error in getMoviesByListGenre: $e');
    }
  }
}
