class Message {
  int? id;
  int chatId;
  String message;
  bool role;

  Message({
    this.id,
    required this.chatId,
    required this.message,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    final data = {
      'chatId': chatId,
      'message': message,
      'role': role ? 'assistant' : 'user',
    };

    final localId = id;
    if (localId != null) {
      data['id'] = localId;
    }

    return data;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as int?,
      chatId: map['chatId'] as int,
      message: map['message'] as String,
      role: map['role'].toString() == 'assistant',
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, chatId: $chatId, message: $message, role: $role)';
  }
}
