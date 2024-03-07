// import 'package:buzz_chat/pages/chat/format_timestamp.dart';
import 'package:buzz_chat/pages/group_chats/group_chat_screen.dart';
import 'package:buzz_chat/user.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String creatorOfGroup;
  final String groupName;
  final String groupChatroomId;
  final List<BcUser> groupMembers;

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
  @override
  Widget build(BuildContext context) {
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
              const SizedBox(width: 8), // Adjust as needed
              // Text(
              //   formatTimestamp(widget.timestamp),
              //   textAlign: TextAlign.end,
              //   style: const TextStyle(fontSize: 11),
              // ),
            ],
          ),
          subtitle: const Text(
            'Latest message',
            // widget.latestMessage,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
            ),
          ),
          dense: true,
          visualDensity: const VisualDensity(vertical: 2.5), // Adjust as needed
        ),
        const Divider(
          indent: 105,
          height: 20,
        )
      ],
    );
  }
}
