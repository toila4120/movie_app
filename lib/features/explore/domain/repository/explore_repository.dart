import 'package:movie_app/features/explore/domain/entities/filter_param.dart';
import 'package:movie_app/features/explore/domain/entities/region_entities.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

abstract class ExploreRepository {
  Future<List<MovieEntity>> searchMovie(String query, int page);
  Future<List<RegionEntities>> getRegions();
  Future<List<MovieEntity>> filterMovie(FilterParam filter, int page);
}
