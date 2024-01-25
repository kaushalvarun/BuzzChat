import 'package:buzzchatv2/components/chat_bubble.dart';
import 'package:buzzchatv2/util/chatroom_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  final String reciever;
  const ChatMessages({
    super.key,
    required this.reciever,
  });

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  // Get connection to firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _fireauth = FirebaseAuth.instance;

  // Store the chatroom ID
  String? chatroomIdString;

  Future<String> getChatRoom() async {
    final currentUser = _fireauth.currentUser!;
    final userData =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return chatroomId(userData['username'], widget.reciever);
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
    // listening to firestore chatroom/chatroomId to get specific chat
    // and then showing ui
    return StreamBuilder<QuerySnapshot>(
      // stream firestore chatroom/chatroomId
      stream: chatroomIdString != null
          ? _firestore
              .collection('chatroom')
              .doc(chatroomIdString)
              .collection('chats')
              .orderBy('timestamp',
                  descending: false) // as we are using list in reverse
              .snapshots()
          : const Stream.empty(),
      // builder ui
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          Expanded(
            child: Center(
              child: Text('Something went wrong...\n error: ${snapshot.error}'),
            ),
          );
        }

        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Message list
        // No previous messages
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          const Expanded(
            child: Center(
              child: Text('No messages yet..'),
            ),
          );
        }

        // Fetching & Loading messages from firestore
        final prevMessages = snapshot.data!.docs;
        return Expanded(
          // List of messages
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 40),
            reverse: false, // to get top to bottom
            itemCount: prevMessages.length,
            itemBuilder: (context, index) {
              final messageData = prevMessages[index].data()!
                  as Map<String, dynamic>; // Cast to Map

              bool isCurrentUser =
                  messageData['senderID'] == _fireauth.currentUser!.uid;

              // color based on sender or reciever

              final messageText = messageData['text'];
              return Column(
                // alignment of column based on sender or reciever
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  ChatBubble(
                    messageText: messageText,
                    isCurrentUser: isCurrentUser,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
