
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';

class FetchMovieByListUsecase {
  final MovieRepository repository;

  FetchMovieByListUsecase(this.repository);

  Future<List<MovieEntity>> call(String listSlug, int page) async {
    return await repository.fetchMoviesByList(listSlug, page);
  }

}
