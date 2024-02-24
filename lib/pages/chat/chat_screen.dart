import 'package:buzzchatv2/components/chat_screen/new_message.dart';
import 'package:buzzchatv2/pages/chat/chat_messages.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Flexible chat message section
          ChatMessages(reciever: username),
          // Remaining space to new message section (enter message)
          NewMessage(user2: username),
        ],
      ),
    );
  }
}
