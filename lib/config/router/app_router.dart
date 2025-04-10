import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_navigator_observer.dart';
import 'package:movie_app/features/authentication/authentication.dart';
import 'package:movie_app/features/categories/categories.dart';
import 'package:movie_app/features/chatting/presentation/screen/chatting_screen.dart';
import 'package:movie_app/features/explore/explore.dart';
import 'package:movie_app/features/home/home.dart';
import 'package:movie_app/features/main/screen/main_screen.dart';
import 'package:movie_app/features/movie/movie.dart';
import 'package:movie_app/features/profile/profile.dart';
import 'package:movie_app/features/splash/login_next_screen.dart';
import 'package:movie_app/features/splash/splash_screen.dart';

abstract class AppRouter {
  static const String _baseRoute = '/';
  static const String _homeTabName = "home_tab_name";
  static const String homeTabPath = "/home_tab";
  static const String _allCategoriesName = "all_categories";
  static const String allCategoriesPath = "/home_tab/all_categories";
  static const String _listMovieName = "list_movie";
  static const String listMoviePath = "/home_tab/list_movie";
  static const String _movieDetailName = "movie_detail";
  static const String movieDetailPath = "/home_tab/movie_detail";
  static const String _playMovieName = "play_movie";
  static const String playMoviePath = "/home_tab/movie_detail/play_movie";
  static const String _loginScreenName = 'login_screen';
  static const String loginScreenPath = '/login_screen';
  static const String _registerScreenName = 'register_screen';
  static const String registerScreenPath = '/register_screen';
  static const String _selectGenreScreenName = 'select_genre_screen';
  static const String selectGenreScreenPath =
      '/register_screen/select_genre_screen';
  static const String _profileTabName = 'profile_tab';
  static const String profileTabPath = '/profile_tab';
  static const String _chooseAvatarScreenName = 'choose_avatar_screen';
  static const String chooseAvatarScreenPath =
      '/profile_tab/choose_avatar_screen';
  static const String _splashLoginScreenName = 'splash_login_screen';
  static const String splashLoginScreenPath = '/splash_login_screen';
  static const String _chattingTabName = 'chatting_tab';
  static const String chattingTabPath = '/chatting_tab';
  static const String _exploreScreenTabName = 'explore_tab';
  static const String exploreScreenPath = '/explore_tab';

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
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        final extra = state.extra as Map<String, dynamic>?;
        final currentTabIndex = extra?['currentTabIndex'] as int? ?? 0;
        final previousTabIndex = extra?['previousTabIndex'] as int? ?? 0;

        final begin = currentTabIndex > previousTabIndex
            ? const Offset(-1.0, 0.0)
            : const Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
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
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(shell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: _homeTabName,
                path: homeTabPath,
                pageBuilder: (context, state) {
                  return _buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: const HomePage(),
                  );
                },
                routes: [
                  GoRoute(
                    name: _allCategoriesName,
                    path: '/$_allCategoriesName',
                    pageBuilder: (context, state) =>
                        _buildPageWithDefaultTransition(
                      context: context,
                      state: state,
                      child: const CategoriesScreen(),
                    ),
                  ),
                  GoRoute(
                    name: _listMovieName,
                    path: '/$_listMovieName',
                    pageBuilder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>? ?? {};
                      final input = extra['input'] as String? ?? 'Hành động';
                      final input2 = extra['input2'] as String? ?? 'hanh-dong';
                      return _buildPageWithDefaultTransition(
                        context: context,
                        state: state,
                        child: ListMovie(title: input, slug: input2),
                      );
                    },
                  ),
                  GoRoute(
                      name: _movieDetailName,
                      path: '/$_movieDetailName',
                      pageBuilder: (context, state) {
                        return _buildPageWithDefaultTransition(
                          context: context,
                          state: state,
                          child: const MovieDetail(),
                        );
                      },
                      routes: [
                        GoRoute(
                          name: _playMovieName,
                          path: '/$_playMovieName',
                          pageBuilder: (context, state) {
                            final extra =
                                state.extra as Map<String, dynamic>? ?? {};
                            final url = extra['url'] as String;
                            return _buildPageWithDefaultTransition(
                              context: context,
                              state: state,
                              child: Movie(url: url),
                            );
                          },
                        ),
                      ]),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: _exploreScreenTabName,
                path: exploreScreenPath,
                pageBuilder: (context, state) {
                  return _buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: const ExploreScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: _chattingTabName,
                path: chattingTabPath,
                pageBuilder: (context, state) {
                  return _buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: const ChattingScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: _profileTabName,
                path: profileTabPath,
                pageBuilder: (context, state) {
                  return _buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: const ProfileScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    name: _chooseAvatarScreenName,
                    path: '/$_chooseAvatarScreenName',
                    pageBuilder: (context, state) =>
                        _buildPageWithDefaultTransition(
                      context: context,
                      state: state,
                      child: const ChooseAvatarScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: _loginScreenName,
        path: loginScreenPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: _registerScreenName,
        path: registerScreenPath,
        builder: (context, state) => const RegisterScreen(),
        routes: [
          GoRoute(
            name: _selectGenreScreenName,
            path: '/$_selectGenreScreenName',
            pageBuilder: (context, state) {
              return _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const SelectGenreScreen(),
              );
            },
          )
        ],
      ),
      GoRoute(
        name: _splashLoginScreenName,
        path: '/$_splashLoginScreenName',
        pageBuilder: (context, state) {
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LoginNextScreen(),
          );
        },
      )
    ],
  );
}
