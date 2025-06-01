import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/app_bloc_observer.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/utils/env_validator.dart';
import 'package:movie_app/core/utils/app_log.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/core/bloc/app_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:movie_app/features/chatting/presentation/bloc/chat_bloc.dart';
import 'package:movie_app/features/download/presentation/bloc/download_bloc.dart';
import 'package:movie_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:movie_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:movie_app/features/mini_player/presentation/widget/mini_player.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_bloc.dart';
import 'package:movie_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:movie_app/features/mini_player/presentation/bloc/mini_player_bloc.dart';
import 'package:movie_app/injection_container.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    AppLog.info("✅ .env file loaded successfully");
  } catch (e) {
    AppLog.error("⚠️ Error loading .env file: $e");
    try {
      File envFile = File('.env');
      if (!await envFile.exists()) {
        await envFile.writeAsString('GEMINI_API_KEY=test_key');
        AppLog.info("✅ Created fallback .env file");
        await dotenv.load(fileName: ".env");
      }
    } catch (e) {
      AppLog.error("⚠️ Couldn't create fallback .env file: $e");
    }
  }

  EnvValidator.validateEnv();
  setup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPaintSizeEnabled = false;
  Bloc.observer = const AppBlocObserver();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc()),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => MovieBloc()),
        BlocProvider(create: (context) => ExploreBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => CategoriesBloc()),
        BlocProvider(create: (context) => getIt<AuthenticationBloc>()),
        BlocProvider(create: (context) => getIt<ChatBloc>()),
        BlocProvider(
          create: (context) => MiniPlayerBloc(
            authenticationBloc: context.read<AuthenticationBloc>(),
          ),
        ),
        BlocProvider(create: (context) => getIt<DownloadBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411, 467),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              routerConfig: AppRouter.router,
              builder: (context, child) {
                return Overlay(
                  initialEntries: [
                    OverlayEntry(
                      builder: (overlayContext) => Stack(
                        children: [
                          child!,
                          Builder(
                            builder: (miniPlayerContext) {
                              return const MiniPlayer();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
