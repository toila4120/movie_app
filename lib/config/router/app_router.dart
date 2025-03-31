import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_navigator_observer.dart';
import 'package:movie_app/features/authentication/authentication.dart';
import 'package:movie_app/features/categories/categories.dart';
import 'package:movie_app/features/home/home.dart';
import 'package:movie_app/features/main/screen/main_screen.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';
import 'package:movie_app/features/movie/movie.dart';
import 'package:movie_app/features/movie/presentation/widget/movie.dart';
import 'package:movie_app/features/profile/profile.dart';
import 'package:movie_app/features/splash/splash_screen.dart';

abstract class AppRouter {
  static const String _baseRoute = '/';

  static const String _homeTabName = "home_tab_name";
  static const String homeTabPath = "/home_tab";

  static const String _allCategoriesName = "all_categories";
  static const String allCategoriesPath = "/home_tab/all_categories";

  static const String _listMovieName = "list_movie";
  static const String listMoviePath = "/home_tab/list_movie";

  static const String _categoriesTabName = "categories_tab_name";
  static const String categoriesTabPath = "/categories_tab";

  static const String _movieDetailName = "movie_detail";
  static const String movieDetailPath = "/home_tab/movie_detail";

  static const String _playMovieName = "play_movie";
  static const String playMoviePath = "/play_movie";

  static const String _loginScreenName = 'login_screen';
  static const String loginScreenPath = '/login_screen';

  static const String _registerScreenName = 'register_screen';
  static const String registerScreenPath = '/register_screen';

  static const String _profileTabName = 'profile_tab';
  static const String profileTabPath = '/profile_tab';

  static const String _chooseAvatarScreenName = 'choose_avatar_screen';
  static const String chooseAvatarScreenPath =
      '/profile_tab/choose_avatar_screen';

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
                    name: _listMovieName,
                    path: '/$_listMovieName',
                    pageBuilder: (context, state) {
                      final Map<String, dynamic> extra =
                          state.extra as Map<String, dynamic>? ?? {};
                      final String input =
                          extra['input'] as String? ?? 'Hành động';
                      final String input2 =
                          extra['input2'] as String? ?? 'hanh-dong';
                      return _buildPageWithDefaultTransition<void>(
                        context: context,
                        state: state,
                        child: ListMovie(
                          title: input,
                          slug: input2,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    name: _movieDetailName,
                    path: '/$_movieDetailName',
                    pageBuilder: (context, state) {
                      final Map<String, dynamic> extra =
                          state.extra as Map<String, dynamic>? ?? {};
                      final MovieModel movie = extra['movie'] as MovieModel;
                      return _buildPageWithDefaultTransition<void>(
                        context: context,
                        state: state,
                        child: MovieDetail(
                          movie: movie,
                        ),
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: _profileTabName,
                path: profileTabPath,
                builder: (context, state) {
                  return const ProfileScreen();
                },
                routes: [
                  GoRoute(
                    name: _chooseAvatarScreenName,
                    path: '/$_chooseAvatarScreenName',
                    pageBuilder: (context, state) {
                      return _buildPageWithDefaultTransition<void>(
                        context: context,
                        state: state,
                        child: const ChooseAvatarScreen(),
                      );
                    },
                  )
                ],
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
        },
      ),
      GoRoute(
        name: _playMovieName,
        path: '/$_playMovieName',
        pageBuilder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>? ?? {};
          final String url = extra['url'] as String;
          return _buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: Movie(
              url: url,
            ),
          );
        },
      ),
    ],
  );
}
