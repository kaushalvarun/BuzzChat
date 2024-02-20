import 'package:buzzchatv2/components/chat_screen/chat_bubble.dart';
import 'package:buzzchatv2/pages/chat/chatroom_id.dart';
import 'package:buzzchatv2/pages/chat/format_timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          return Expanded(
            child: Center(
              child: Text('Something went wrong...\n Error: ${snapshot.error}'),
            ),
          );
        }

        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Message list
        // No previous messages
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Expanded(
            child: Center(
              child: Text('No messages yet..'),
            ),
          );
        }

        // Fetching & Loading messages from firestore
        final prevMessages = snapshot.data!.docs;

        // return messages grouped by date
        return Expanded(
          child: ListView.builder(
            itemCount: prevMessages.length,
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 40),
            reverse: false, // to get top to bottom

            itemBuilder: (context, index) {
              // getting current message data
              final messageData = prevMessages[index].data()!
                  as Map<String, dynamic>; // Cast to Map

              bool isCurrentUser =
                  messageData['senderID'] == _fireauth.currentUser!.uid;

              // color based on sender or reciever
              final messageText = messageData['text'];

              final msgTimestamp = formatTimestamp(messageData['timestamp']);

              /* code to group messages by date */

              final DateTime date =
                  (messageData['timestamp'] as Timestamp).toDate();
              bool isSameDate = false; // first message

              // check if current date is same as previous date
              if (index > 0) {
                final prevMessageData = prevMessages[index - 1].data()!
                    as Map<String, dynamic>; // Cast to Map
                final DateTime prevDate = prevMessageData['timestamp'].toDate();
                isSameDate = date.isSameDate(prevDate);
              }

              if (index == 0 || !(isSameDate)) {
                // create new group of current date
                return Column(children: [
                  // if date is today or yesterday
                  dateText(date),

                  ChatBubble(
                    messageText: messageText,
                    isCurrentUser: isCurrentUser,
                    msgTimestamp: msgTimestamp,
                  ),
                ]);
              }
              // add this message to previous group, same day messages
              else {
                return ChatBubble(
                  messageText: messageText,
                  isCurrentUser: isCurrentUser,
                  msgTimestamp: msgTimestamp,
                );
              }
            },
          ),
        );
      },
    );
  }
}

// helper functions to group messages by date
const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    // here yere is this.year, etc
    return year == other.year && month == other.month && day == other.day;
  }
}

// check if date is today, yesterday or other date
Text dateText(DateTime date) {
  // date istoday
  if (date.isSameDate(DateTime.now())) {
    return const Text('Today');
  }
  // date is yesterday
  else if (date.isSameDate(DateTime.now().subtract(const Duration(days: 1)))) {
    return const Text('Yesterday');
  }
  // other date
  else {
    return Text(date.formatDate());
  }
}
