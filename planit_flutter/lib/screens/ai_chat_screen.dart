import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        actions: [
          IconButton(
            onPressed: chat.messages.isEmpty ? null : chat.clear,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear chat',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chat.messages.length + (chat.isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chat.messages.length && chat.isThinking) {
                  return const _ThinkingBubble();
                }
                final ChatMessage message = chat.messages[index];
                final isUser = message.role == ChatRole.user;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(message.text),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask for meal or shopping plans…',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: chat.isThinking ? null : () => _send(context),
                    icon: const Icon(Icons.send),
                    label: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatProvider>().sendMessage(text);
    _controller.clear();
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Thinking…'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}