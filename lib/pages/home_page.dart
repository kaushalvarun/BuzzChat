import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import '../components/user_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final usersList = ["user1", "user2", "user3"]; // stores list of all users
  void signout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.amber[200],
        actions: [
          IconButton(
            onPressed: signout,
            icon: const Icon(Icons.logout),
            iconSize: 25,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              "Welcome " + user.email! + "!",
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: usersList.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return UserCard();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
