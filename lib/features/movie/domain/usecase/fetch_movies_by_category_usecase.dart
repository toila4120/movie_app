import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';

class FetchMoviesByCategoryUseCase {
  final MovieRepository repository;

  FetchMoviesByCategoryUseCase(this.repository);

  Future<List<MovieEntity>> call(String categorySlug, int page) async {
    return await repository.fetchMoviesByCategory(categorySlug, page);
  }
}
