import 'package:movie_app/features/movie/data/datasource/movie_remote_datasource.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';
import 'package:movie_app/features/movie/domain/entities/actor_entity.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieRemoteDatasource movieRemoteDatasource;

  MovieRepositoryImpl(this.movieRemoteDatasource);

  @override
  Future<List<MovieModel>> fetchMoviesByCategory(
      String categorySlug, int page) async {
    try {
      return await movieRemoteDatasource.fetchMoviesByCategory(
          categorySlug, page);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MovieEntity> fetchMovieDetail(String slug) async {
    try {
      return await movieRemoteDatasource.fetchMovieDetail(slug);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> fetchMoviesByList(String listSlug, int page) {
    try {
      return movieRemoteDatasource.fetchMoviesByList(listSlug, page);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ActorEntity>> fetchMovieActors(String slug) {
    try {
      return movieRemoteDatasource.fetchMovieActors(slug);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<List<MovieEntity>> fetchNewMovies(int page) {
    try {
      return movieRemoteDatasource.fetchNewMovies(page);
    } catch (e) {
      rethrow;
    }
  }
}
