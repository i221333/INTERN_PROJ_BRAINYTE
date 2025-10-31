import 'package:chatbot/chatbot/Custom Widgets/action.dart' as action;
import 'package:chatbot/chatbot/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Custom Widgets/animation.dart';
import '../../Themes/fonts.dart';
import '../chathistory/logic.dart';
import 'logic.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  String? prompt;
  int? chatid;
  String? chatTitle;

  ChatPage({super.key, this.prompt, this.chatid, this.chatTitle});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatLogic logic;

  final ChathistoryLogic chats = Get.put(ChathistoryLogic());

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    logic = Get.put(ChatLogic()); // use the one from the binding
    logic.getMessages(widget.chatid ?? 0);
    if (widget.prompt != null && logic.controller.text.isEmpty) {
      logic.setPrompt(widget.prompt);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.prompt != null && logic.controller.text.isEmpty) {
      logic.setPrompt(widget.prompt);
    }

    return WillPopScope(
      onWillPop: () {
        chats.getChats();
        return Future.value(!logic.isTyping.value);
      },
      child: Scaffold(
          backgroundColor: AppColors.background,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                if (!logic.isTyping.value) {
                  logic.messages.clear();
                  chats.getChats();
                  Get.back();
                }
              },
              icon: Center(child: SvgPicture.asset(
                'assets/images/back.svg', height: 15,))
          ),
          title: (widget.chatTitle != null &&
              widget.chatTitle!.trim().isNotEmpty)
              ? Text(
            widget.chatTitle!,
            style: const TextStyle(
              color: Color(0xFF000000),
              fontFamily: SFFonts.medium,
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
          )
              : Obx(() {
            return Text(
              (logic.messages.isNotEmpty)
                  ? logic.messages[0].message.split(' ').take(10).join(' ')
                  : 'Untitled Chat',
              style: const TextStyle(
                color: Color(0xFF000000),
                fontFamily: SFFonts.medium,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            );
          }),
          actions: [
            Obx(() {
              if (logic.messages.isNotEmpty) {
                return Row(
                  children: [
                    // Export button
                    GestureDetector(
                      onTap: () async {
                        if (!logic.isTyping.value) {
                          await logic.exportChatAsPdf(widget.chatTitle ?? "Untitled Chat");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: action.Action(
                          path: 'assets/images/export.svg',
                          opacity: 0.08,
                        ),
                      ),
                    ),

                    // New chat button
                    GestureDetector(
                      onTap: () {
                        Get.off(
                              () => Builder(builder: (_) => ChatPage()),
                          binding: BindingsBuilder(() {
                            Get.put(ChatLogic());
                          }),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: action.Action(
                          path: 'assets/images/newchat.svg',
                        ),
                      ),
                    ),
                  ],
                );
              }

              return SizedBox.shrink();
            })
          ],
        ),
        body: GetBuilder<ChatLogic>(builder: (logics) {
          return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (logic.messages.isEmpty) {
                        return Center(
                            child: Image.asset('assets/images/startchat.png', scale: 3,));
                      }

                      final grouped = logics.groupedMessages;

                      return ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          left: 16,
                          top: 16,
                          right: 16,
                          // bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        itemCount: grouped.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: (30 / 915) * Get.height),
                        itemBuilder: (context, index) {
                          if (
                          (logics.hasInitialScrollDone.value) || // initial load
                              (logics.isTyping.value &&
                                  logics.regeneratingPromptId.value == -1)
                          ) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                              }

                              if (logics.hasInitialScrollDone.value) {
                                logics.hasInitialScrollDone.value = false;
                              }
                            });
                          }

                          final msg = logic.messages[index];

                          final item = grouped[index];
                          final Message prompt = item['prompt'];
                          final List<Message> responses = item['response'];

                          final promptId = prompt.id!;
                          final selectedIndex = logic
                              .selectedResponseIndex[promptId] ?? 0;
                          final hasResponses = responses.isNotEmpty;
                          final Message? selectedResponse = hasResponses
                              ? responses[selectedIndex]
                              : null;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Prompt + Icon
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      action.Action(
                                        path: 'assets/images/user.svg',
                                        height: 50,
                                        width: 50,
                                        backgroundColor: Colors.white,),
                                      SizedBox(width: (16 / 412) * Get.width),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              prompt.message ?? '',
                                              style: const TextStyle(
                                                fontFamily: SFFonts.regular,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: (12 / 915) *
                                                Get.height),
                                            Obx(() {
                                              return GestureDetector(
                                                  onTap: () {
                                                    print("selectedResponse.id! ${selectedResponse?.id!}");
                                                    print("prompt id.id! ${promptId}");

                                                      if (!logic.copiedKeys.contains('prompt_$promptId'))
                                                        logic.copyText(prompt.message, 'prompt_$promptId');
                                                  },
                                                  child: SvgPicture.asset(
                                                    logic.copiedKeys.contains(
                                                        'prompt_$promptId')
                                                        ? 'assets/images/copied.svg'
                                                        : 'assets/images/copy.svg',)
                                              );
                                            })
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: (10 / 915) * Get.height),
                                  Divider(
                                      color: Colors.black.withOpacity(0.20)),
                                  SizedBox(height: (10 / 915) * Get.height),
                                ],
                              ),

                              /*// Response
                              if (logics.regeneratingIndex.value == index)
                                IntrinsicWidth(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)),
                                      color: Colors.blue,
                                    ),
                                    child: SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                )
                              else if (logics.isTyping.value && index == logics.messages.length - 1 && logics.regeneratingIndex.value == -1)
                                IntrinsicWidth(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                      color: Colors.blue,
                                    ),
                                    child: SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),

                              if (!isUser)
                                (msg.message != 'Failed to get response.' && logics.regeneratingIndex.value != index && logic.messages[index - 1].chatId != msg.chatId)
                                    ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    action.Action(
                                      path: '',
                                      height: 50,
                                      width: 50,
                                      backgroundColor: Colors.white,
                                    ),
                                    SizedBox(width: (16 / 412) * Get.width),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            selectedResponse!.message,
                                            style: const TextStyle(
                                              fontFamily: SFFonts.regular,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                              height: (12 / 915) * Get.height),
                                          if (!logic.isTyping.value)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Obx(() {
                                                  return GestureDetector(
                                                    onTap: () =>
                                                        logic.copyText(
                                                            msg.message, index),
                                                    child: SvgPicture.asset(
                                                      logic.copiedKeys.contains(
                                                          index)
                                                          ? 'assets/images/copied.svg'
                                                          : 'assets/images/copy.svg',
                                                    ),
                                                  );
                                                }),
                                                IconButton(
                                                  icon: Icon(Icons.arrow_back_ios_new),
                                                  onPressed: selectedIndex > 0
                                                      ? () => logic.switchResponse(promptId, false)
                                                      : null,
                                                ),
                                                Text(
                                                  '${selectedIndex + 1} / ${responses.length}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.arrow_forward_ios),
                                                  onPressed: selectedIndex < responses.length - 1
                                                      ? () => logic.switchResponse(promptId, true)
                                                      : null,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await logic.regenerateResponse(logic.messages.indexWhere((m) => m.id == selectedResponse.id));
                                                  },
                                                  child: SvgPicture.asset(
                                                      'assets/images/regenerate.svg'),
                                                ),
                                              ],
                                            ),
                                          SizedBox(
                                              height: (30 / 915) * Get.height),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                    : const SizedBox.shrink()*/
                              // 🌀 LOADER for typing or regenerating
                              if ((logics.regeneratingPromptId.value ==
                                  promptId ||
                                  logics.typingPromptId.value == promptId))
                                IntrinsicWidth(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue,
                                    ),
                                    child: const SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                )

                              // ✅ Response Bubble (Only if selected response exists and it's not failed)
                              else
                                if (selectedResponse != null &&
                                    selectedResponse.message !=
                                        'Failed to get response.')
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      action.Action(
                                        path: '',
                                        height: 50,
                                        width: 50,
                                        backgroundColor: Colors.white,
                                      ),
                                      SizedBox(width: (16 / 412) * Get.width),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              selectedResponse.message,
                                              style: const TextStyle(
                                                fontFamily: SFFonts.regular,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: (12 / 915) *
                                                Get.height),

                                            // ⬇️ Action Row
                                            Obx(() {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      print("selectedResponse.id! ${selectedResponse.id!}");
                                                      print("prompt id.id! ${promptId}");
                                                      if (!logic.copiedKeys.contains('response_$selectedResponse.id!'))
                                                        logic.copyText(selectedResponse.message, 'response_$selectedResponse.id!');
                                                    },
                                                    child: SvgPicture.asset(
                                                      logic.copiedKeys.contains(
                                                          'response_$selectedResponse.id!'
                                                      )
                                                          ? 'assets/images/copied.svg'
                                                          : 'assets/images/copy.svg',
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons
                                                        .arrow_back_ios_new),
                                                    onPressed: selectedIndex > 0
                                                        ? () =>
                                                        logic.switchResponse(
                                                            promptId, false)
                                                        : null,
                                                  ),
                                                  Text(
                                                    '${selectedIndex +
                                                        1} / ${responses
                                                        .length}',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[600],
                                                      fontWeight: FontWeight
                                                          .w500,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons
                                                        .arrow_forward_ios),
                                                    onPressed: selectedIndex <
                                                        responses.length - 1
                                                        ? () =>
                                                        logic.switchResponse(
                                                            promptId, true)
                                                        : null,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (logic.regeneratingPromptId.value == -1)
                                                      {
                                                        logic
                                                            .regeneratingPromptId
                                                            .value = promptId;
                                                        await logic
                                                            .regenerateResponse(
                                                            promptId);
                                                        logic
                                                            .regeneratingPromptId
                                                            .value = -1;
                                                      }
                                                    },
                                                    child: SvgPicture.asset(
                                                        'assets/images/regenerate.svg'),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  const SizedBox.shrink()
                            ],
                          );
                        },
                      );
                    }),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Obx(() {
                            return TextField(
                              onTap: () async{
                               await Future.delayed(const Duration(milliseconds: 500),);
                                await _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                              },
                              enabled: !logics.isTyping.value,
                              minLines: 1,
                              maxLines: 3,
                              controller: logic.controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Ask anything to AI',
                                hintStyle: TextStyle(
                                  color: Color(0xFF616472).withOpacity(0.40),
                                  fontFamily: SFFonts.medium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  borderSide: BorderSide
                                      .none, // removes visible border lines
                                ),
                              ),
                              style: TextStyle(color: Colors.black87),
                              onTapOutside: (PointerDownEvent event) {
                                FocusScope.of(context).unfocus();
                              },
                            );
                          }),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!logic.isTyping.value) {
                            final prompt = logic.controller.text;
                            final newChatId = await logic.getResponse(
                                widget.chatid, prompt);
                            widget.chatid =
                                newChatId; // Update your local state with the correct chat id
                            print(widget.chatid);
                          } else {
                            logic.stopGenerating();
                          }
                        },
                        child: Obx(() {
                          return Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: action.Action(
                                path: (logic.isTyping.value)
                                    ? 'assets/images/loading.svg'
                                    : 'assets/images/send.svg',
                                height: 50,
                                width: 50,)
                          );
                        }),
                      ),
                    ],
                  ),

                ],
              )
          );
        })
      ),
    );
  }
}
