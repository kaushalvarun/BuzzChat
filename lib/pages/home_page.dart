import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/user_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // stores list of all users
  final usersList = ["User 1", "User 2", "User 3"];

  void signout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          margin: const EdgeInsets.only(left: 20),
          child: const Text(
            "Chats",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: signout,
            icon: const Icon(Icons.logout),
            iconSize: 25,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 28),
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome user
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                "Welcome " + user.email! + "!",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),

            // search

            // stories

            // Chats

            Expanded(
              child: ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (BuildContext context, int index) {
                  return UserCard(username: usersList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
