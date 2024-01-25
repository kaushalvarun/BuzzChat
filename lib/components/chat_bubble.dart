import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String messageText;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.messageText,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final messageColor = isCurrentUser
        ? const Color.fromRGBO(194, 175, 244, 1)
        : const Color.fromRGBO(238, 238, 238, 1);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color:
            messageColor, // now coloring this small container and not that big container
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(messageText,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Helvetica',
          )),
    );
  }
}
