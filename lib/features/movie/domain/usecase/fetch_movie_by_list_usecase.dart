
import 'package:movie_app/features/movie/data/model/movie_model.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';

class FetchMovieByListUsecase {
  final MovieRepository repository;

  FetchMovieByListUsecase(this.repository);

  Future<List<MovieModel>> call(String listSlug, int page) async {
    return await repository.fetchMoviesByList(listSlug, page);
  }

}
