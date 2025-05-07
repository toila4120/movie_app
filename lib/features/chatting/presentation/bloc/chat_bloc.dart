import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/chatting/domain/entities/chat_message.dart';
import 'package:movie_app/features/chatting/domain/entities/movie_recommendation.dart';
import 'package:movie_app/features/chatting/domain/usecases/get_chat_recommendations.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatRecommendations getChatRecommendationsUseCase;

  ChatBloc({
    required this.getChatRecommendationsUseCase,
  }) : super(const ChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
    on<ViewMovieDetailsEvent>(_onViewMovieDetails);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      // Add user message
      final userMessage = ChatMessage(
        message: event.message,
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      );

      final updatedMessages = [...state.messages, userMessage];
      emit(state.copyWith(
        messages: updatedMessages,
        isLoading: true,
        error: null,
      ));

      // Add loading bot message
      final loadingMessage = ChatMessage(
        message: 'Đang tìm kiếm phim phù hợp...',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        isLoading: true,
      );

      emit(state.copyWith(
        messages: [...updatedMessages, loadingMessage],
      ));

      // Get response from AI
      final result = await getChatRecommendationsUseCase.execute(event.message);

      result.fold(
        (error) {
          // Show error message
          final errorMessage = ChatMessage(
            message: error,
            sender: MessageSender.ai,
            timestamp: DateTime.now(),
            isError: true,
          );

          final messagesWithoutLoading =
              state.messages.where((message) => !message.isLoading).toList();

          emit(state.copyWith(
            messages: [...messagesWithoutLoading, errorMessage],
            isLoading: false,
            error: error,
          ));
        },
        (response) {
          // Show AI response
          final aiMessage = ChatMessage(
            message: response.aiMessage,
            sender: MessageSender.ai,
            timestamp: DateTime.now(),
          );

          final messagesWithoutLoading =
              state.messages.where((message) => !message.isLoading).toList();

          emit(state.copyWith(
            messages: [...messagesWithoutLoading, aiMessage],
            recommendations: response.movies,
            isLoading: false,
          ));
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      final errorMessage = ChatMessage(
        message: "Đã xảy ra lỗi: ${e.toString()}",
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        isError: true,
      );

      final messagesWithoutLoading =
          state.messages.where((message) => !message.isLoading).toList();

      emit(state.copyWith(
        messages: [...messagesWithoutLoading, errorMessage],
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<ChatState> emit) {
    emit(const ChatState());
  }

  void _onViewMovieDetails(
      ViewMovieDetailsEvent event, Emitter<ChatState> emit) {
    // Navigate to movie details - this will be handled by the UI layer
  }
}
