import 'package:chatbot/chatbot/Screens/chat/view.dart';
import 'package:chatbot/chatbot/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Themes/fonts.dart';

class Prompt extends StatelessWidget {
  Map<String, dynamic> prompt;

  Prompt({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Center(child: SvgPicture.asset('assets/images/back.svg', height: 15,))),
        title: Text(prompt['category'], style: TextStyle(color: Color(0xFF000000), fontFamily: SFFonts.medium, fontWeight: FontWeight.w500, fontSize: 22),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: List.generate(prompt['prompts'].length, (index) {
            final item = prompt['prompts'][index];
            return GestureDetector(
              onTap: (){
                Get.off(ChatPage(prompt: item,));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                  Text(
                      item,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: SFFonts.regular
                      ),
                  ),
              ),
            );
          }),
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}
