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
      color: Colors.white,

      // user card with divider
      child: Column(
        children: [
          // user card row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // row for pfp, name, message
              Row(
                children: [
                  // user profile pic
                  CircleAvatar(
                    radius: 32,
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
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Latest Message',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // timestamp and status
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // timestamp
                    Text(
                      '16:35',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // unread message count
                    CircleAvatar(
                        radius: 10,
                        backgroundColor: Color.fromRGBO(0, 193, 167, 1),
                        child: Text(
                          '2',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
            ],
          ),

          // Divider
          const Divider(
            indent: 70,
            height: 20,
          )
        ],
      ),
    );
  }
}
