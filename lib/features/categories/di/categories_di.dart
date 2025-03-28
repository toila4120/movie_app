import 'package:movie_app/features/categories/data/datasource/categories_remote_data_source.dart';
import 'package:movie_app/features/categories/data/repository/category_repository_impl.dart';
import 'package:movie_app/features/categories/domain/repository/categories_repository.dart';
import 'package:movie_app/features/categories/domain/usecase/get_all_categories_use_case.dart';
import 'package:movie_app/injection_container.dart';

void setupCategoriesDi() {
  getIt.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<CategoriesRepository>(
    () => CategoryRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllCategories(getIt()));
}
