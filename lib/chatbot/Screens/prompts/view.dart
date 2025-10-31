import 'package:chatbot/chatbot/Custom%20Widgets/prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Themes/colors.dart';
import '../../Themes/fonts.dart';
import 'logic.dart';

class PromptsPage extends StatelessWidget {
  PromptsPage({Key? key}) : super(key: key);

  final PromptsLogic logic = Get.put(PromptsLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Center(child: SvgPicture.asset('assets/images/back.svg', height: 15)),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Prompts',
          style: TextStyle(
            color: Colors.black,
            fontFamily: SFFonts.medium,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(logic.prompts.length, (index) {
              final item = logic.prompts[index];
              return GestureDetector(
                onTap: (){
                  Get.to(Prompt(prompt: item,));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['icon']), // Load actual SVG here
                      SizedBox(width: (8 / 412) * Get.width),
                      Text(
                        item['category'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: SFFonts.medium
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
