import 'package:buzz_chat/pages/chat/format_timestamp.dart';
import 'package:buzz_chat/pages/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String creatorOfGroup;
  final String groupName;
  final String groupChatroomId;
  final List<String> groupMembers;

  const GroupTile({
    super.key,
    required this.groupName,
    required this.groupChatroomId,
    required this.creatorOfGroup,
    required this.groupMembers,
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('group_chatrooms')
            .doc(widget.groupChatroomId)
            .collection('chats')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          // handle error case
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong.. \n Error: ${snapshot.error}'),
            );
          }
          // handle loading case
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // no messages yet case
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(
                          groupMembers: widget.groupMembers,
                          groupName: widget.groupName,
                          groupChatroomId: widget.groupChatroomId,
                          creatorOfGroup: widget.creatorOfGroup,
                        ),
                      ),
                    );
                  },
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
                          widget.groupName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  subtitle: const Text(
                    'No messages yet',
                    maxLines: 1,
                    style: TextStyle(
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
          }

          // show latest message
          // fetch messages from firestore
          final messages = snapshot.data!.docs;
          final latestMsgData = messages[messages.length - 1].data();
          final Timestamp latestMsgTimestamp =
              latestMsgData['timestamp'] as Timestamp;

          return Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupChatScreen(
                        groupMembers: widget.groupMembers,
                        groupName: widget.groupName,
                        groupChatroomId: widget.groupChatroomId,
                        creatorOfGroup: widget.creatorOfGroup,
                      ),
                    ),
                  );
                },
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
                        widget.groupName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatTimestamp(latestMsgTimestamp),
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
        });
  }
}
