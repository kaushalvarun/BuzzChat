import 'package:buzzchatv2/components/chat_screen/chat_bubble.dart';
import 'package:buzzchatv2/components/chat_screen/date_text.dart';
import 'package:buzzchatv2/pages/chat/format_timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupMessages extends StatefulWidget {
  final String creatorOfGroup;
  final String? chatroomId;
  const GroupMessages({
    super.key,
    required this.creatorOfGroup,
    required this.chatroomId,
  });

  @override
  State<GroupMessages> createState() => _GroupMessagesState();
}

class _GroupMessagesState extends State<GroupMessages> {
  // Get connection to firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _fireauth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // listening to firestore chatroom/chatroomId to get specific chat
    // and then showing ui
    return StreamBuilder<QuerySnapshot>(
      // stream firestore chatroom/chatroomId
      stream: (widget.chatroomId != null)
          ? _firestore
              .collection('group_chatrooms')
              .doc(widget.chatroomId)
              .collection('chats')
              .orderBy('timestamp',
                  descending: true) // as we are using list in reverse
              .snapshots()
          : const Stream.empty(),
      // builder ui
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.creatorOfGroup,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' created this group',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                      'Something went wrong...\n Error: ${snapshot.error}'),
                ),
              ],
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
          return Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.creatorOfGroup,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' created this group',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text('No messages yet..'),
                  ),
                ),
              ],
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
            reverse: true, // to get top to bottom

            itemBuilder: (context, index) {
              // getting current message data
              final messageData = prevMessages[index].data()!
                  as Map<String, dynamic>; // Cast to Map

              bool isCurrentUser =
                  messageData['senderID'] == _fireauth.currentUser!.uid;

              // color based on sender or reciever
              final messageText = messageData['text'];

              final msgTime = formatTimestamp(messageData['timestamp']);

              final DateTime msgDate =
                  (messageData['timestamp'] as Timestamp).toDate();

              /* code to group messages by date */

              // only single message in prevmessages
              if (index == 0 && prevMessages.length == 1) {
                return Column(
                  children: [
                    // if date is today or yesterday or other
                    DateText(date: msgDate),

                    ChatBubble(
                      messageText: messageText,
                      isCurrentUser: isCurrentUser,
                      msgTimestamp: msgTime,
                    ),
                  ],
                );
              }
              // more than 1 message in message list
              else {
                //  oldest message
                if (index == prevMessages.length - 1) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.creatorOfGroup,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ' created this group',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // if date is today or yesterday or other
                      DateText(date: msgDate),

                      ChatBubble(
                        messageText: messageText,
                        isCurrentUser: isCurrentUser,
                        msgTimestamp: msgTime,
                      ),
                    ],
                  );
                }

                // newest message or any message which is not oldest message
                else {
                  final prevMessageData = prevMessages[index + 1].data()!
                      as Map<String, dynamic>; // Cast to Map
                  // prev message date
                  final DateTime prevDate =
                      prevMessageData['timestamp'].toDate();

                  // check if prev msg date is same as curr msg date and store result
                  final bool isSameDate = msgDate.isSameDate(prevDate);

                  if (isSameDate) {
                    // add this message to previous group, same day messages
                    return ChatBubble(
                      messageText: messageText,
                      isCurrentUser: isCurrentUser,
                      msgTimestamp: msgTime,
                    );
                  } else {
                    // create new group of current date
                    return Column(
                      children: [
                        // if date is today or yesterday or other
                        DateText(date: msgDate),
                        ChatBubble(
                          messageText: messageText,
                          isCurrentUser: isCurrentUser,
                          msgTimestamp: msgTime,
                        ),
                      ],
                    );
                  }
                }
              }
            },
          ),
        );
      },
    );
  }
}
