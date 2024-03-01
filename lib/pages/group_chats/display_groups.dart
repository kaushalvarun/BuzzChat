import 'package:buzzchatv2/components/group_chat/group_tile.dart';
import 'package:buzzchatv2/group.dart';
import 'package:buzzchatv2/pages/group_chats/create_group.dart';
import 'package:buzzchatv2/pages/group_chats/group_chatroom_id.dart.dart';
import 'package:buzzchatv2/user.dart';
import 'package:buzzchatv2/util/current_user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayGroups extends StatefulWidget {
  const DisplayGroups({super.key});

  @override
  State<DisplayGroups> createState() => _DisplayGroupsState();
}

class _DisplayGroupsState extends State<DisplayGroups> {
  List<Group> groups = List.empty();
  final User cUser = FirebaseAuth.instance.currentUser!;
  BcUser? currUser;
  @override
  void initState() {
    super.initState();
    _readGrpFromDb();
  }

  Future<void> _readGrpFromDb() async {
    await fetchCurrentUserDetails(cUser).then((user) {
      setState(() {
        currUser = user;
      });
    });
    groups = await readGroupDataFromDb(currentUser!);
    setState(() {}); // trigger rebuild when fetched
  }

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
                GroupTile(
                  groupName: groups[index].getGroupName(),
                  groupChatroomId: groups[index].getGroupChatRoomId(),
                  // latestMessage: latestMessage,
                  // timestamp: timestamp,
                  creatorOfGroup: groups[index].getCreatorOfGroup(),
                ),
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
