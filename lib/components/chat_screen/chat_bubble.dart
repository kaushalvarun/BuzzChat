import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String messageText;
  final bool isCurrentUser;
  final String msgTimestamp;

  const ChatBubble({
    super.key,
    required this.messageText,
    required this.isCurrentUser,
    required this.msgTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isCurrentUser
        ? const Color.fromRGBO(194, 175, 244, 1)
        : const Color.fromRGBO(238, 238, 238, 1);
    final alignment =
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start;
    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: alignment,
                children: [
                  Text(
                    messageText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ],
              ),
              Text(
                msgTimestamp,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Helvetica',
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
