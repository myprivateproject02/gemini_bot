import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gemini_bot/models/chat_message_model.dart';
import 'package:gemini_bot/repo/chat_repo.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // List<ChatMessageModel> messages = [];
  ChatBloc() : super(ChatSuccessState(messages: const [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);

    on<ClearHistoryEvent>(clearHistoryEvent);

  }

  List<ChatMessageModel> messages = [];
  bool generating = false;

  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(ChatMessageModel(
        role: "user", parts: [ChatPartModel(text: event.inputMessage)]));
    emit(ChatSuccessState(messages: messages));
    generating = true;
    String generatedText = await ChatRepo.chatTextGenerationRepo(messages);
    if (generatedText.length > 0) {
      messages.add(ChatMessageModel(
          role: 'model', parts: [ChatPartModel(text: generatedText)]));
      emit(ChatSuccessState(messages: messages));
    }
    generating = false;
  }

  FutureOr<void> clearHistoryEvent(ClearHistoryEvent event, Emitter<ChatState> emit) {
    messages.clear();
    emit(ChatSuccessState(messages: messages));
  }
}
