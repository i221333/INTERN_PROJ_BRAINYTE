import 'package:chatbot/chatbot/Screens/chathistory/chat.dart';
import 'package:get/get.dart';

import '../../Database/database.dart';

class ChathistoryLogic extends GetxController {
  late List<Chat> chats = <Chat>[].obs;
  final ChatbotDatabase database = ChatbotDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    getChats(); // ✅ Only call once during controller init
  }

  Map<String, List<Map<String, dynamic>>> groupChatsByDate() {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var chat in chats) {
      if (!grouped.containsKey(chat.timestamp.toString().split(' ')[0])) {
        grouped[chat.timestamp.toString().split(' ')[0]] = [];
      }

      grouped[chat.timestamp.toString().split(' ')[0]]!.add(chat.toMap());
    }

    return grouped;
  }

  Future<void> getChats() async {
    final chatList = await database.readAllChats();
    // print("📥 Loaded chats: ${chatList.map((e) => e.toMap())}");
    chats.assignAll(chatList);
  }

  Future<void> updateChatTitle(int chatId, String newTitle) async {
    await database.updateChatTitle(chatId, newTitle.trim());
    await getChats();
  }

  Future<void> deleteChat(int chatid) async {
    await database.deleteChat(chatid);
    await getChats();
  }

  Future<void> deleteAllChats() async {
    await database.deleteAllChats();
    await getChats();
  }
}
