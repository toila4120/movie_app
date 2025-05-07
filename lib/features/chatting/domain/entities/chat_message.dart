import 'package:equatable/equatable.dart';

enum MessageSender {
  user,
  ai,
}

class ChatMessage extends Equatable {
  final String message;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isLoading;
  final bool isError;

  const ChatMessage({
    required this.message,
    required this.sender,
    required this.timestamp,
    this.isLoading = false,
    this.isError = false,
  });

  ChatMessage copyWith({
    String? message,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isLoading,
    bool? isError,
  }) {
    return ChatMessage(
      message: message ?? this.message,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [message, sender, timestamp, isLoading, isError];
}
