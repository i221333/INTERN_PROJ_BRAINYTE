  import 'package:chatbot/chatbot/Screens/chat/message.dart';
  import 'package:path/path.dart';
  import 'package:sqflite/sqflite.dart';

  import '../Screens/chathistory/chat.dart';

  class ChatbotDatabase {
    static final ChatbotDatabase instance = ChatbotDatabase._internal();
    static Database? _database;

    ChatbotDatabase._internal();

    Future<Database> get database async {
      if (_database != null) {
        return _database!;
      }

      _database = await initDatabase();
      return _database!;
    }

    Future<Database> initDatabase() async {
      return await openDatabase(
        join(await getDatabasesPath(), 'chatbot_database.db'),
        version: 2, // Make sure this is bumped when structure changes
        onCreate: _createDatabase,
        onUpgrade: _upgradeDatabase,
      );
    }

    Future<void> _createDatabase(Database database, int version) async {
      await database.execute('''
        CREATE TABLE chat (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          timestamp TEXT NOT NULL
        )
      ''');

      await database.execute('''
        CREATE TABLE prompt (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          chatId INTEGER NOT NULL,
          message TEXT NOT NULL,
          FOREIGN KEY (chatId) REFERENCES chat(id) ON DELETE CASCADE
        )
      ''');

      await database.execute('''
        CREATE TABLE response (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          promptId INTEGER NOT NULL,
          message TEXT NOT NULL,
          FOREIGN KEY (promptId) REFERENCES prompt(id) ON DELETE CASCADE
        )
      ''');
    }

    Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
      print('Starting upgrade from $oldVersion to $newVersion');

      try {
        if (oldVersion < 2) {
          print('Creating prompt and response tables if not exist');

          // Create new tables if they don’t exist
          await db.execute('''
        CREATE TABLE IF NOT EXISTS prompt (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          chatId INTEGER NOT NULL,
          message TEXT NOT NULL,
          FOREIGN KEY (chatId) REFERENCES chat(id) ON DELETE CASCADE
        )
      ''');

          await db.execute('''
        CREATE TABLE IF NOT EXISTS response (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          promptId INTEGER NOT NULL,
          message TEXT NOT NULL,
          FOREIGN KEY (promptId) REFERENCES prompt(id) ON DELETE CASCADE
        )
      ''');

          // Migrate messages from old structure if it exists
          final chats = await db.query('chat');
          print('Found ${chats.length} chats to migrate');

          for (final chat in chats) {
            final chatId = chat['id'] as int;

            final messages = await db.query(
              'message',
              where: 'chatId = ?',
              whereArgs: [chatId],
              orderBy: 'id ASC',
            );

            int? lastPromptId;

            for (final msg in messages) {
              final role = msg['role'] as String;
              final messageText = msg['message'] as String;

              if (role == 'user') {
                lastPromptId = await db.insert('prompt', {
                  'chatId': chatId,
                  'message': messageText,
                });
              } else if (role == 'assistant' && lastPromptId != null) {
                await db.insert('response', {
                  'promptId': lastPromptId,
                  'message': messageText,
                });
              }
            }
          }

          print('Dropping old message table');
          await db.execute('DROP TABLE IF EXISTS message');
        }

        print('Upgrade complete');
      } catch (e, st) {
        print('❌ Error during upgrade: $e');
        print(st);
        rethrow;
      }
    }

    Future<int> insertNewChat(String title) async {
      final db = await instance.database;
      final timestamp = DateTime.now().toString();
      int id = await db.insert(
        'chat',
        {
          'title': title,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print(id > 0 ? '✅ Insert successful, Chat ID: $id' : '❌ Insert failed');
      return id;
    }

    Future<void> insertPromptAndResponse(int chatId, String prompt, String response,) async {
      final promptId = await insertPrompt(chatId, prompt);
      await insertResponse(promptId, response);
    }

    Future<int> insertPrompt(int chatId, String message) async {
      final db = await instance.database;

      return await db.insert('prompt', {
        'chatId': chatId,
        'message': message,
      });
    }

    Future<int> insertResponse(int promptId, String message) async {
      final db = await instance.database;

      final responseId = await db.insert('response', {
        'promptId': promptId,
        'message': message,
      });

      final promptResult = await db.query(
        'prompt',
        columns: ['chatId'],
        where: 'id = ?',
        whereArgs: [promptId],
      );

      if (promptResult.isNotEmpty) {
        final chatId = promptResult.first['chatId'] as int;
        await updateChatTimestamp(chatId);
      }

      return responseId;
    }


    Future<List<Chat>> readAllChats() async {
      final db = await instance.database;

      final result = await db.query(
        'chat',
        orderBy: 'timestamp DESC',
      );

      return result.map((json) => Chat.fromMap(json)).toList();
    }

    Future<List<Message>> readAllMessages(int chatId) async {
      final db = await instance.database;

      // Get all prompts for this chat
      final prompts = await db.query(
        'prompt',
        where: 'chatId = ?',
        whereArgs: [chatId],
      );

      List<Message> messages = [];

      for (final prompt in prompts) {
        final promptId = prompt['id'] as int;

        // Add prompt as user message
        messages.add(Message(
          id: promptId,
          chatId: chatId,
          message: prompt['message'] as String,
          role: false, // false = user
        ));

        // Get related responses
        final responses = await db.query(
          'response',
          where: 'promptId = ?',
          whereArgs: [promptId],
        );

        for (final response in responses) {
          messages.add(Message(
            id: response['id'] as int?,
            chatId: promptId,  // store promptId here
            message: response['message'] as String,
            role: true,
          ));
        }
      }

      return messages;
    }

    Future<void> updateChatTitle(int chatId, String newTitle) async {
      final db = await instance.database;
      final count = await db.update(
        'chat',
        {'title': newTitle},
        where: 'id = ?',
        whereArgs: [chatId],
      );
      print(count > 0 ? '✅ Update successful' : '❌ Update failed');
    }

    Future<void> updateChatTimestamp(int chatId) async {
      final db = await instance.database;

      await db.update(
        'chat',
        {
          'timestamp': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [chatId],
      );
    }

    Future<void> deleteChat(int chatid) async {
      final db = await instance.database;
      await db.delete('chat', where: 'id = ?', whereArgs: [chatid]);
    }

    Future<void> deleteAllChats() async {
      final db = await instance.database;
      await db.delete('response');
      await db.delete('prompt');
      await db.delete('chat');
    }

    Future<void> deleteDatabaseFile() async {
      final dbPath = join(await getDatabasesPath(), 'chatbot_database.db');
      try {
        await deleteDatabase(dbPath);
        print('✅ Database file deleted successfully.');
        _database = null; // reset cached database instance
      } catch (e) {
        print('❌ Failed to delete database file: $e');
      }
    }

    Future close() async {
      final db = await instance.database;
      db.close();
    }
  }