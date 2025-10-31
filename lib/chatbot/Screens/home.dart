import 'package:chatbot/chatbot/Custom Widgets/action.dart' as action;
import 'package:chatbot/chatbot/Screens/chat/view.dart';
import 'package:chatbot/chatbot/Screens/chathistory/logic.dart';
import 'package:chatbot/chatbot/Screens/chathistory/view.dart';
import 'package:chatbot/chatbot/Screens/prompts/logic.dart';
import 'package:chatbot/chatbot/Screens/prompts/view.dart';
import 'package:chatbot/chatbot/Screens/setting/view.dart';
import 'package:chatbot/chatbot/Screens/tools/tools.dart';
import 'package:chatbot/chatbot/Screens/tools/writer/view.dart';
import 'package:chatbot/chatbot/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../Custom Widgets/prompt.dart';
import '../Custom Widgets/tool.dart';
import '../Themes/fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PromptsLogic prompts = Get.put(PromptsLogic());
  final ChathistoryLogic chats = Get.put(ChathistoryLogic());

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(SettingPage());
          },
          icon: SvgPicture.asset('assets/images/menu.svg',),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(ChatPage());
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: action.Action(path: 'assets/images/newchat.svg')
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome to AI Chatbot', style: TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: SFFonts.bold,
                          fontWeight: FontWeight.w700,
                          fontSize: 22),),
                      Text('How can I help you?', style: TextStyle(
                          color: Color(0xFF616472).withOpacity(0.50),
                          fontFamily: SFFonts.regular,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),),
                      SizedBox(height: (10 / 915) * Get.height),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('AI Tools',
                            style: TextStyle(color: Color(0xFF000000),
                                fontFamily: SFFonts.bold,
                                fontWeight: FontWeight.w700,
                                fontSize: 22),),
                          GestureDetector(
                              onTap: () {
                                Get.to(Tools());
                              },
                              child: Text('See All', style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: SFFonts.regular,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),)),
                        ],
                      ),
                      SizedBox(height: (10 / 915) * Get.height),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(ToolsPage(tool: 'Essay'));
                            },
                            child: Tool(path: 'assets/images/essay.svg',
                                title: 'Essay Writing',
                                content: 'Generate well-organized, insightful, essays on various topics.'),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.to(ToolsPage(tool: 'Letter'));
                              },
                              child: Tool(path: 'assets/images/letter.svg',
                                  title: 'Letter Writing',
                                  content: 'Easily create formal or personal letters with clear expression.')
                          ),
                        ],
                      ),
                      SizedBox(height: (10 / 915) * Get.height),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Prompts',
                            style: TextStyle(color: Color(0xFF000000),
                                fontFamily: SFFonts.medium,
                                fontWeight: FontWeight.w500,
                                fontSize: 22),),
                          GestureDetector(
                              onTap: () {
                                Get.to(PromptsPage());
                              },
                              child: Text('See All', style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: SFFonts.regular,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),)),
                        ],
                      ),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  height: (50 / 915) * Get.height,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(5, (index) {
                      final item = prompts.prompts[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IntrinsicWidth( // <--- Wrap with IntrinsicWidth
                          child: GestureDetector(
                            onTap: () {
                              Get.to(Prompt(prompt: item,));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(item['icon']),
                                  SizedBox(width: (8 / 412) * Get.width),
                                  Text(
                                    item['category'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, top: 16.0, right: 16.0, bottom: 0),
                child: Column(
                  children: [
                    SizedBox(height: (10 / 915) * Get.height),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text('History', style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontFamily: SFFonts.medium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22),),
                              Obx(() {
                                if (chats.chats.isNotEmpty) {
                                  return GestureDetector(
                                      onTap: () {
                                        Get.to(ChathistoryPage());
                                      },
                                      child: Text('See All', style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: SFFonts.regular,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),));
                                }
                                return SizedBox.shrink();
                              }),
                            ],
                          ),

                          /// 🧠 Chat History List
                          Obx(() {
                            if (chats.chats.isEmpty) {
                              return SizedBox(
                                height: (((320 / 915) * 100).truncateToDouble() / 100) * Get.height,
                                child: Center(
                                    child: Image.asset(
                                        'assets/images/chathistory.png'),
                                  ),
                              );
                            }

                            final grouped = chats.groupChatsByDate();

                            return SizedBox(
                              height: (((320 / 915) * 100).truncateToDouble() / 100) * Get.height,
                              // Adjust this height as needed
                              child: ListView(
                                children: grouped.entries.map((entry) {
                                  final date = entry.key;
                                  final dayChats = entry.value;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          date.split(' ')[0],
                                          style: TextStyle(
                                            fontFamily: SFFonts.regular,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: Colors.black.withOpacity(
                                                0.26),
                                          ),
                                        ),
                                      ),
                                      ...dayChats.map((chat) =>
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  8),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(ChatPage(
                                                  chatid: chat['id'],
                                                  chatTitle: chat['title'],));
                                              },

                                              child: ListTile(
                                                contentPadding: EdgeInsets.only(left: 16),
                                                title: Text(
                                                  chat['title'],
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: SFFonts.regular,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        titleController.text =
                                                            chat['title'] ?? '';

                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    'Edit Chat Title'),
                                                                content: TextField(
                                                                  controller: titleController,
                                                                  decoration: InputDecoration(
                                                                    hintText: 'Enter chat title',
                                                                    labelStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Get
                                                                          .back();
                                                                    },
                                                                    child: const Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      if (titleController
                                                                          .text !=
                                                                          '') {
                                                                        chats
                                                                            .updateChatTitle(
                                                                            chat['id'] ??
                                                                                0,
                                                                            titleController
                                                                                .text);
                                                                        Get
                                                                            .back();
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                      'Edit',
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .textPrimary),),
                                                                  ),
                                                                ],
                                                              ),
                                                        );
                                                      },
                                                      icon: SvgPicture.asset(
                                                        'assets/images/edit.svg',
                                                      ),
                                                    ),
                                                    // SizedBox(width: (12 / 412) *
                                                    //    Get.width),
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      /*style: IconButton.styleFrom(
                                                        backgroundColor: Colors.blue
                                                      ),*/
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    'Confirm Delete'),
                                                                content: Text(
                                                                  'Would you like to delete this chat completely?',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87),),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Get
                                                                          .back();
                                                                    },
                                                                    child: const Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      chats
                                                                          .deleteChat(
                                                                          chat['id']);
                                                                      Get
                                                                          .back();
                                                                    },
                                                                    child: const Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red),),
                                                                  ),
                                                                ],
                                                              ),
                                                        );
                                                      },
                                                      icon: SvgPicture.asset(
                                                        'assets/images/delete.svg',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}
