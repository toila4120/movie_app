part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class ClearChatEvent extends ChatEvent {}

class ViewMovieDetailsEvent extends ChatEvent {
  final String slug;

  const ViewMovieDetailsEvent(this.slug);

  @override
  List<Object?> get props => [slug];
}
