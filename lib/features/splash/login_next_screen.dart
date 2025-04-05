import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/home/presentation/bloc/home_bloc.dart';

class LoginNextScreen extends StatefulWidget {
  const LoginNextScreen({super.key});

  @override
  State<LoginNextScreen> createState() => _LoginNextScreenState();
}

class _LoginNextScreenState extends State<LoginNextScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(
          FectchMovieForBannerMovies(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.loadingState.isFinished) {
          context.go(AppRouter.homeTabPath);
        }
      },
      child: AppContainer(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.large * 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.movieLogo,
              ),
              //   const Text(
              //     "Hôm này của bạn thế nào cùng NTĐ_Movie giải trí nhé",
              //     style: TextStyle(
              //       fontSize: 20,
              //       color: AppColor.primary500,
              //       fontWeight: FontWeight.w600,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              SizedBox(height: AppPadding.large),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return state.loadingState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
