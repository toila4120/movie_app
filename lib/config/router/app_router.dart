import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_navigator_observer.dart';
import 'package:movie_app/features/authencation/authencation.dart';
import 'package:movie_app/features/categories/categories.dart';
import 'package:movie_app/features/home/home.dart';
import 'package:movie_app/features/main/screen/main_screen.dart';
import 'package:movie_app/features/movie/movie.dart';
import 'package:movie_app/features/splash/splash_screen.dart';

abstract class AppRouter {
  static const String _baseRoute = '/';

  static const String _homeTabName = "home_tab_name";
  static const String homeTabPath = "/home_tab";

  static const String _allCategoriesName = "all_categories";
  static const String allCategoriesPath = "/home_tab/all_categories";

  static const String _categoriesTabName = "categories_tab_name";
  static const String categoriesTabPath = "/categories_tab";

  static const String _movieDetailName = "movie_detail";
  static const String movieDetailPath = "/home_tab/movie_detail";

  static const String _loginScreenName = 'login_screen';
  static const String loginScreenPath = '/login_screen';

  static const String _registerScreenName = 'register_screen';
  static const String registerScreenPath = '/register_screen';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static CustomTransitionPage _buildPageWithDefaultTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: _baseRoute,
    observers: [
      MyNavigatorObserver(),
    ],
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: _baseRoute,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(
            shell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: _homeTabName,
                path: homeTabPath,
                builder: (context, state) {
                  return const HomePage();
                },
                routes: [
                  GoRoute(
                    name: _allCategoriesName,
                    path: '/$_allCategoriesName',
                    pageBuilder: (context, state) {
                      return _buildPageWithDefaultTransition<void>(
                        context: context,
                        state: state,
                        child: const CategoriesScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: _movieDetailName,
                    path: '/$_movieDetailName',
                    pageBuilder: (context, state) {
                      return _buildPageWithDefaultTransition<void>(
                        context: context,
                        state: state,
                        child: const MovieDetail(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: _categoriesTabName,
                path: categoriesTabPath,
                builder: (context, state) {
                  return const CategoriesScreen();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: _loginScreenName,
        path: loginScreenPath,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
          name: _registerScreenName,
          path: registerScreenPath,
          builder: (context, state) {
            return const RegisterScreen();
          }),
    ],
  );
}
