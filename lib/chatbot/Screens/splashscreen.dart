import 'dart:async';

import 'package:chatbot/chatbot/Themes/colors.dart';
import 'package:chatbot/chatbot/Themes/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), (){
      Get.off(() => Home());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset('assets/images/background.png'),
          Text('Chatbot', style: TextStyle(color: AppColors.textPrimary, fontFamily: SFFonts.bold, fontWeight: FontWeight.w700, fontSize: 60),)
        ],
      ),
    );
  }
}

