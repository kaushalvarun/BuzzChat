import 'package:buzzchatv2/components/new_message.dart';
import 'package:buzzchatv2/pages/chat_messages.dart';
import 'package:buzzchatv2/util/sign_out.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic>? userMap;
  final String username;
  const ChatScreen({
    super.key,
    required this.userMap,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar ui
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // username text
        title: Text(
          username,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        centerTitle: false,
        actions: const [
          IconButton(
            onPressed: signout,
            icon: Icon(Icons.logout),
            iconSize: 25,
          ),
        ],
      ),
      // Body begins
      body: Expanded(
        child: Column(
          children: [
            // Previous chat messages
            ChatMessages(user2: username),
            // Send message row
            NewMessage(user2: username),
          ],
        ),
      ),
    );
  }
}
