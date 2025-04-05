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
        AppRouter.categoriesTabPath,
        AppRouter.chattingTabPath,
        AppRouter.profileTabPath,
      ];

      // Điều hướng đến tab mới với extra
      context.go(
        tabPaths[newIndex],
        extra: {
          'currentTabIndex': newIndex,
          'previousTabIndex': shell.currentIndex,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigatorBar(
        onTap: (value) => _onTabChange(value, context),
        currentIndex: shell.currentIndex,
      ),
      body: shell,
    );
  }
}
