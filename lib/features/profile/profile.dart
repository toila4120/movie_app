import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/app_assets.dart';
import 'package:movie_app/core/utils/size_config.dart';
import 'package:movie_app/core/bloc/app_bloc.dart';

part 'presentation/screen/profile_screen.dart';
part 'presentation/screen/choose_avatar_screen.dart';
