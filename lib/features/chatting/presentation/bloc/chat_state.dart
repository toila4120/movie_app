part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final List<MovieRecommendation> recommendations;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.recommendations = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    List<MovieRecommendation>? recommendations,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, recommendations, isLoading, error];
}
