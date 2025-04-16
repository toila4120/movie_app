import 'package:movie_app/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:movie_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:movie_app/features/profile/domain/repository/profile_repository.dart';
import 'package:movie_app/features/profile/domain/usecase/get_favorite_movies_usecase.dart';
import 'package:movie_app/features/profile/domain/usecase/get_movie_by_slug_usecase.dart';
import 'package:movie_app/injection_container.dart';

void setupProfileDi() {
  // Data sources
  getIt.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt()));

  // UseCase
  getIt.registerLazySingleton<GetFavoriteMoviesUsecase>(
      () => GetFavoriteMoviesUsecase(getIt()));
  getIt.registerLazySingleton<GetMovieBySlugUsecase>(
      () => GetMovieBySlugUsecase(getIt()));
}
