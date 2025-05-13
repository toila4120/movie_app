// Data
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/utils/disable_glow_behavior.dart';
import 'package:movie_app/core/utils/show_toast.dart';
import 'package:movie_app/features/chatting/presentation/bloc/chat_bloc.dart';
import 'package:movie_app/features/chatting/presentation/widgets/chat_bubble.dart';
import 'package:movie_app/features/chatting/presentation/widgets/movie_recommendation_card.dart';

export 'data/datasources/gemini_ai_service.dart';
export 'data/datasources/movie_api_client.dart';
export 'data/models/movie_recommendation_model.dart';
export 'data/repositories/chat_repository_impl.dart';

// Domain
export 'domain/entities/chat_message.dart';
export 'domain/entities/movie_recommendation.dart';
export 'domain/repositories/chat_repository.dart';
export 'domain/usecases/get_chat_recommendations.dart';

// Presentation
export 'presentation/bloc/chat_bloc.dart';
export 'presentation/widgets/chat_bubble.dart';
export 'presentation/widgets/movie_recommendation_card.dart';

// DI
export 'di/chatting_di.dart';

part 'presentation/screen/chatting_screen.dart';
