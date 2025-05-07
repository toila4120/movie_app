import 'package:flutter/foundation.dart';
import 'package:movie_app/core/constants/api_keys.dart';
import 'package:movie_app/features/chatting/data/datasources/gemini_ai_service.dart';
import 'package:movie_app/features/chatting/data/datasources/movie_api_client.dart';
import 'package:movie_app/features/chatting/data/repositories/chat_repository_impl.dart';
import 'package:movie_app/features/chatting/domain/repositories/chat_repository.dart';
import 'package:movie_app/features/chatting/domain/usecases/get_chat_recommendations.dart';
import 'package:movie_app/features/chatting/presentation/bloc/chat_bloc.dart';
import 'package:movie_app/injection_container.dart';

void setupChattingDi() {
  // BLoC
  getIt.registerFactory(
    () => ChatBloc(
      getChatRecommendationsUseCase: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetChatRecommendations(getIt()));

  // Repository
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      geminiAiService: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton(
    () => GeminiAiService(
      apiKey: (kDebugMode &&
              (ApiKeys.geminiApiKey == 'API_KEY_NOT_FOUND' ||
                  ApiKeys.geminiApiKey.isEmpty))
          ? 'test_key'
          : ApiKeys.geminiApiKey,
      movieApiClient: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => MovieApiClient(getIt()));
}
