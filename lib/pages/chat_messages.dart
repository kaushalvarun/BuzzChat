import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('timestamp',
              descending: true) // as we are using list in reverse
          .snapshots(),
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
            itemBuilder: (context, index) =>
                Text(prevMessages[index].data()['text']),
          ),
        );
      },
    );
  }
}
