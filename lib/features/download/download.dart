import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/features/download/domain/entities/download_entity.dart';
import 'package:movie_app/features/download/presentation/bloc/download_bloc.dart';
import 'package:movie_app/features/download/presentation/widgets/offline_video_helper.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_bloc.dart';
import 'package:movie_app/features/download/data/services/download_cache_service.dart';
import 'package:movie_app/features/download/di/download_injection.dart';

part 'presentation/widgets/download_bottom_sheet.dart';
