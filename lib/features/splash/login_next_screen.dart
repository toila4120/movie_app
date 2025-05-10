import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/bloc/app_bloc.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/utils/show_toast.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
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
    super.initState();

    // Đảm bảo dữ liệu người dùng được tải trước khi chuyển đến màn hình chính
    _ensureUserDataLoaded();

    // Tải dữ liệu phim và thể loại
    context.read<HomeBloc>().add(FetchMovieForBannerMovies());
    final categories = context.read<CategoriesBloc>().state.categories;
    context.read<HomeBloc>().add(FetchMovieWithGenre(genres: categories));
  }

  void _ensureUserDataLoaded() {
    // Kiểm tra xem dữ liệu người dùng đã được tải chưa
    final appState = context.read<AppBloc>().state;
    final authState = context.read<AuthenticationBloc>().state;

    if (appState.userModel == null && authState.user != null) {
      print(
          "LoginNextScreen: Tải dữ liệu người dùng với uid ${authState.user!.uid}");
      context.read<AppBloc>().add(FetchUserEvent(uid: authState.user!.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, homeState) {
            if (homeState.loadingState.isFinished) {
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
        // Thêm listener cho AppBloc để xử lý lỗi khi tải dữ liệu người dùng
        BlocListener<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading.isError && appState.error != null) {
              showToast(context,
                  message: 'Lỗi tải dữ liệu người dùng: ${appState.error}');
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
                  return state.loadingPopularMovies.isLoading
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
