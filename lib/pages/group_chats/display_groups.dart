import 'package:buzz_chat/components/group_chat/group_tile.dart';
import 'package:buzz_chat/group.dart';
import 'package:buzz_chat/pages/group_chats/create_group.dart';
import 'package:buzz_chat/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayGroups extends StatefulWidget {
  const DisplayGroups({super.key});

  @override
  State<DisplayGroups> createState() => _DisplayGroupsState();
}

class _DisplayGroupsState extends State<DisplayGroups> {
  List<Group> groups = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User cUser = FirebaseAuth.instance.currentUser!;
  BcUser? currUser;

  @override
  void initState() {
    _getUserGroups(cUser.email!);
    super.initState();
  }

  Future<void> _getUserGroups(String email) async {
    currUser = await userfromEmail(email);
    if (currUser != null) {
      for (String groupId in currUser!.getGroups()) {
        Group? groupData;
        await _firestore
            .collection('group_chatrooms')
            .doc(groupId)
            .get()
            .then((value) {
          if (value.exists) {
            if (value.data()!.isEmpty) {
              groupData = null;
              // ignore: avoid_print
              print('No groups');
            } else {
              groupData = Group.fromJson(value.data()!);
            }
            setState(() {
              groups.add(groupData!);
            });
          }
        }).catchError((e) {
          // ignore: avoid_print
          print('Error in getting user groups\nError:$e');
        });
      }
    }
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

      body: (groups.isEmpty)
          ? const Center(
              child: Text(
              'No groups yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ))
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GroupTile(
                      groupMembers: groups[index].getMembers(),
                      groupName: groups[index].getGroupName(),
                      groupChatroomId: groups[index].getGroupChatRoomId(),
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
