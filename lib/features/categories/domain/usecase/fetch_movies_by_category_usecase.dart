import 'package:movie_app/features/categories/data/model/movie_model.dart';
import 'package:movie_app/features/categories/domain/repository/categories_repository.dart';

class FetchMoviesByCategoryUseCase {
  final CategoriesRepository repository;

  FetchMoviesByCategoryUseCase(this.repository);

  Future<List<MovieModel>> call(String categorySlug, int page) async {
    return await repository.fetchMoviesByCategory(categorySlug, page);
  }
}
