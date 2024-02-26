import 'package:buzzchatv2/components/group_chat/group_chatroom_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewGroupMessage extends StatefulWidget {
  const NewGroupMessage({super.key});

  @override
  State<NewGroupMessage> createState() => _NewGroupMessageState();
}

class _NewGroupMessageState extends State<NewGroupMessage> {
  // Get connection to firebase firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Get connection to firebase firestore
  final FirebaseAuth _fireauth = FirebaseAuth.instance;

  final _msgController = TextEditingController();

  // send Message function
  void _sendMsg() async {
    // get user message
    final enteredMsg = _msgController.text;

    // prevents empty messages from being sent
    if (enteredMsg.trim().isEmpty) {
      return;
    }

    // reset text field
    _msgController.clear();
    // close opened keyyboard
    FocusScope.of(context).unfocus();

    // Fetching current user details
    final user = _fireauth.currentUser!;
    final userData = await _firestore.collection('users').doc(user.uid).get();
    chatroomIdString = await getGroupChatRoomId();

    // Message to be stored in firestore db
    Map<String, dynamic> messages = {
      "sentby": userData['username'],
      'senderID': user.uid,
      "text": enteredMsg,
      "timestamp": Timestamp.now(),
    };

    // connect to Firestore and store chat data in chatroom, as per unique id
    await _firestore
        .collection('chatroom')
        .doc(chatroomIdString)
        .collection('chats')
        .add(messages);
  }

  // Ui for send message row
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 1),
      child: Row(
        children: [
          // to prevent any overflow issues added expanded
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              controller: _msgController,
              maxLines: null, // to wrap input text
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Send a message...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

                isDense: true, // Reduces the overall height of the TextField
              ),

              // trigger rebuild if longer wrapped text
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          IconButton(
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _sendMsg,
          ),
        ],
      ),
    );
  }
}
