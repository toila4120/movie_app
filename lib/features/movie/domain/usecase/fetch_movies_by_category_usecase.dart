import 'package:movie_app/features/movie/data/model/movie_model.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';

class FetchMoviesByCategoryUseCase {
  final MovieRepository repository;

  FetchMoviesByCategoryUseCase(this.repository);

  Future<List<MovieModel>> call(String categorySlug, int page) async {
    return await repository.fetchMoviesByCategory(categorySlug, page);
  }
}
