import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/features/authencation/data/datasources/remote/auth_remote_data_source.dart';
import 'package:movie_app/features/authencation/data/repository/auth_repository_impl.dart';
import 'package:movie_app/features/authencation/domain/repository/auth_repository.dart';
import 'package:movie_app/features/authencation/domain/usecase/login_usecase.dart';
import 'package:movie_app/features/authencation/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/injection_container.dart';

void setupAuthenticationDi() {
  getIt.registerFactory(() => AuthenticationBloc());

  getIt.registerLazySingleton(() => LoginUseCase(getIt()));

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton(() => FirebaseAuth.instance);
}
