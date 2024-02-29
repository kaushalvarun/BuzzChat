import 'package:buzzchatv2/components/group_chat/add_user_tile.dart';
import 'package:buzzchatv2/components/home_screen/search_widget.dart';
import 'package:buzzchatv2/pages/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // is loading variable to keep track when data is being fetched
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  // map of users recieved from onSearch
  Map<String, dynamic>? userMap;

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
        });
      } else {
        setState(() {
          userMap = value.docs[0].data();
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
            : Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    // Search Box
                    Row(
                      children: [
                        Expanded(
                          child: MySearchWidget(controller: _searchController),
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
                        ? AddUserTile(
                            username: userMap!['username']!,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupChatScreen(
                                    groupName: widget.groupName,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(),
                  ],
                ),
              ));
  }
}
