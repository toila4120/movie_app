import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/features/main/widget/bottom_navigator_bar.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell shell;
  const MainScreen({super.key, required this.shell});

  void _onTabChange(int newIndex, BuildContext context) {
    if (newIndex != shell.currentIndex) {
      const tabPaths = [
        AppRouter.homeTabPath,
        AppRouter.exploreScreenPath,
        AppRouter.chattingTabPath,
        AppRouter.profileTabPath,
      ];

      context.go(
        tabPaths[newIndex],
        extra: {
          'currentTabIndex': newIndex,
          'previousTabIndex': shell.currentIndex,
        },
      );
    }
  }

  bool _shouldShowBottomNavBar(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final currentLocation = routerState.uri.toString();
    return currentLocation != '/home_tab/movie_detail/play_movie';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _shouldShowBottomNavBar(context)
          ? BottomNavigatorBar(
              onTap: (value) => _onTabChange(value, context),
              currentIndex: shell.currentIndex,
            )
          : null,
      body: shell,
    );
  }
}
