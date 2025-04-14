import 'package:movie_app/features/explore/domain/entities/region_entities.dart';
import 'package:movie_app/features/explore/domain/repository/explore_repository.dart';

class GetRegionsUsecase {
  final ExploreRepository repository;

  GetRegionsUsecase(this.repository);

  Future<List<RegionEntities>> call() async {
    return await repository.getRegions();
  }
}