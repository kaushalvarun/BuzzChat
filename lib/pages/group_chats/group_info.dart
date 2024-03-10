import 'package:buzz_chat/components/general_components/photo_container.dart';
import 'package:buzz_chat/group.dart';
import 'package:buzz_chat/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final Group groupData;
  const GroupInfo({
    super.key,
    required this.groupData,
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<BcUser>? members;

  Future<void> _fetchMembers(List<String> memberEmails) async {
    List<BcUser> membersLoc = [];
    for (String memberEmail in memberEmails) {
      try {
        await _firestore
            .collection('users')
            .where('email', isEqualTo: memberEmail)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            Map<String, dynamic> userMap = value.docs[0].data();
            membersLoc.add(BcUser.fromJson(userMap));
          }
        });
        setState(() {
          members = membersLoc;
        });
      } catch (e) {
        setState(() {
          members = null;
        });
        // ignore: avoid_print
        print('Error fetching user details: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMembers(widget.groupData.getMembers());
  }

  @override
  Widget build(BuildContext context) {
    // showing loading indicator while fetching data
    if (members == null) {
      return const CircularProgressIndicator();
    } else if (members!.isEmpty) {
      return const Text('No members found');
    }
    // data fetched and not empty
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
                  widget.groupData.getGroupName(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

                // members text
                Text(
                  'Group : ${members!.length} members',
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
                  '${members!.length} Members',
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
              itemCount: members!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 25),
                      title: Text(
                        members![index].getUsername(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        members![index].getEmail(),
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
