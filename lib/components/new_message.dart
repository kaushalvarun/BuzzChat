import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _msgController = TextEditingController();

  // frees memory used by controller after use
  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

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
    // close open keyyboard
    FocusScope.of(context).unfocus();

    // Fetching current user details
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // connect to Firestore and store chat data
    FirebaseFirestore.instance.collection('chats').add({
      'text': enteredMsg,
      'timestamp': Timestamp.now(),
      // stored in firebase auth
      'userid': user.uid,
      // stored in firestore
      'username': userData['username'], // access using key value pair
    });
  }

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
              decoration: const InputDecoration(labelText: 'Send a message...'),
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
