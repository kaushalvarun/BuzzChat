import 'package:buzz_chat/components/general_components/my_button.dart';
import 'package:buzz_chat/components/group_chat/add_user_tile.dart';
import 'package:buzz_chat/components/home_screen/search_widget.dart';
import 'package:buzz_chat/pages/group_chats/group_chat_screen.dart';
import 'package:buzz_chat/pages/group_chats/group_chatroom_id.dart.dart';
import 'package:buzz_chat/user.dart';
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

  Future<void> _getUserFromEmail() async {
    currentUser = await userfromEmail(cUser.email!);
    setState(() {});
  }

  // added Members
  List<String> addedMembers = [];

  @override
  void initState() {
    super.initState();
    // add current user email to addedmembers
    addedMembers.add(cUser.email!);
    // to get chatroomId
    _getUserFromEmail();
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
    try {
      await _firestore
          .collection('users')
          .where('email', isEqualTo: _searchController.text.toLowerCase())
          .get()
          .then((value) {
        // user details not found
        if (value.docs.isEmpty) {
          setState(() {
            _isLoading = false;
            userMap = null;
            toBeAddedUser = null;
          });
        } else {
          setState(() {
            userMap = value.docs[0].data();
            toBeAddedUser = BcUser.fromJson(userMap!);
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error searching, Error:$e');
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
                        msg: 'Create Group',
                        onTap: () async {
                          try {
                            // 1. for each user in added members add it to list of their groups
                            // 2. also store this group info in db
                            // asynchronous code handled with await
                            if (groupChatroomId == null) {
                              // ignore: avoid_print
                              print('groupChatroomId is null');
                            }

                            if (currentUser == null) {
                              // ignore: avoid_print
                              print('currentUser is null');
                            }

                            await addGroupInfoToDb(
                              groupChatroomId!,
                              widget.groupName,
                              currentUser!.getUsername(),
                              addedMembers,
                            );
                            // Success case
                            // ignore: avoid_print
                            print('Group information added successfully!');

                            // generate group chat room id & go to group chat screen
                            // Check if the context is still mounted before navigating
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupChatScreen(
                                    groupName: widget.groupName,
                                    groupChatroomId: groupChatroomId!,
                                    creatorOfGroup: currentUser!.getUsername(),
                                    groupMembers: addedMembers,
                                  ),
                                ),
                              );
                            }
                          } catch (error) {
                            // Handle error
                            // ignore: avoid_print
                            print('Error adding group information: $error');
                          }
                        },
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

                      // added members list view
                      (userMap != null)
                          ? ((!_removed)
                              ? (Expanded(
                                  child: FutureBuilder<Padding>(
                                  future: _addedMemberList(
                                    toBeAddedUser!,
                                    addedMembers,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      if (snapshot.hasData) {
                                        return snapshot.data!;
                                      } else {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                    }
                                  },
                                )))
                              : (Expanded(
                                  child: FutureBuilder<Padding>(
                                    future: buildAddedMemberList(addedMembers),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        if (snapshot.hasData) {
                                          return snapshot.data!;
                                        } else {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                      }
                                    },
                                  ),
                                )))
                          : Container(),
                    ],
                  ),
                ),
              ));
  }

  bool _removed = false;

  bool _addMember(BcUser toBeAddedUser) {
    if (addedMembers.contains(toBeAddedUser.getEmail())) {
      return false;
    }
    setState(() {
      addedMembers.add(toBeAddedUser.getEmail());
    });
    return true;
  }

  void _removeMember(BcUser toBeRemovedUser) {
    _removed = true;
    setState(() {
      addedMembers.removeWhere((user) => user == toBeRemovedUser.getEmail());
    });
    setState(() {});
  }

  Future<Padding> buildAddedMemberList(List<String> addedMembersEmail) async {
    List<BcUser> addedMembers = [];
    for (int i = 0; i < addedMembersEmail.length; i++) {
      await userfromEmail(addedMembersEmail[i]).then((value) {
        addedMembers.add(value!);
      });
    }
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

  Future<Padding> _addedMemberList(
      BcUser toBeAddedUser, List<String> addedMembersEmail) async {
    _addMember(toBeAddedUser);
    return await buildAddedMemberList(addedMembersEmail);
  }
}
