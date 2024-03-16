import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'birb.dart';
import 'birb_hero.dart';

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
    return Row(
      mainAxisAlignment:
          inUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!inUserMessage) ...[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BirbHero()));
            },
            child: Hero(
              tag: 'birbHero',
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: Colors.transparent,
                child: Birb(),
              ),
            ),
          ),

        ],
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: inUserMessage ? Colors.blue[300] : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: inUserMessage ? const Radius.circular(16) : Radius.zero,
                bottomRight: !inUserMessage ? const Radius.circular(16) : Radius.zero,
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
      ],
    );
  }
}
