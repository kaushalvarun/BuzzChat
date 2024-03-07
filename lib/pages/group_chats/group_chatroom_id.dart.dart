// import 'package:buzz_chat/group.dart';
import 'package:buzz_chat/group.dart';
import 'package:buzz_chat/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> generateChatroomId() async {
  // Generate a unique chatroom ID
  String chatroomId =
      FirebaseFirestore.instance.collection('group_chatrooms').doc().id;
  return chatroomId;
}

Future<void> addGroupInfoToDb(String chatroomId, String groupName,
    String creatorOfGroup, List<BcUser> members) async {
  // Convert each BcUser object into a map to store in db
  List<Map<String, dynamic>> memberData =
      members.map((member) => member.toMap()).toList();

  // add group info to document in 'group_chatrooms'
  Map<String, dynamic> groupData = {
    'groupName': groupName,
    'creatorOfGroup': creatorOfGroup,
    'members': memberData,
    'groupChatRoomId': chatroomId,
  };

  await _firestore.collection('group_chatrooms').doc(chatroomId).set(groupData);

  // update 'group_ids' for each member of this group, adding this group
  for (BcUser member in members) {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: member.getEmail())
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Get user document ID
        String userId = userSnapshot.docs[0].id;
        // Update user's 'groups' field
        await _firestore.collection('users').doc(userId).update({
          'groups': FieldValue.arrayUnion(
              [groupData]) // Add current group to 'groups'
        });
        // print('Updated user groups');
      }
    } catch (e) {
      // print('Error updating user groups: $e');
    }
  }
}

Future<List<Group>> readGroupDataFromDb(BcUser currentUser) async {
  List<Map<String, dynamic>> groupsInMap = [];
  await _firestore
      .collection('users')
      .where('email', isEqualTo: currentUser.getEmail())
      .get()
      .then((value) {
    if (value.docs.isEmpty) {
      // print('User doesn\'t exist');
    } else {
      Map<String, dynamic> userMap = value.docs[0].data();
      groupsInMap = List<Map<String, dynamic>>.from(userMap['groups']);
    }
  });
  return getListOfGroupFromListOfMap(groupsInMap);
}
