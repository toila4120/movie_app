import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/features/authentication/data/datasources/remote/auth_remote_data_source.dart';
import 'package:movie_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:movie_app/features/authentication/domain/usecase/get_user_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/login_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/login_with_google_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/register_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_display_name_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_user_usecase.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/injection_container.dart';

void setupAuthenticationDi() {
  getIt.registerFactory(() => AuthenticationBloc());

  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  // getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginWithGoogleUsecase(getIt()));
  getIt.registerLazySingleton(() => UpdateDisplayNameUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserUseCase(getIt()));

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton(() => FirebaseAuth.instance);
}
