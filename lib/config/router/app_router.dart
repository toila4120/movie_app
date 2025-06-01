import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_navigator_observer.dart';
import 'package:movie_app/features/authentication/authentication.dart';
import 'package:movie_app/features/authentication/presentation/screen/forgot_password_screen.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/features/categories/categories.dart';
import 'package:movie_app/features/categories/presentation/screen/watched_movies_screen.dart';
import 'package:movie_app/features/chatting/chatting.dart';
import 'package:movie_app/features/explore/explore.dart';
import 'package:movie_app/features/home/home.dart';
import 'package:movie_app/features/main/screen/main_screen.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movie/movie.dart';
import 'package:movie_app/features/profile/profile.dart';
import 'package:movie_app/features/splash/login_next_screen.dart';
import 'package:movie_app/features/splash/splash_screen.dart';
import 'package:movie_app/features/download/presentation/bloc/download_bloc.dart';
import 'package:movie_app/features/download/presentation/widgets/downloaded_movies_page.dart';
import 'package:movie_app/features/download/presentation/widgets/downloaded_episodes_page.dart';
import 'package:movie_app/features/download/presentation/widgets/download_episodes_page.dart';
import 'package:movie_app/features/download/presentation/widgets/offline_video_player_page.dart';
import 'package:movie_app/features/download/di/download_injection.dart';
import 'package:movie_app/features/mini_player/presentation/bloc/mini_player_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/download/presentation/widgets/offline_video_helper.dart';

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
  static const String _forgotPasswordScreenName = 'forgot_password_screen';
  static const String forgotPasswordScreenPath =
      '/login_screen/forgot_password_screen';
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
  static const String _likeMovieScreenName = 'like_movie_screen';
  static const String likeMovieScreenPath = '/profile_tab/like_movie_screen';
  static const String _splashLoginScreenName = 'splash_login_screen';
  static const String splashLoginScreenPath = '/splash_login_screen';
  static const String _chattingTabName = 'chatting_tab';
  static const String chattingTabPath = '/chatting_tab';
  static const String _exploreScreenTabName = 'explore_tab';
  static const String exploreScreenPath = '/explore_tab';
  static const String _watchedMovieScreenName = 'watched_movie_screen';
  static const String watchedMovieScreenPath = '/home_tab/watched_movie_screen';

  static const String _downloadedMoviesScreenName = 'downloaded_movies_screen';
  static const String downloadedMoviesScreenPath =
      '/profile_tab/downloaded_movies_screen';
  static const String _downloadedEpisodesScreenName =
      'downloaded_episodes_screen';
  static const String downloadedEpisodesScreenPath =
      '/profile_tab/downloaded_movies_screen/downloaded_episodes_screen';
  static const String _offlineVideoPlayerScreenName =
      'offline_video_player_screen';
  static const String offlineVideoPlayerScreenPath =
      '/profile_tab/downloaded_movies_screen/offline_video_player_screen';
  static const String _downloadEpisodesScreenName = 'download_episodes_screen';
  static const String downloadEpisodesScreenPath =
      '/home_tab/movie_detail/download_episodes_screen';

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
    redirect: (context, state) {
      return null;
    },
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
                    name: _watchedMovieScreenName,
                    path: '/$_watchedMovieScreenName',
                    pageBuilder: (context, state) {
                      return _buildPageWithDefaultTransition(
                        context: context,
                        state: state,
                        child: const WatchedMoviesScreen(),
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
                            final movie = extra['movie'] as MovieEntity?;

                            // Validate movie không null
                            if (movie == null) {
                              return _buildPageWithDefaultTransition(
                                context: context,
                                state: state,
                                child: Scaffold(
                                  body: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Dữ liệu phim không hợp lệ'),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Quay lại'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            int episodeIndex =
                                extra['episodeIndex'] as int? ?? 0;
                            int serverIndex = extra['serverIndex'] as int? ?? 0;
                            final currentPosition =
                                extra['currentPosition'] as int? ?? 0;

                            // Validate bounds
                            if (movie.episodes.isEmpty) {
                              serverIndex = 0;
                              episodeIndex = 0;
                            } else {
                              if (serverIndex >= movie.episodes.length) {
                                serverIndex = 0;
                              }

                              final selectedServer =
                                  movie.episodes[serverIndex];
                              if (selectedServer.serverData.isEmpty) {
                                episodeIndex = 0;
                              } else if (episodeIndex >=
                                  selectedServer.serverData.length) {
                                episodeIndex =
                                    selectedServer.serverData.length - 1;
                              }

                              if (episodeIndex < 0) {
                                episodeIndex = 0;
                              }
                            }

                            return _buildPageWithDefaultTransition(
                              context: context,
                              state: state,
                              child: Movie(
                                movie: movie,
                                episodeIndex: episodeIndex,
                                serverIndex: serverIndex,
                                currentPosition: currentPosition,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          name: _downloadEpisodesScreenName,
                          path: '/$_downloadEpisodesScreenName',
                          pageBuilder: (context, state) {
                            final movie = OfflineVideoHelper.tempMovie;

                            return _buildPageWithDefaultTransition(
                              context: context,
                              state: state,
                              child: BlocProvider(
                                create: (context) =>
                                    downloadGetIt<DownloadBloc>(),
                                child: DownloadEpisodesPage(
                                  movie: movie,
                                ),
                              ),
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
                  GoRoute(
                    name: _likeMovieScreenName,
                    path: '/$_likeMovieScreenName',
                    pageBuilder: (context, state) =>
                        _buildPageWithDefaultTransition(
                      context: context,
                      state: state,
                      child: const LikeMovieScreen(),
                    ),
                  ),
                  GoRoute(
                    name: _downloadedMoviesScreenName,
                    path: '/$_downloadedMoviesScreenName',
                    pageBuilder: (context, state) {
                      return _buildPageWithDefaultTransition(
                        context: context,
                        state: state,
                        child: BlocProvider(
                          create: (context) => downloadGetIt<DownloadBloc>(),
                          child: const DownloadedMoviesPage(),
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        name: _downloadedEpisodesScreenName,
                        path: '/$_downloadedEpisodesScreenName',
                        pageBuilder: (context, state) {
                          final movieName = OfflineVideoHelper.tempMovieName ??
                              'Unknown Movie';
                          final episodes =
                              OfflineVideoHelper.tempEpisodes ?? [];

                          return _buildPageWithDefaultTransition(
                            context: context,
                            state: state,
                            child: DownloadedEpisodesPage(
                              movieName: movieName,
                              episodes: episodes,
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            name: _offlineVideoPlayerScreenName,
                            path: '/$_offlineVideoPlayerScreenName',
                            pageBuilder: (context, state) {
                              final episode = OfflineVideoHelper.tempEpisode!;
                              final allEpisodes =
                                  OfflineVideoHelper.tempPlaylist ?? [];
                              final currentIndex =
                                  OfflineVideoHelper.tempCurrentIndex;

                              return _buildPageWithDefaultTransition(
                                context: context,
                                state: state,
                                child: MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<MiniPlayerBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<AuthenticationBloc>(),
                                    ),
                                  ],
                                  child: OfflineVideoPlayerPage(
                                    episode: episode,
                                    allEpisodes: allEpisodes,
                                    currentIndex: currentIndex,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
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
        routes: [
          GoRoute(
            name: _forgotPasswordScreenName,
            path: '/$_forgotPasswordScreenName',
            pageBuilder: (context, state) {
              return _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const ForgotPasswordScreen(),
              );
            },
          ),
        ],
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
