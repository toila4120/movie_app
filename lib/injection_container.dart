import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/features/authentication/di/authentication_di.dart';
import 'package:movie_app/features/categories/di/categories_di.dart';
import 'package:movie_app/features/chatting/di/chatting_di.dart';
import 'package:movie_app/features/download/di/download_injection.dart';
import 'package:movie_app/features/explore/di/explore_di.dart';
import 'package:movie_app/features/home/di/home_di.dart';
import 'package:movie_app/features/movie/di/movie_di.dart';
import 'package:movie_app/features/profile/di/profile_di.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<Dio>(() => Dio());
  setupCategoriesDi();
  setupAuthenticationDi();
  setupMovieDi();
  setupHomeDi();
  setupExpolereDi();
  setupProfileDi();
  setupChattingDi();
  setupDownloadDependencies();
}
