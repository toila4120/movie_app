import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/app_assets.dart';
import 'package:movie_app/core/bloc/app_bloc.dart';
import 'package:movie_app/core/widget/src/base_scroll_view.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/features/categories/categories.dart';
import 'package:movie_app/features/categories/presentation/widget/item_movie_shimer.dart';
import 'package:movie_app/features/mini_player/presentation/bloc/mini_player_bloc.dart';
import 'package:movie_app/features/profile/presentation/bloc/profile_bloc.dart';

// Download module imports
import 'package:movie_app/features/download/presentation/bloc/download_bloc.dart';
import 'package:movie_app/features/download/presentation/widgets/downloaded_movies_page.dart';
import 'package:movie_app/features/download/di/download_injection.dart';

part 'presentation/screen/profile_screen.dart';
part 'presentation/screen/choose_avatar_screen.dart';
part 'presentation/screen/like_movie_screen.dart';
