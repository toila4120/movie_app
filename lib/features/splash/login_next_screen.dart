import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/utils/show_toast.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_state.dart';
import 'package:movie_app/features/home/presentation/bloc/home_bloc.dart';

class LoginNextScreen extends StatefulWidget {
  const LoginNextScreen({super.key});

  @override
  State<LoginNextScreen> createState() => _LoginNextScreenState();
}

class _LoginNextScreenState extends State<LoginNextScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(FetchMovieForBannerMovies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, homeState) {
            if (homeState.loadingState.isFinished) {
              final categories =
                  context.read<CategoriesBloc>().state.categories;
              context
                  .read<HomeBloc>()
                  .add(FetchMovieWithGenre(genres: categories));
              context.go(AppRouter.homeTabPath);
            }
          },
        ),
        BlocListener<CategoriesBloc, CategoriesState>(
          listener: (context, categoriesState) {
            if (categoriesState.loadingState.isError) {
              showToast(context,
                  message:
                      categoriesState.errorMessage ?? 'Lỗi khi tải danh mục');
            }
          },
        ),
      ],
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
