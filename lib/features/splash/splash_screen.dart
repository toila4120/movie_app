import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_event.dart';
import 'package:movie_app/features/home/presentation/bloc/home_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigator() {
    context.go(AppRouter.loginScreenPath);
  }

  @override
  void initState() {
    context.read<HomeBloc>().add(FetchMovieForBannerMovies());
    context.read<CategoriesBloc>().add(FetchCategories());
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        navigator();
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
