import 'dart:async';
import 'dart:io';

import 'package:chatbot/chatbot/Database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';

import '../../Services/api.dart';
import 'message.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';


class ChatLogic extends GetxController {
  RxList<Message> messages = <Message>[].obs;
  final TextEditingController controller = TextEditingController();

  final API api = API();
  final ChatbotDatabase database = ChatbotDatabase.instance;

  var isTyping = false.obs;
  RxInt regeneratingPromptId = (-1).obs;
  RxInt typingPromptId = (-1).obs;

  var hasInitialScrollDone = true.obs;

  Set<String> copiedKeys = <String>{}.obs;

  void startNewChat() {
    messages.clear();
    controller.clear();
    isTyping.value = false;
  }

  void setPrompt(String? prompt) {
    controller.text = prompt ?? '';
  }

  Future<void> getMessages(int chatid) async {
    final messageList = await database.readAllMessages(chatid);
    // print("📥 Loaded chats: ${messageList.map((e) => e.toMap())}");
    messages.clear();
    messages.assignAll(messageList);
    update();
  }

  void copyText(String text, String key) async {
    if (copiedKeys.isNotEmpty) return;

    await Clipboard.setData(ClipboardData(text: text));
    copiedKeys.add(key);

    Future.delayed(const Duration(seconds: 3), () {
      copiedKeys.remove(key);
    });

    Get.snackbar('Copied', 'Text copied to clipboard');
  }

  Future<void> stopGenerating() async {
    await api.stopGenerating();
  }

  Map<int, int> selectedResponseIndex = {}; // promptId → selected response index

  List<Map<String, dynamic>> get groupedMessages {
    final List<Map<String, dynamic>> grouped = [];

    for (var msg in messages) {
      if (!msg.role) {
        final responses = messages
            .where((m) => m.role && m.chatId == msg.id)
            .toList();

        grouped.add({
          'prompt': msg,
          'response': responses,
        });
      }
    }

    return grouped;
  }

  void switchResponse(int promptId, bool next) {
    final currentIndex = selectedResponseIndex[promptId] ?? 0;
    final responses = messages.where((m) => m.role && m.chatId == promptId).toList();

    if (responses.isEmpty) return;

    final newIndex = next
        ? (currentIndex < responses.length - 1 ? currentIndex + 1 : currentIndex)
        : (currentIndex > 0 ? currentIndex - 1 : currentIndex);

    selectedResponseIndex[promptId] = newIndex;
    update(); // Update UI
  }

  // Future<void> regenerate(int index) async {
  //   final userPrompt = messages[index];
  //   if (userPrompt.message.trim().isEmpty) return;
  //
  //   regeneratingIndex.value = index + 1; // the response index regenerating
  //   isTyping.value = true;
  //   update();
  //
  //   final response = await api.getResponse(userPrompt.message, messages.toList());
  //   isTyping.value = false;
  //   update();
  //
  //   messages[index + 1].message = response ?? 'Failed to get response.';
  //
  //   if (response != null && !response.startsWith('Error')) {
  //     //await database.updateMessage(userPrompt.id! + 1, response);
  //   }
  //
  //   regeneratingIndex.value = -1; // done regenerating
  //   update();
  // }

  Future<void> regenerateResponse(int promptId) async {
    try {
      // Step 1: Find the prompt
      final promptMessage = messages.firstWhere(
            (msg) => msg.id == promptId && !msg.role,
        orElse: () => throw Exception('Prompt not found for regeneration.'),
      );

      // Step 2: Update UI to show loader
      regeneratingPromptId.value = promptId;
      isTyping.value = true;
      update();

      // Step 3: Get new response from API
      final regeneratedText = await api.getResponse(promptMessage.message, messages.toList());
      final isValidResponse = regeneratedText != null && !regeneratedText.startsWith('Error generating response: ');

      // Step 4: Stop loader state
      isTyping.value = false;
      regeneratingPromptId.value = -1;

      if (regeneratedText == null || regeneratedText.trim().isEmpty) {
        throw Exception('Failed to regenerate response.');
      }

      // Step 5: Insert response into DB
      var responseId;
      if (isValidResponse)
        responseId = await database.insertResponse(promptId, regeneratedText);

      // Step 6: Add new response locally
      messages.add(Message(
        id: responseId?? -1,
        chatId: promptId,
        message: regeneratedText,
        role: true,
      ));

      // Step 7: Refresh full message list
      if (isValidResponse)
        await getMessages(promptMessage.chatId);

      // Reset UI
      update();
    } catch (e) {
      isTyping.value = false;
      regeneratingPromptId.value = -1;
      update();
      Get.snackbar("Error", "Could not regenerate: ${e.toString()}");
    }
  }

  // Future<int> getResponse(int? chatID, String userPrompt) async {
  //   if (userPrompt.trim().isEmpty) return -1;
  //
  //   final userMessage = Message(
  //     chatId: chatID ?? -1,
  //     message: userPrompt,
  //     role: false,
  //   );
  //   messages.add(userMessage);
  //
  //   controller.clear();
  //   isTyping.value = true;
  //   update();
  //
  //   final response = await api.getResponse(userPrompt, messages.toList());
  //   final isValidResponse = response != null && !response.startsWith('Error generating response: ');
  //
  //   isTyping.value = false;
  //   update();
  //
  //   var newChatId = chatID;
  //   if (chatID == null && isValidResponse) {
  //     newChatId = await database.insertNewChat(userPrompt.split(' ').take(10).join(' '));
  //   }
  //
  //   if (newChatId != null) {
  //     for (var msg in messages) {
  //       if (msg.chatId == -1) msg.chatId = newChatId;
  //     }
  //   }
  //
  //   messages.add(Message(
  //     chatId: newChatId ?? -1,
  //     message: response ?? 'Failed to get response.',
  //     role: true,
  //   ));
  //
  //   if (isValidResponse) {
  //     await database.insertPromptAndResponse(newChatId!, userPrompt, response!);
  //   }
  //
  //   update();
  //   return newChatId ?? -1;
  // }

  Future<int> getResponse(int? chatID, String userPrompt) async {
    if (userPrompt.trim().isEmpty) return -1;

    // Step 0: Add prompt message locally with temporary chatId (-1 if null)
    final tempChatId = chatID ?? -1;
    final tempPromptId = -DateTime.now().millisecondsSinceEpoch; // unique temp ID
    final userMessage = Message(
      id: tempPromptId,
      chatId: tempChatId,
      message: userPrompt,
      role: false,
    );
    messages.add(userMessage);
    update();

    controller.clear();
    isTyping.value = true;
    typingPromptId.value = tempPromptId;
    update();

    // Step 1: Call API
    final response = await api.getResponse(userPrompt, messages.toList());
    final isValidResponse = response != null &&
        !response.startsWith('Error generating response: ') &&
        response.trim().isNotEmpty;

    isTyping.value = false;
    typingPromptId.value = -1;
    update();

    int? newChatId = chatID;

    if (isValidResponse) {
      // Step 2: Create new chat if needed
      if (chatID == null) {
        newChatId = await database.insertNewChat(userPrompt.split(' ').take(10).join(' '));
      }

      // Step 3: Insert prompt & response to DB
      final promptId = await database.insertPrompt(newChatId!, userPrompt);
      await database.insertResponse(promptId, response!);

      // Step 4: Reload messages from DB to sync state
      await getMessages(newChatId);
      update();

    } else {
      // If failed response: show response inline but don't persist to DB
      messages.add(Message(
        id: -1,
        chatId: tempPromptId,
        message: response ?? 'Failed to get response.',
        role: true,
      ));
      update();
    }

    return newChatId ?? -1;
  }

  Future<void> exportChatAsPdf(String chatTitle) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text(chatTitle, style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            ...messages.map((msg) {
              final isUser = msg.role == false; // Adjust based on your model
              return pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      isUser ? "User:" : "Assistant:",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: isUser ? PdfColors.blue : PdfColors.green,
                      ),
                    ),
                    pw.Text(msg.message ?? '', style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ];
        },
      ),
    );

    final timestamp = DateTime.timestamp().microsecondsSinceEpoch;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$chatTitle$timestamp.pdf');
    await file.writeAsBytes(await pdf.save());

    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final savedPath = await FlutterFileDialog.saveFile(params: params);

    if (savedPath != null) {
      // ✅ Notify user
      Get.snackbar(
        "Exported",
        "Chat saved to: ${savedPath}",
      );
    } else {
      Get.snackbar('Unsuccessful', 'Export was unsuccessful');
    }
  }
}
