import 'package:buzzchatv2/components/group_chat/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayGroups extends StatefulWidget {
  const DisplayGroups({super.key});

  @override
  State<DisplayGroups> createState() => _DisplayGroupsState();
}

class _DisplayGroupsState extends State<DisplayGroups> {
  final List<GroupTile> groups = [
    GroupTile(
      grouptitle: 'Group 1',
      latestMessage: 'Latest Message',
      timestamp: Timestamp.now(),
    ),
    GroupTile(
      grouptitle: 'Group 2',
      latestMessage: 'Latest Message',
      timestamp: Timestamp.now(),
    ),
    GroupTile(
      grouptitle: 'Group 3',
      latestMessage: 'Latest Message',
      timestamp: Timestamp.now(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Groups',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // body
      body: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                groups[index],
              ],
            );
          }),
    );
  }
}
