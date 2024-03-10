import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> generateChatroomId() async {
  // Generate a unique chatroom ID
  String chatroomId =
      FirebaseFirestore.instance.collection('group_chatrooms').doc().id;
  return chatroomId;
}

Future<void> addGroupInfoToDb(String chatroomId, String groupName,
    String creatorOfGroup, List<String> members) async {
  // add group info to document in 'group_chatrooms'
  Map<String, dynamic> groupData = {
    'groupName': groupName,
    'creatorOfGroup': creatorOfGroup,
    'members': members,
    'groupChatRoomId': chatroomId,
  };

  // add group info to db
  try {
    await _firestore
        .collection('group_chatrooms')
        .doc(chatroomId)
        .set(groupData);
  } catch (e) {
    // ignore: avoid_print
    print('Error setting group data, Error: $e');
  }

  // update 'group_ids' for each member of this group, adding this group
  for (String memberEmail in members) {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: memberEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Get user document ID
        String userDocId = userSnapshot.docs[0].id;
        // Update user's 'groups' field, and add current group
        await _firestore.collection('users').doc(userDocId).update({
          'groups': FieldValue.arrayUnion(
              [chatroomId]) // Add current groupid to 'groups'
        });
        // ignore: avoid_print
        print('Updated user groups');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error updating user groups: $e');
    }
  }
}
