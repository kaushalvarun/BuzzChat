import 'package:buzzchatv2/components/new_message.dart';
import 'package:buzzchatv2/pages/chat_messages.dart';
import 'package:buzzchatv2/util/sign_out.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Chats",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
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
      body: const Column(
        children: [
          // previous chat messages
          ChatMessages(),
          // send message row
          NewMessage(),
        ],
      ),
    );
  }
}
