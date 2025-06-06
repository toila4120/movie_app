import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/utils/disable_glow_behavior.dart';
import 'package:movie_app/core/widget/src/base_scroll_view.dart';
import 'package:movie_app/core/widget/src/expandable_text.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/features/download/download.dart';
import 'package:movie_app/features/mini_player/presentation/bloc/mini_player_bloc.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_bloc.dart';
import 'package:movie_app/features/movie/presentation/widget/item_container.dart';
import 'package:movie_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pod_player/pod_player.dart';
import 'package:shimmer/shimmer.dart';

part 'presentation/screen/movie_detail.dart';
part 'presentation/widget/header_movie_detail.dart';
part 'presentation/widget/movie.dart';
