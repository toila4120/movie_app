import 'package:movie_app/features/categories/data/datasource/categories_remote_data_source.dart';
import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/categories/domain/repository/categories_repository.dart';

class CategoryRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource categoriesRemoteDataSource;

  CategoryRepositoryImpl(this.categoriesRemoteDataSource);

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    try {
      return await categoriesRemoteDataSource.fetchCategories();
    } catch (e) {
      rethrow;
    }
  }
}
