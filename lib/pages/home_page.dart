import 'package:buzzchatv2/components/search_widget.dart';
import 'package:buzzchatv2/components/user_card.dart';
import 'package:buzzchatv2/pages/chat_screen.dart';
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
  bool isLoading = false;

  // Search text
  final TextEditingController _searchController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // userMap
  Map<String, dynamic>? userMap;
  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where('email', isEqualTo: _searchController.text.toLowerCase())
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        setState(() {
          isLoading = false;
          userMap = null;
        });
      } else {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
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
        actions: const [
          IconButton(
            onPressed: signout,
            icon: Icon(Icons.logout),
            iconSize: 25,
          ),
        ],
      ),

      // Body: Search and List off chats
      body: isLoading
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
                  // Chats
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
