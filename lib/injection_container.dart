import 'package:get_it/get_it.dart';
import 'package:movie_app/features/authencation/di/authentication_di.dart';
import 'package:movie_app/features/categories/di/categories_di.dart';

final getIt = GetIt.instance;

void setup() {
  setupCategoriesDi();
  setupAuthenticationDi();
}
