import 'package:movie_app/features/home/domain/repository/home_repository.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

class GetMoviesByGenreUsecase {
  final HomeRepository repository;
  GetMoviesByGenreUsecase(this.repository);

  Future<List<MovieEntity>> call(String genre) async {
    return await repository.getMoviesByGenre(genre);
  }
}
