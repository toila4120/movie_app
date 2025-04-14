import 'package:movie_app/features/explore/data/datasource/remote/explore_remote_datasource.dart';
import 'package:movie_app/features/explore/domain/entities/filter_param.dart';
import 'package:movie_app/features/explore/domain/entities/region_entities.dart';
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

  @override
  Future<List<RegionEntities>> getRegions() async {
    try {
      final regionModels = await exploreRemoteDatasource.getRegions();
      return regionModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MovieEntity>> filterMovie(FilterParam filter, int page) {
    try {
      return exploreRemoteDatasource.filterMovie(filter, page);
    } catch (e) {
      rethrow;
    }
  }
}
