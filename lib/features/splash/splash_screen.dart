import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/widget/widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        context.go(AppRouter.loginScreenPath);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Center(
        child: Image.asset(
          AppImage.movieLogo,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
