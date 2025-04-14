import 'package:movie_app/features/explore/data/datasource/remote/explore_remote_datasource.dart';
import 'package:movie_app/features/explore/data/repository/explore_repository_impl.dart';
import 'package:movie_app/features/explore/domain/repository/explore_repository.dart';
import 'package:movie_app/features/explore/domain/usecase/filter_movie_usecase.dart';
import 'package:movie_app/features/explore/domain/usecase/get_region_usecase.dart';
import 'package:movie_app/features/explore/domain/usecase/search_movie_usecase.dart';
import 'package:movie_app/injection_container.dart';

void setupExpolereDi() {
  // Data sources
  getIt.registerLazySingleton<ExploreRemoteDatasource>(
    () => ExploreRemoteDatasourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SearchMovieUsecase(getIt()));
  getIt.registerLazySingleton(() => GetRegionsUsecase(getIt()));
  getIt.registerLazySingleton(() => FilterMovieUsecase(getIt()));
}
