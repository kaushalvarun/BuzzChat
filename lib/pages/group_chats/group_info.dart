import 'package:buzz_chat/components/general_components/photo_container.dart';
import 'package:buzz_chat/group.dart';
import 'package:buzz_chat/user.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatelessWidget {
  final Group groupData;
  const GroupInfo({
    super.key,
    required this.groupData,
  });

  @override
  Widget build(BuildContext context) {
    final List<BcUser> members = groupData.getMembers();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Group Info',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Group Photo, Name, and members
          Center(
            child: Column(
              children: [
                // photo
                const PhotoContainer(
                  width: 120,
                ),

                // name
                Text(
                  groupData.getGroupName(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

                // members text
                Text(
                  'Group : ${members.length} members',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Members row
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${members.length} Members',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Members list
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 25),
                      title: Text(
                        members[index].getUsername(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        members[index].getEmail(),
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Divider(
                      indent: 25,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
