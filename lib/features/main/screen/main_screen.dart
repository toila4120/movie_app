import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/main/widget/bottom_navigator_bar.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell shell;
  const MainScreen({super.key, required this.shell});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _lastPressedAt = null;
  }

  void _onTabChange(int newIndex, BuildContext context) {
    if (newIndex != widget.shell.currentIndex) {
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
          'previousTabIndex': widget.shell.currentIndex,
        },
      );
    }
  }

  bool _shouldShowBottomNavBar(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final currentLocation = routerState.uri.toString();
    return currentLocation != '/home_tab/movie_detail/play_movie';
  }

  Future<bool> _onBackPressed() async {
    final now = DateTime.now();
    const duration = Duration(seconds: 2);
    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > duration) {
      _lastPressedAt = now;

      showToast(context, message: "Bấm lại lần nữa để thoát");
      return false;
    } else {
      await SystemNavigator.pop();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _shouldShowBottomNavBar(context)
            ? BottomNavigatorBar(
                onTap: (value) => _onTabChange(value, context),
                currentIndex: widget.shell.currentIndex,
              )
            : null,
        body: widget.shell,
      ),
    );
  }
}
