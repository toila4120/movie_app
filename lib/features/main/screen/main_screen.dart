import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/features/main/widget/bottom_navigator_bar.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell shell;
  const MainScreen({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigatorBar(
        onTap: (value) {
          shell.goBranch(value);
        },
        currentIndex: shell.currentIndex,
      ),
      body: shell,
    );
  }
}
