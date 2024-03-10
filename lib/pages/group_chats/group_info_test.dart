import 'package:buzz_chat/components/general_components/photo_container.dart';
import 'package:buzz_chat/group.dart';
// import 'package:buzz_chat/pages/group_chats/display_groups.dart';
import 'package:buzz_chat/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final Group groupData;
  const GroupInfo({
    super.key,
    required this.groupData,
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<BcUser>? members;

  Future<void> _fetchMembers(List<String> memberEmails) async {
    List<BcUser> membersLoc = [];
    for (String memberEmail in memberEmails) {
      try {
        await _firestore
            .collection('users')
            .where('email', isEqualTo: memberEmail)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            Map<String, dynamic> userMap = value.docs[0].data();
            membersLoc.add(BcUser.fromJson(userMap));
          }
        });
        setState(() {
          members = membersLoc;
        });
      } catch (e) {
        setState(() {
          // print('members are null');
          members = null;
        });
        // ignore: avoid_print
        print('Error fetching user details: $e');
      }
    }
  }

  @override
  void initState() {
    _fetchMembers(widget.groupData.getMembers());
    super.initState();
  }

  Future<void> leaveGroup() async {
    try {
      // 1. Group members -= current user
      await _firestore
          .collection('group_chatrooms')
          .doc(widget.groupData.groupChatRoomId)
          .update({
        'members': FieldValue.arrayRemove([_firebaseAuth.currentUser!.email!])
      });

      // 2. Remove this group from user.groups
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: _firebaseAuth.currentUser!.email!)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs[0].id;
        await _firestore.collection('users').doc(userId).update({
          'groups': FieldValue.arrayRemove([widget.groupData.groupChatRoomId])
        });
      }

      // Show success dialog
      showLeaveGroupDialog();
    } catch (e) {
      // ignore: avoid_print
      print("Error leaving group: $e");
    }
  }

  void showLeaveGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Left Group"),
          content: const Text("You have successfully left the group."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); // Pop twice to go back to display groups screen
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // AlertDialog? leaveAlert;
    // showing loading indicator while fetching data
    if (members == null) {
      return const CircularProgressIndicator();
    } else if (members!.isEmpty) {
      return const Text('No members found');
    }
    // data fetched and not empty
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Group Info',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Group Photo, Name, and members
          Center(
            child: Column(
              children: [
                // photo
                const PhotoContainer(
                  width: 120,
                ),

                // name
                Text(
                  widget.groupData.getGroupName(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

                // members text
                Text(
                  'Group : ${members!.length} members',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Leave group button
          TextButton(
            child: const Text(
              'Leave Group',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              // Set to true when the button is pressed
              try {
                await leaveGroup();
              } catch (e) {
                // ignore: avoid_print
                print('Error leaving group: $e');
              }
            },
          ),

          // Members row
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${members!.length} Members',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Members list
          Expanded(
            child: ListView.builder(
              itemCount: members!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 25),
                      title: Text(
                        members![index].getUsername(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        members![index].getEmail(),
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Divider(
                      indent: 25,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
