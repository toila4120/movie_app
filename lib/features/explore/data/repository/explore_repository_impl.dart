import 'package:movie_app/features/explore/data/datasource/remote/explore_remote_datasource.dart';
import 'package:movie_app/features/explore/domain/repository/explore_repository.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

class ExploreRepositoryImpl extends ExploreRepository {
  final ExploreRemoteDatasource exploreRemoteDatasource;

  ExploreRepositoryImpl(this.exploreRemoteDatasource);
  @override
  Future<List<MovieEntity>> searchMovie(String query, int page) {
    try {
      return exploreRemoteDatasource.searchMovie(query, page);
    } catch (e) {
      rethrow;
    }
  }
}
