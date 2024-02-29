import 'package:buzzchatv2/components/group_chat/new_group_msg.dart';
import 'package:buzzchatv2/pages/group_chats/group_messages.dart';
import 'package:buzzchatv2/util/sign_out.dart';
import 'package:flutter/material.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupName;

  const GroupChatScreen({
    super.key,
    required this.groupName,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar ui
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // username text
        title: Text(
          widget.groupName,
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

      body: Column(children: [
        // load previous messages
        const GroupMessages(),
        // to send new message section (enter message)
        SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: const NewGroupMessage(),
          ),
        ),
      ]),
    );
  }
}