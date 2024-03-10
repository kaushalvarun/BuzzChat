// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaveGroupButton extends StatefulWidget {
  final String groupId;
  final String currentUserId;
  const LeaveGroupButton({
    super.key,
    required this.groupId,
    required this.currentUserId,
  });

  @override
  State<LeaveGroupButton> createState() => _LeaveGroupButtonState();
}

class _LeaveGroupButtonState extends State<LeaveGroupButton> {
  // final _firestore = FirebaseFirestore.instance;
  // void _leaveGroup() async {
  //   // Get current user data
  //   final currentUserDataSnapshot =
  //       await _firestore.collection('users').doc(widget.currentUserId).get();

  //   if (currentUserDataSnapshot.exists) {
  //     Map<String, dynamic> currentUserData =
  //         currentUserDataSnapshot.data() as Map<String, dynamic>;

  //     // 1. Group members -= current user
  //     await _firestore
  //         .collection('group_chatrooms')
  //         .doc(widget.groupId)
  //         .update({
  //       'members': FieldValue.arrayRemove([currentUserData])
  //     });
  //   } else {
  //     // error
  //     print('An error has occured in fetching User data');
  //   }

  //   // Get current group data
  //   final currentGroupDataSnapshot = await _firestore
  //       .collection('group_chatrooms')
  //       .doc(widget.groupId)
  //       .get();

  //   if (currentGroupDataSnapshot.exists) {
  //     Map<String, dynamic> currentGroupData =
  //         currentGroupDataSnapshot.data() as Map<String, dynamic>;

  //     // 2. Remove this group from user.groups
  //     await _firestore.collection('users').doc(widget.currentUserId).update({
  //       'groups': FieldValue.arrayRemove([currentGroupData])
  //     });
  //   } else {
  //     // error
  //     print('An error has occured in fetching Group data');
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {}, //_leaveGroup,
      child: const Text(
        'Leave Group',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
