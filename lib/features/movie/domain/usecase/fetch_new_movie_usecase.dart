import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';

class FetchNewMovieUsecase {
  final MovieRepository repository;

  FetchNewMovieUsecase(this.repository);

  Future<List<MovieEntity>> call(int page) async {
    return await repository.fetchNewMovies(page);
  }
}
