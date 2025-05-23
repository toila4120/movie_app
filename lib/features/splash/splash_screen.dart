import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:movie_app/core/utils/app_log.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCheckedCredentials = false;
  bool _isHomeDataLoaded = false;
  bool _isCategoriesLoaded = false;

  void _checkNavigationReady() {
    AppLog.debug(
        "🔍 _isCheckedCredentials: $_isCheckedCredentials, _isHomeDataLoaded: $_isHomeDataLoaded, _isCategoriesLoaded: $_isCategoriesLoaded");

    Future.delayed(const Duration(seconds: 1), () {
      // Thêm độ trễ 2 giây
      if (!_isCheckedCredentials) {
        navigateToLogin();
        return;
      }
      if (_isHomeDataLoaded && _isCategoriesLoaded) {
        // ignore: use_build_context_synchronously
        context.go(AppRouter.splashLoginScreenPath);
      }
    });
  }

  void navigateToLogin() {
    AppLog.info("🚀 Chuyển đến màn hình đăng nhập");
    Future.delayed(const Duration(seconds: 1), () {
      // Thêm độ trễ 2 giây
      // ignore: use_build_context_synchronously
      context.go(AppRouter.loginScreenPath);
    });
  }

  @override
  void initState() {
    super.initState();

    // Debug thông tin đã lưu
    _checkSavedLoginInfo();

    // Tải dữ liệu
    context.read<HomeBloc>().add(FetchMovieForBannerMovies());
    context.read<CategoriesBloc>().add(FetchCategories());

    // Kiểm tra thông tin đăng nhập đã lưu
    _checkLoginStatus();

    // Đặt một thời gian tối đa để chờ (để tránh trường hợp không phản hồi)
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (!_isCheckedCredentials) {
          AppLog.info("⏱️ Hết thời gian chờ - chuyển đến màn hình đăng nhập");
          navigateToLogin();
        }
      },
    );
  }

  Future<void> _checkSavedLoginInfo() async {
    try {
      final localDataSource = getIt<AuthLocalDataSource>();
      localDataSource.debugPrintSavedData();
    } catch (e) {
      AppLog.error("❌ Lỗi khi debug thông tin đã lưu: $e");
    }
  }

  Future<void> _checkLoginStatus() async {
    AppLog.info("🔄 Kiểm tra thông tin đăng nhập đã lưu");
    context.read<AuthenticationBloc>().add(CheckSavedCredentialsEvent());
    AppLog.info("⏱️ Hết thời gian chờ - chuyển đến màn hình đăng nhập");
  }

  Future<void> _handleLoginSuccess() async {
    AppLog.info("✅ Đăng nhập thành công, chờ tải dữ liệu");
    _checkNavigationReady();
  }

  void _handleStateChanges(dynamic state) {
    if (state is HomeState) {
      AppLog.debug("🏠 HomeState: loadingState=${state.loadingState}");
    } else if (state is CategoriesState) {
      AppLog.debug("📋 CategoriesState: loadingState=${state.loadingState}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            AppLog.debug(
                "🔐 AuthenticationState: isLoading=${state.isLoading}, user=${state.user != null ? 'Có' : 'Không'}, error=${state.error}");

            if (state.user != null &&
                state.isLoading == LoadingState.finished) {
              AppLog.info("✅ Đăng nhập thành công, chờ tải dữ liệu");
              _handleLoginSuccess();
            } else {
              AppLog.error(
                  "❌ Không có người dùng hoặc đăng nhập lỗi: ${state.error}");
              navigateToLogin();
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            _handleStateChanges(state);
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
            _handleStateChanges(state);
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
                width: 300.w,
                height: 300.w,
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
