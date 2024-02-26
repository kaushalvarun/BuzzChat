import 'package:buzzchatv2/components/home_screen/search_widget.dart';
import 'package:buzzchatv2/components/home_screen/user_card.dart';
import 'package:buzzchatv2/pages/chat/chat_screen.dart';
import 'package:buzzchatv2/pages/group_chats/display_groups.dart';
import 'package:buzzchatv2/util/sign_out.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Search bar functionality
  bool _isLoading = false;

  // Search text
  final TextEditingController _searchController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // local variable to store  userMap fetched from firestore
  Map<String, dynamic>? userMap;

  void onSearch() async {
    setState(() {
      _isLoading = true;
    });

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

  // current user
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    // UI
    return Scaffold(
      // Appbar: 'Chats' and LogOut Button
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chats",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // go to all groups page
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DisplayGroups()));
              },
              icon: const Icon(Icons.group)),

          // log out
          const IconButton(
            onPressed: signout,
            icon: Icon(Icons.logout),
            iconSize: 25,
          ),
        ],
      ),

      // Body: Search and List off chats
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
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // search box
                  MySearchWidget(controller: _searchController),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: OutlinedButton(
                      onPressed: onSearch,
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                      child: const Text('Search 🔎'),
                    ),
                  ),

                  const SizedBox(height: 30),
                  // user chat card
                  (userMap != null)
                      ? UserCard(
                          username: userMap!['username']!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    userMap: userMap,
                                    username: userMap!['username']!),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                              'No Recent Chats Found.\nStart a new conversation by searching for a user.'),
                        )),
                ],
              ),
            ),
    );
  }
}
