import 'package:buzzchatv2/components/group_chat/group_tile.dart';
import 'package:buzzchatv2/pages/group_chats/create_group.dart';
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
      groupName: 'Group 1',
      latestMessage: 'Latest Message',
      timestamp: Timestamp.now(),
    ),
    GroupTile(
      groupName: 'Group 2',
      latestMessage: 'Latest Message',
      timestamp: Timestamp.now(),
    ),
    GroupTile(
      groupName: 'Group 3',
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
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        // circular shape
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.blue[200],
        child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Icon(Icons.add)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateGroup(),
            ),
          );
        },
      ),
    );
  }
}
