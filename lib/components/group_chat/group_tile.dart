import 'package:buzzchatv2/pages/chat/format_timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String grouptitle;
  final String latestMessage;
  final Timestamp timestamp;
  const GroupTile({
    super.key,
    required this.grouptitle,
    required this.latestMessage,
    required this.timestamp,
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
                  widget.grouptitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8), // Adjust as needed
              Text(
                formatTimestamp(widget.timestamp),
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
          subtitle: Text(
            widget.latestMessage,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
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
