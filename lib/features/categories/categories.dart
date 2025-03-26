import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/size_config.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_event.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_state.dart';

part 'presentation/screen/categories_screen.dart';
part 'presentation/widget/categories_list.dart';
