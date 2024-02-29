import 'package:buzzchatv2/pages/chat/chatroom_id.dart';
import 'package:buzzchatv2/pages/chat/format_timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final String username;
  final void Function() onTap;

  const UserCard({
    super.key,
    required this.onTap,
    required this.username,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _fireauth = FirebaseAuth.instance;

  // Store the chatroom ID
  String? chatroomIdString;

  Future<String> getChatRoom() async {
    final currentUser = _fireauth.currentUser!;
    final userData =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return chatroomId(userData['username'], widget.username);
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
    return StreamBuilder(
      stream: _firestore
          .collection('chatroom')
          .doc(chatroomIdString)
          .collection('chats')
          .orderBy('timestamp')
          .snapshots(),
      builder: ((context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong...\n Error: ${snapshot.error}'),
          );
        }

        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final username = widget.username;

        // if no messages to this user yet
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            children: [
              ListTile(
                onTap: widget.onTap,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: SizedBox(
                        width: 60,
                        child: Image.asset(
                          'lib/images/groupDefault.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                dense: true,
                visualDensity: const VisualDensity(vertical: 2.5),
              ),
              const Divider(
                indent: 25,
                height: 20,
              )
            ],
          );
        }

        // access messages fetched from firestore
        final messages = snapshot.data!.docs;
        final latestMsgData = messages[messages.length - 1].data();
        final Timestamp timestamp = latestMsgData['timestamp'] as Timestamp;
        return Column(
          children: [
            ListTile(
              onTap: widget.onTap,
              leading: SizedBox(
                width: 80,
                child: Image.asset(
                  'lib/images/groupDefault.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      username,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Adjust as needed
                  Text(
                    formatTimestamp(timestamp),
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
              subtitle: Text(
                latestMsgData['text'],
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                ),
              ),
              dense: true,
              visualDensity: const VisualDensity(vertical: 2.5),
            ),
            const Divider(
              indent: 105,
              height: 20,
            )
          ],
        );
      }),
    );
  }
}
