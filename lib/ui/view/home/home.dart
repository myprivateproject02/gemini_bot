import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_bot/bloc/bloc/chat_bloc.dart';
import 'package:gemini_bot/models/chat_message_model.dart';
import 'package:gemini_bot/ui/view/chat/chat.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;

              // return ChatWidget();
              return Scaffold(
                appBar: AppBar(
                  title: Text('Flutter + Generative AI'),
                  backgroundColor: Colors.amber[100],
                  actions: [
                    IconButton(
                        onPressed: () {
                          chatBloc.add(ClearHistoryEvent());
                        },
                        icon: Icon(Icons.cleaning_services))
                  ],
                ),
                body: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  bottom: 12, left: 16, right: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.amber.withOpacity(0.1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messages[index].role == "user"
                                        ? "User"
                                        : "Gemini",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: messages[index].role == "user"
                                            ? Colors.red
                                            : Colors.purple.shade200),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),

                                  MarkdownBody(
                                    selectable: true,
                                    data: messages[index].parts.first.text,
                                  ),

                                  // Text(
                                  //   messages[index].parts.first.text,
                                  //   style: TextStyle(height: 1.2),
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textEditingController,
                                style: const TextStyle(color: Colors.black),
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(22),
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      if (textEditingController
                                          .text.isNotEmpty) {
                                        String text =
                                            textEditingController.text;
                                        textEditingController.clear();
                                        chatBloc.add(
                                            ChatGenerateNewTextMessageEvent(
                                                inputMessage: text));
                                      }
                                    },
                                    icon: Icon(Icons.send),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
