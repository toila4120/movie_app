import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/categories/domain/repository/categories_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getAllCategories();
  }
}