import 'dart:math';

import 'package:chatbot/chatbot/Screens/chat/logic.dart';
import 'package:chatbot/chatbot/Screens/chat/view.dart';
import 'package:chatbot/chatbot/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Themes/fonts.dart';
import 'chat.dart';
import 'logic.dart';

class ChathistoryPage extends StatelessWidget {
  ChathistoryPage({Key? key}) : super(key: key);

  final ChathistoryLogic logic = Get.put(ChathistoryLogic());

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Center(child: SvgPicture.asset('assets/images/back.svg', height: 15,))),
        title: Text('Chat History', style: TextStyle(color: Color(0xFF000000), fontFamily: SFFonts.medium, fontWeight: FontWeight.w500, fontSize: 22),),
        actions: [
          GestureDetector(
            onTap: (){
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
                            logic.deleteAllChats();
                            logic.getChats();
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
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text('All Clear', style: TextStyle(color: AppColors.textSecondary, fontFamily: SFFonts.medium, fontWeight: FontWeight.w500, fontSize: 16),),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (logic.chats.isEmpty) {
            return Center(
              child: Image.asset('assets/images/chathistory.png'),
            );
          }

          logic.getChats();
          final grouped = logic.groupChatsByDate();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: grouped.entries.map((entry) {
              final date = entry.key;
              final chats = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      date,
                      style: TextStyle(
                        fontFamily: SFFonts.regular,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Colors.black.withOpacity(0.26),
                      ),
                    ),
                  ),

                  // Chat items for this date
                  ...chats.map((chat) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsetsGeometry.only(left: 16),
                      title: Text(
                        chat['title'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: SFFonts.regular,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      onTap: (){
                        Get.to(ChatPage(chatid: chat['id'], chatTitle: chat['title'],));
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              titleController.text = chat['title'] ?? '';

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Edit Chat Title'),
                                  content: TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter chat title',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Cancel', style: TextStyle(color: Colors.black),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if(titleController.text != '')
                                        {
                                          logic.updateChatTitle(chat['id']?? 0, titleController.text);
                                          Get.back();
                                        }
                                      },
                                      child: const Text('Edit', style: TextStyle(color: AppColors.textPrimary),),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: SvgPicture.asset(
                              'assets/images/edit.svg',
                            ),
                          ),
                          // SizedBox(width: (12 / 412) * Get.width),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: Text('Would you like to delete this chat completely?', style: TextStyle(color: Colors.black87),),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Cancel', style: TextStyle(color: Colors.black),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        logic.deleteChat(chat['id']);
                                        Get.back();
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.red),),
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
                  ))
                ],
              );
            }).toList(),
          );
        }),
      ),

      backgroundColor: AppColors.background,
    );

    void setTitle(String? prompt) {
      titleController.text = prompt ?? '';
    }
  }
}
