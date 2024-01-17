import 'package:buzzchatv2/util/chatroom_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  final String user2;
  const ChatMessages({
    super.key,
    required this.user2,
  });

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  // Get connection to firebase firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Get connection to firebase firestore
  final FirebaseAuth _fireauth = FirebaseAuth.instance;
  // Store the chatroom ID
  String? chatroomIdString;

  Future<String> getChatRoom() async {
    final user = _fireauth.currentUser!;
    final userData = await _firestore.collection('users').doc(user.uid).get();
    return chatroomId(userData['username'], widget.user2);
  }

  Future<void> _getChatRoomId() async {
    chatroomIdString = await getChatRoom();
    setState(() {}); // Trigger a rebuild to use the fetched ID
  }

  @override
  void initState() {
    super.initState();
    _getChatRoomId(); // Fetch the ID when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatroomIdString != null
          ? _firestore
              .collection('chatroom')
              .doc(chatroomIdString)
              .collection('chats')
              .orderBy('timestamp',
                  descending: true) // as we are using list in reverse
              .snapshots()
          : const Stream.empty(),
      builder: (context, snapshot) {
        // waiting to connect to firestore
        if (snapshot.connectionState == ConnectionState.waiting) {
          const Center(
            child: CircularProgressIndicator(),
          );
        }

        // no previous messages
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          const Expanded(
            child: Center(
              child: Text('No messages yet..'),
            ),
          );
        }

        // error
        if (snapshot.hasError) {
          Expanded(
            child: Center(
              child: Text('Something went wrong...\n error: ${snapshot.error}'),
            ),
          );
        }

        // fetch messages from firestore and load them
        final prevMessages = snapshot.data!.docs;
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 40),
            reverse: true, // to get bottom to top
            itemCount: prevMessages.length,
            itemBuilder: (context, index) {
              final messageData = prevMessages[index].data()!
                  as Map<String, dynamic>; // Cast to Map
              final messageText = messageData['text'];
              return Text(
                  messageText ?? 'No text found'); // Handle potential null
            },
          ),
        );
      },
    );
  }
}
