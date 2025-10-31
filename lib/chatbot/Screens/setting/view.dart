import 'package:chatbot/chatbot/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Themes/fonts.dart';
import 'logic.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  final SettingLogic logic = Get.put(SettingLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Center(child: SvgPicture.asset('assets/images/back.svg', height: 15,))),
        title: Text('Settings', style: TextStyle(color: Color(0xFF000000), fontFamily: SFFonts.medium, fontWeight: FontWeight.w500, fontSize: 22),),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10,),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: logic.settings.length,
                itemBuilder: (context, index) {
                  final item = logic.settings[index];
                  return ListTile(
                      leading: SvgPicture.asset(item['icon']),
                      title: Text(item['title'], style: TextStyle(
                        color: Colors.black,
                        fontFamily: SFFonts.regular,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      )
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              ),
            ),
          )
      ),
      backgroundColor: AppColors.background,
    );
  }
}
