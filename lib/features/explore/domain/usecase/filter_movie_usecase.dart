import 'package:movie_app/features/explore/domain/entities/filter_param.dart';
import 'package:movie_app/features/explore/domain/repository/explore_repository.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

class FilterMovieUsecase {
  final ExploreRepository exploreRepository;
  FilterMovieUsecase(this.exploreRepository);

  Future<List<MovieEntity>> filterMovies(FilterParam filter, int page) async {
    return await exploreRepository.filterMovie(filter, page);
  }
}
