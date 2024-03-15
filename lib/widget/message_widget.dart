import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.inUserMessage,
    required this.message,
  });

  final bool inUserMessage;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: inUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: inUserMessage ? Colors.blue[300] : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: inUserMessage
                  ? const Radius.circular(16)
                  : const Radius.circular(0),
              topRight: inUserMessage
                  ? const Radius.circular(0)
                  : const Radius.circular(16),
              bottomLeft: const Radius.circular(16),
              bottomRight: const Radius.circular(16),
            ),
          ),
          child: MarkdownBody(
            data: message,
            selectable: true,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: inUserMessage ? Colors.white : Colors.black87,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

// Path: lib/screens/chat_screen.dart
