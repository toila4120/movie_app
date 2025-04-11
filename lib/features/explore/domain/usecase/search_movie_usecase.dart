import 'package:movie_app/features/explore/domain/repository/explore_repository.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

class SearchMovieUsecase {
  final ExploreRepository exploreRepository;
  SearchMovieUsecase(this.exploreRepository);
  Future<List<MovieEntity>> searchMovie(String query, int page) async {
    return await exploreRepository.searchMovie(query, page);
  }
}
