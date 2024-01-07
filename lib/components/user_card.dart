import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 251, 254, 100),
          border: Border.all(
            color: const Color.fromARGB(255, 241, 213, 245), // Set border color
            width: 0.5, // Set border width
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://voluget.com/assets/images/rateing-profile.png'),
            ),
          ],
        ),
      ),
    );
  }
}
