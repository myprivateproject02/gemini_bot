import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_bot/bloc/bloc/chat_bloc.dart';
import 'package:gemini_bot/models/chat_message_model.dart';
import 'package:gemini_bot/ui/view/chat/chat.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  // final ScrollController _scrollController1 = ScrollController();
  final _scrollController = ItemScrollController();

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
              return Scaffold(
                // backgroundColor: Colors.amberAccent.shade100,
                appBar: AppBar(
                  title: Text('Flutter + Generative AI'),
                  // backgroundColor: Colors.amberAccent.shade100,
                  actions: [
                    IconButton(
                      onPressed: () {
                        chatBloc.add(ClearHistoryEvent());
                      },
                      icon: Icon(Icons.cleaning_services),
                      enableFeedback: true,
                    )
                  ],
                ),
                body: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Expanded(
                        // child: ListView.builder(
                        //   itemCount: messages.length,
                        //   controller: _scrollController1,
                        //   itemBuilder: (context, index) {
                        //     return Container(
                        //       margin: const EdgeInsets.only(
                        //           bottom: 12, left: 16, right: 16),
                        //       padding: const EdgeInsets.all(16),
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(16),
                        //           color: Colors.deepPurple.withOpacity(0.1)),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             messages[index].role == "user"
                        //                 ? "Me"
                        //                 : "Gemini",
                        //             style: TextStyle(
                        //                 fontSize: 14,
                        //                 color: messages[index].role == "user"
                        //                     ? Colors.deepPurple
                        //                     : Colors.pink),
                        //           ),
                        //           const SizedBox(
                        //             height: 12,
                        //           ),
                        //           MarkdownBody(
                        //             selectable: true,
                        //             data: messages[index].parts.first.text,
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // ),
                        child: ScrollablePositionedList.builder(
                          itemCount: messages.length,
                          itemScrollController: _scrollController,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  bottom: 12, left: 16, right: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.deepPurple.withOpacity(0.1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messages[index].role == "user"
                                        ? "Me"
                                        : "Gemini",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: messages[index].role == "user"
                                            ? Colors.deepPurple
                                            : Colors.pink),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  MarkdownBody(
                                    selectable: true,
                                    data: messages[index].parts.first.text,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (textEditingController.text.isNotEmpty) {
                                  String text = textEditingController.text;
                                  textEditingController.clear();
                                  chatBloc.add(
                                    ChatGenerateNewTextMessageEvent(
                                        scrollController: _scrollController,
                                        inputMessage: text),
                                  );
                                }
                              },
                              icon: chatBloc.generating
                                  ? const CircularProgressIndicator()
                                  : Icon(chatBloc.getSendIcon),
                            ),
                          ),
                        ),
                      ),
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
