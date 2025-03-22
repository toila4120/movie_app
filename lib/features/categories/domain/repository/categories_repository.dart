import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAllCategories();
}