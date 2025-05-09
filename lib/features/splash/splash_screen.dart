import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/authentication/data/datasources/local/auth_local_data_source.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_event.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_state.dart';
import 'package:movie_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:movie_app/injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCheckedCredentials = false;
  bool _isHomeDataLoaded = false;
  bool _isCategoriesLoaded = false;

  // Kiểm tra nếu đã sẵn sàng để chuyển màn hình
  void _checkNavigationReady() {
    print(
        "🔍 _isCheckedCredentials: $_isCheckedCredentials, _isHomeDataLoaded: $_isHomeDataLoaded, _isCategoriesLoaded: $_isCategoriesLoaded");

    // Nếu không có đăng nhập tự động (đã kiểm tra xong) thì chuyển đến màn hình đăng nhập
    if (!_isCheckedCredentials) {
      navigateToLogin();
      return;
    }

    // Nếu có người dùng đã đăng nhập và dữ liệu đã tải xong thì chuyển đến màn hình chính
    if (_isHomeDataLoaded && _isCategoriesLoaded) {
      context.go(AppRouter.splashLoginScreenPath);
    }
  }

  void navigateToLogin() {
    print("🚀 Chuyển đến màn hình đăng nhập");
    context.go(AppRouter.loginScreenPath);
  }

  @override
  void initState() {
    super.initState();

    // Debug thông tin đã lưu
    try {
      final localDataSource = getIt<AuthLocalDataSource>();
      localDataSource.debugPrintSavedData();
    } catch (e) {
      print("❌ Lỗi khi debug thông tin đã lưu: $e");
    }

    // Tải dữ liệu
    context.read<HomeBloc>().add(FetchMovieForBannerMovies());
    context.read<CategoriesBloc>().add(FetchCategories());

    // Kiểm tra thông tin đăng nhập đã lưu
    print("🔄 Kiểm tra thông tin đăng nhập đã lưu");
    context.read<AuthenticationBloc>().add(CheckSavedCredentialsEvent());

    // Đặt một thời gian tối đa để chờ (để tránh trường hợp không phản hồi)
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (!_isCheckedCredentials) {
          print("⏱️ Hết thời gian chờ - chuyển đến màn hình đăng nhập");
          navigateToLogin();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            print(
                "🔐 AuthenticationState: isLoading=${state.isLoading}, user=${state.user != null ? 'Có' : 'Không'}, error=${state.error}");

            if (state.isLoading != LoadingState.loading) {
              setState(() {
                _isCheckedCredentials = true;
              });

              // Nếu đăng nhập thành công, đánh dấu để chờ tải dữ liệu xong
              if (state.user != null &&
                  state.isLoading == LoadingState.finished) {
                print("✅ Đăng nhập thành công, chờ tải dữ liệu");
                _checkNavigationReady();
              } else {
                // Nếu không có người dùng hoặc đăng nhập lỗi, chuyển đến màn hình đăng nhập
                print(
                    "❌ Không có người dùng hoặc đăng nhập lỗi: ${state.error}");
                navigateToLogin();
              }
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            print("🏠 HomeState: loadingState=${state.loadingState}");
            if (state.loadingState.isFinished || state.loadingState.isError) {
              setState(() {
                _isHomeDataLoaded = true;
              });
              _checkNavigationReady();
            }
          },
        ),
        BlocListener<CategoriesBloc, CategoriesState>(
          listener: (context, state) {
            print("📋 CategoriesState: loadingState=${state.loadingState}");
            if (state.loadingState == LoadingState.finished ||
                state.loadingState == LoadingState.error) {
              setState(() {
                _isCategoriesLoaded = true;
              });
              _checkNavigationReady();
            }
          },
        ),
      ],
      child: AppContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.movieLogo,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
