// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class ChatGenerateNewTextMessageEvent extends ChatEvent {
  final String inputMessage;
  final ItemScrollController scrollController;

  ChatGenerateNewTextMessageEvent(
      {required this.inputMessage, required this.scrollController});
}

class ClearHistoryEvent extends ChatEvent {}
