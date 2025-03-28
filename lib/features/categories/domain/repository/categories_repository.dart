import 'package:movie_app/features/categories/data/model/movie_model.dart';
import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';

abstract class CategoriesRepository {
  Future<List<CategoryEntity>> getAllCategories();
  Future<List<MovieModel>> fetchMoviesByCategory(String categorySlug, int page);
}
