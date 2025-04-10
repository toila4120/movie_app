import 'package:movie_app/features/movie/data/datasource/movie_remote_datasource.dart';
import 'package:movie_app/features/movie/data/repository/movie_repository_impl.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';
import 'package:movie_app/features/movie/domain/usecase/fectch_movie_actor_usecase.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_movie_by_list_usecase.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_movie_detail_usecase.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_movies_by_category_usecase.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_new_movie_usecase.dart';
import 'package:movie_app/injection_container.dart';

void setupMovieDi() {
  getIt.registerLazySingleton<MovieRemoteDatasource>(
    () => MovieRemoteDatasourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => FetchMoviesByCategoryUseCase(getIt()));
  getIt.registerLazySingleton(() => FetchMovieDetailUsecase(getIt()));
  getIt.registerLazySingleton(() => FetchMovieByListUsecase(getIt()));
  getIt.registerLazySingleton(() => FectchMovieActorUsecase(getIt()));
  getIt.registerLazySingleton(() => FetchNewMovieUsecase(getIt()));
}
