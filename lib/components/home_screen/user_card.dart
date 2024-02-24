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
    required this.username,
    required this.onTap,
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
            return Expanded(
              child: Center(
                child:
                    Text('Something went wrong...\n Error: ${snapshot.error}'),
              ),
            );
          }

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // if no messages to this user yet
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Expanded(
              child: Center(
                child: Text(''),
              ),
            );
          }

          final username = widget.username;
          // access messages fetched from firestore
          final messages = snapshot.data!.docs;
          final latestMsgData = messages[messages.length - 1].data();
          final Timestamp timestamp = latestMsgData['timestamp'] as Timestamp;

          return Material(
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                color: Colors.white,

                // user card with divider
                child: Column(
                  children: [
                    // main user card and timestamp row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // telling row to fill available space on screen
                        Expanded(
                          child: Row(
                            children: [
                              // user profile pic
                              Image.asset(
                                'lib/images/userDefaultPhoto.png',
                                height: 65,
                              ),

                              // sizedbox
                              const SizedBox(width: 5),

                              // name and latest message
                              // fetch latest message from firestore
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // username
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    // latest message
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: Text(
                                        latestMsgData['text'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // timestamp and status
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 25, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // timestamp

                              Text(
                                formatTimestamp(timestamp),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              // unread message count
                              // const CircleAvatar(
                              //     radius: 10,
                              //     backgroundColor:
                              //         Color.fromRGBO(0, 193, 167, 1),
                              //     child: Text(
                              //       '2',
                              //       style: TextStyle(
                              //           color: Colors.white,
                              //           fontSize: 10,
                              //           fontWeight: FontWeight.w600),
                              //     )),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Divider
                    const Divider(
                      indent: 70,
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
