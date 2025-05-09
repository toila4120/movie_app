import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app/features/authentication/data/datasources/local/auth_local_data_source.dart';
import 'package:movie_app/features/authentication/data/datasources/remote/auth_remote_data_source.dart';
import 'package:movie_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:movie_app/features/authentication/domain/usecase/get_remember_me_status_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/get_saved_credentials_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/get_user_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/login_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/login_with_google_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/register_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/save_remember_me_status_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/save_user_credentials_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_display_name_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_user_usecase.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/injection_container.dart';

void setupAuthenticationDi() {
  // Register SharedPreferences instance
  SharedPreferences.getInstance().then((sharedPreferences) {
    getIt.registerSingleton(sharedPreferences);

    // Register local data source
    getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt<SharedPreferences>()),
    );

    // Register repository with both remote and local data sources
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt<AuthRemoteDataSource>(),
        getIt<AuthLocalDataSource>(),
      ),
    );

    // Register "Remember Me" use cases
    getIt.registerLazySingleton(
        () => SaveUserCredentialsUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(
        () => GetSavedCredentialsUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(
        () => SaveRememberMeStatusUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(
        () => GetRememberMeStatusUseCase(getIt<AuthRepository>()));
  });

  // Register the authentication bloc with use cases
  getIt.registerFactory(() => AuthenticationBloc(
        getIt<LoginUseCase>(),
        getIt<SaveUserCredentialsUseCase>(),
        getIt<GetSavedCredentialsUseCase>(),
        getIt<SaveRememberMeStatusUseCase>(),
        getIt<GetRememberMeStatusUseCase>(),
      ));

  // Register existing use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
      () => LoginWithGoogleUsecase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
      () => UpdateDisplayNameUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetUserUseCase(getIt<AuthRepository>()));

  // Register remote data source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<FirebaseAuth>()),
  );

  // Register Firebase Auth instance
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
}
