part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {}

final class ChatError extends ChatState {}

final class ChatSuccessState extends ChatState {
  final List<ChatMessageModel> messages;
  ChatSuccessState({required this.messages});
}
