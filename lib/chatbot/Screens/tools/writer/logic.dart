import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../Database/database.dart';
import '../../../Services/api.dart';
import '../../chat/message.dart';

class ToolsLogic extends GetxController {
  final List<Message> letter = <Message>[].obs;
  final List<Message> essay = <Message>[].obs;
  final TextEditingController controller = TextEditingController();

  final API api = API();
  final ChatbotDatabase database = ChatbotDatabase.instance;

  var isTyping = false.obs;

  List<Message> getListByTool(String tool) {
    switch (tool.toLowerCase()) {
      case 'essay':
        return essay;
      case 'letter':
        return letter;
      default:
        return <Message>[].obs;
    }
  }

  Set<int> copiedKeys = <int>{}.obs;

  void copyText(String text, int key) async {
    if (copiedKeys.isNotEmpty) return;

    await Clipboard.setData(ClipboardData(text: text));
    copiedKeys.add(key);

    Future.delayed(const Duration(seconds: 2), () {
      copiedKeys.remove(key);
    });

    Get.snackbar('Copied', 'Text copied to clipboard');
  }

  Future<void> stopGenerating() async {
    await api.stopGenerating();
  }

  Future<void> getResponse(String tool, String userPrompt) async {

    if (userPrompt.trim().isEmpty) return;

    List<Message> messages = getListByTool(tool);

    messages.clear();

    final userMessage = Message(
      chatId: -1,
      message: userPrompt,
      role: false,
    );
    messages.add(userMessage);

    controller.clear();

    isTyping.value = true;
    update();
    final loadingMessage = Message(
      chatId: -1,
      message: '...',
      role: true,
    );
    messages.add(loadingMessage);
    final loadingIndex = messages.length - 1;

    // ✅ Add your invisible "system prompt"
    final systemPrompt = Message(
      chatId: -1,
      message: '''
        You are an AI assistant specialized in $tool writing.
        Your job is to help users generate well-written, meaningful, and relevant $tool content.
        You may respond even if the user provides only a topic, as long as it is suitable for $tool writing.
        However, you must not respond to prompts that are unrelated to $tool writing, such as technical questions, general information, or inappropriate content. In such cases, politely inform the user that you only assist with $tool writing.
        Always ensure that your responses follow proper structure, tone, and creativity expected in $tool content.
      ''',
      role: false,
    );

    final apiMessages = [systemPrompt, userMessage];

    final response = await api.getResponse(userPrompt, apiMessages);

    messages[loadingIndex] = Message(
      chatId: -1,
      message: response ?? 'Failed to get response.',
      role: true,
    );

    isTyping.value = false;
    update();
  }

  Future<void> exportChatAsPdf(String chatTitle) async {
    final messages = getListByTool(chatTitle);
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

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$chatTitle.pdf');
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
