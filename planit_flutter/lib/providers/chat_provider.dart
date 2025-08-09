import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isThinking = false;

  UnmodifiableListView<ChatMessage> get messages => UnmodifiableListView(_messages);
  bool get isThinking => _isThinking;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isThinking) return;

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: ChatRole.user,
      text: text.trim(),
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    notifyListeners();

    _isThinking = true;
    notifyListeners();

    // Simulated AI response after delay
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final String replyText = _generateLocalReply(text);

    final assistantMessage = ChatMessage(
      id: (DateTime.now().microsecondsSinceEpoch + 1).toString(),
      role: ChatRole.assistant,
      text: replyText,
      timestamp: DateTime.now(),
    );
    _messages.add(assistantMessage);

    _isThinking = false;
    notifyListeners();
  }

  void clear() {
    _messages.clear();
    notifyListeners();
  }

  String _generateLocalReply(String prompt) {
    final normalized = prompt.toLowerCase();
    if (normalized.contains('grocery') || normalized.contains('shopping')) {
      return 'Here is a quick grocery plan:\n- Milk\n- Eggs\n- Bread\n- Fresh fruit\nWould you like me to add these to your list?';
    }
    if (normalized.contains('meal') || normalized.contains('dinner') || normalized.contains('lunch')) {
      return 'Meal idea: Grilled chicken with quinoa and veggies. I can generate a shopping list if you want!';
    }
    return 'Got it. I\'m here to help plan tasks, meals, and shopping.';
  }
}