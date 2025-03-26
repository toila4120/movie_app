import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/utils/app_assets.dart';
import 'package:movie_app/core/utils/disable_glow_behavior.dart';
import 'package:movie_app/core/utils/size_config.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/bloc/app_bloc.dart';

part 'presentation/screen/profile_screen.dart';
part 'presentation/screen/choose_avatar_screen.dart';
