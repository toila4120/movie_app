import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/core/bloc/app_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_event.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_state.dart';

part 'presentation/screen/login_screen.dart';
part 'presentation/screen/register_screen.dart';
part 'presentation/widget/button_login_with_google.dart';
part 'presentation/screen/select_genre_screen.dart';
