import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:movie_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;

  ProfileRepositoryImpl(this.profileRemoteDatasource);

  @override
  Future<List<MovieEntity>> getFavoriteMovies(List<String> slug) async {
    try {
      return await profileRemoteDatasource.getFavoriteMovies(slug);
    } catch (e) {
      throw Exception('Error in getFavoriteMovies: $e');
    }
  }

  @override
  Future<MovieEntity> getMovieBySlug(String slug) async {
    try {
      return await profileRemoteDatasource.getMovieBySlug(slug);
    } catch (e) {
      throw Exception('Error in getMovieBySlug: $e');
    }
  }
}
