import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final username;
  UserCard({
    super.key,
    required this.username,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    final username = widget.username;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,

      // Row for pfp, Name latest message, time
      child: Row(
        children: [
          // user profile pic
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                'https://voluget.com/assets/images/rateing-profile.png'),
          ),

          // sizedbox
          const SizedBox(width: 15),

          // name and latest message
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Latest Message',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(width: 50),

          // timestamp and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '16:35',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CircleAvatar(
                  radius: 7,
                  backgroundColor: Color.fromRGBO(0, 193, 167, 1),
                  child: Text(
                    '2',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
