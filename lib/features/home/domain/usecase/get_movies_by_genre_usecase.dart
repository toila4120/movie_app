import 'package:movie_app/features/home/domain/entities/movie_for_banner_entity.dart';
import 'package:movie_app/features/home/domain/repository/home_repository.dart';

class GetMoviesByGenreUsecase {
  final HomeRepository repository;
  GetMoviesByGenreUsecase(this.repository);

  Future<List<MovieForBannerEntity>> call(String genre) async {
    return await repository.getMoviesByGenre(genre);
  }
}
