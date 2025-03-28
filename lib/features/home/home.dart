import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/utils/disable_glow_behavior.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_event.dart';

part 'presentation/screen/home_page.dart';
part 'presentation/widget/banner_home.dart';
part 'presentation/widget/continue_watching.dart';
part 'presentation/widget/popular.dart';
part 'presentation/widget/category_widget.dart';
