import 'package:chatbot/chatbot/Custom%20Widgets/tool.dart';
import 'package:chatbot/chatbot/Screens/tools/grammar/view.dart';
import 'package:chatbot/chatbot/Screens/tools/writer/view.dart';
import 'package:chatbot/chatbot/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Tools extends StatelessWidget {
  Tools({super.key});

  List<dynamic> tools = [
    {
      'title': 'Essay Writing',
      'content': 'Generate well-organized, insightful essays on various topics.',
      'image': 'essay.svg'
    },
    {
      'title': 'Letter Writing',
      'content': 'Easily create formal or personal letters with clear expression.',
      'image': 'letter.svg'
    },
    {
      'title': 'Grammar',
      'content': 'Smarter Writing Starts with Better Grammar.',
      'image': 'grammar.svg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Center(child: SvgPicture.asset('assets/images/back.svg',)),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  final tool = tools[index];
                  final path = 'assets/images/${tool['image']}';

                  return GestureDetector(
                    onTap: () {
                      if (index <= 1) {
                        Get.to(ToolsPage(tool: tool['title'].toString().split(' ')[0]));
                      }
                      else
                        Get.to(GrammarPage());
                    },
                    child: Tool(path: path, title: tool['title'], content: tool['content'])
                  );
                },
            ),
          )
      ),
      backgroundColor: AppColors.background,
    );
  }
}
