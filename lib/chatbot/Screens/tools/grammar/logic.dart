import 'package:chatbot/chatbot/Services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../chat/message.dart';

class GrammarLogic extends GetxController {
  TextEditingController checker = TextEditingController();
  late TextEditingController enhancer = checker;

  var checkerLength = 0.obs;
  var enhancerLength = 0.obs;

  var checkerText = ''.obs;
  var enhancerText = ''.obs;

  final api = API();

  var isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    checker.addListener(() {
      checkerLength.value = checker.text.length;
    });
    enhancer.addListener(() {
      enhancerLength.value = enhancer.text.length;
    });
  }

  Set<String> copiedKeys = <String>{}.obs;

  void copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    copiedKeys.add(text);

    Future.delayed(const Duration(seconds: 2), () {
      copiedKeys.remove(text);
    });

    Get.snackbar('Copied', 'Text copied to clipboard');
  }

  Future<void> getResponse(String tool, String userPrompt) async {

    if (userPrompt.trim().isEmpty) return;

    if (tool == 'Checker') {
      checkerText.value = '';
    }
    else if (tool == 'Enhancer'){
      enhancerText.value = '';
    }

    final userMessage = Message(
      chatId: -1,
      message: userPrompt,
      role: false,
    );

    isTyping.value = true;
    update();

    // ✅ Add your invisible "system prompt"
    final systemPrompt = Message(
      chatId: -1,
      message: (tool == 'Checker') ? '''
        You are a professional grammar checker. Given any text, your job is to identify and correct grammatical errors strictly. You must preserve the original meaning, tone, and formatting of the text while improving grammar, punctuation, sentence structure, and clarity. 
        Only return the corrected version of the input text — do not explain changes or add commentary.
        If the input is already grammatically correct, return it unchanged.
      ''' :
      '''
        You are a professional grammar and writing enhancer. Your job is to improve any input text by correcting grammar, punctuation, sentence structure, and word choice while preserving the original meaning, tone, and formatting.
        Make the writing sound more fluent and polished, as if written by a skilled native speaker. Do not add, remove, or change the meaning of any content.
        Only return the enhanced version of the input text — do not explain changes or include any commentary.
        If the input is already well-written, return it unchanged.
      ''',
      role: false,
    );

    final apiMessages = [systemPrompt, userMessage];

    final response = await api.getResponse(userPrompt, apiMessages);

    if (tool == 'Checker') {
      checkerText.value = response.toString();
    }
    else if (tool == 'Enhancer'){
      enhancerText.value = response.toString();
    }

    isTyping.value = false;
    update();
  }
}
