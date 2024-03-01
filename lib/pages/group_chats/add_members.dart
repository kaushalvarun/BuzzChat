import 'package:buzzchatv2/components/general_components/my_button.dart';
import 'package:buzzchatv2/components/group_chat/add_user_tile.dart';
import 'package:buzzchatv2/components/home_screen/search_widget.dart';
import 'package:buzzchatv2/pages/group_chats/group_chat_screen.dart';
import 'package:buzzchatv2/pages/group_chats/group_chatroom_id.dart.dart';
import 'package:buzzchatv2/user.dart';
import 'package:buzzchatv2/util/current_user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMembers extends StatefulWidget {
  final String groupName;
  const AddMembers({
    super.key,
    required this.groupName,
  });

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // current user, group creator
  final User cUser = FirebaseAuth.instance.currentUser!;

  // get current user details
  BcUser? currentUser;

  // added Members
  List<BcUser> addedMembers = [];

  @override
  void initState() {
    super.initState();
    // to get current user details
    fetchCurrentUserDetails(cUser).then((user) {
      currentUser = user;

      if (currentUser != null) {
        // update ui & add currentUser to addMembers
        setState(() {
          addedMembers.add(currentUser!);
        });
      }
    });
    // to get chatroomId
    _groupChatRoomId();
  }

  // chatroom id for this group
  String? groupChatroomId;

  // function to get group chatroom id
  Future<void> _groupChatRoomId() async {
    groupChatroomId = await generateChatroomId();
    setState(() {}); // trigger rebuild when fetched
  }

  // is loading variable to keep track when data is being fetched
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  // map of users recieved from onSearch
  Map<String, dynamic>? userMap;

  // to be added user
  BcUser? toBeAddedUser;

  // on search function to get user details and set isLoading
  void _onSearch() async {
    // set to Loading as searching
    setState(() {
      _isLoading = true;
    });

    // return user details
    await _firestore
        .collection('users')
        .where('email', isEqualTo: _searchController.text.toLowerCase())
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        setState(() {
          _isLoading = false;
          userMap = null;
          toBeAddedUser = null;
        });
      } else {
        setState(() {
          userMap = value.docs[0].data();
          List<Map<String, dynamic>> groups =
              (userMap!['groups'] as List<dynamic>)
                  .map((group) => group as Map<String, dynamic>)
                  .toList();
          toBeAddedUser = BcUser(
            username: userMap!['username'],
            email: userMap!['email'],
            status: userMap!['status'],
            groups: groups,
          );
          _isLoading = false;
        });
      }
    });
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
            'Add Members',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // body
        body: _isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      // Search Box
                      Row(
                        children: [
                          Expanded(
                            child:
                                MySearchWidget(controller: _searchController),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: ElevatedButton(
                              onPressed: _onSearch,
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.black26,
                                  elevation: 0,
                                  shape: const BeveledRectangleBorder(),
                                  foregroundColor: Colors.black),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 18, bottom: 18),
                                child: Icon(
                                  Icons.search,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // create group button
                      MyButton(
                        onTap: () {
                          // for each user in added members add it to list of their groups
                          addGroupInfoToDb(groupChatroomId!, widget.groupName,
                                  currentUser!.getUsername(), addedMembers)
                              .then((_) {
                            // Handle success
                            // ignore: avoid_print
                            print('Group information added successfully!');
                          }).catchError((error) {
                            // Handle error
                            // ignore: avoid_print
                            print('Error adding group information: $error');
                          });

                          // generate group chat room id & go to group chat screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupChatScreen(
                                groupName: widget.groupName,
                                groupChatroomId: groupChatroomId!,
                                creatorOfGroup: currentUser!,
                              ),
                            ),
                          );
                        },
                        msg: 'Create Group',
                      ),

                      const SizedBox(height: 30),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Added Members',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      (userMap != null)
                          ? ((!_removed)
                              ? (Expanded(
                                  child: _addedMemberList(
                                    toBeAddedUser!,
                                    addedMembers,
                                  ),
                                ))
                              : (Expanded(
                                  child: buildAddedMemberList(addedMembers),
                                )))
                          : Container(),
                    ],
                  ),
                ),
              ));
  }

  bool _removed = false;

  bool _addMember(BcUser toBeAddedUser) {
    if (addedMembers.contains(toBeAddedUser)) {
      return false;
    }
    setState(() {
      addedMembers.add(toBeAddedUser);
    });
    return true;
  }

  void _removeMember(BcUser toBeRemovedUser) {
    _removed = true;
    setState(() {
      addedMembers.removeWhere((user) => user == toBeRemovedUser);
    });
    setState(() {});
  }

  Padding buildAddedMemberList(List<BcUser> addedMembers) {
    _removed = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        itemCount: addedMembers.length,
        itemBuilder: (context, index) {
          return AddUserTile(
            username: addedMembers[index].getUsername(),
            onPressed: () {
              _removeMember(addedMembers[index]);
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Padding _addedMemberList(BcUser toBeAddedUser, List<BcUser> addedMembers) {
    _addMember(toBeAddedUser);
    return buildAddedMemberList(addedMembers);
  }
}
