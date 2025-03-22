import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'categories_model.dart';

extension CategoryMapper on CategoriesModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id ?? '',
      name: name ?? '',
      slug: slug ?? '',
    );
  }
}
