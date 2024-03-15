import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }
}

// Path: lib/models/chat_message.dart