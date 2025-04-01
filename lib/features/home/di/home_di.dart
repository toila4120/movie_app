import 'package:movie_app/features/home/data/datasource/home_remote_datasource.dart';
import 'package:movie_app/features/home/data/repository/home_repository_impl.dart';
import 'package:movie_app/features/home/domain/repository/home_repository.dart';
import 'package:movie_app/features/home/domain/usecase/fetch_movie_for_banner_usecase.dart';
import 'package:movie_app/injection_container.dart';

void setupHomeDi() {
  getIt.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => FetchMovieForBannerUsecase(getIt()));
}
