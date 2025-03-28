import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';

abstract class CategoriesRepository {
  Future<List<CategoryEntity>> getAllCategories();
}
