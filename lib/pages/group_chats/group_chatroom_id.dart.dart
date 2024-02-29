import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> createGroupChatRoomId() async {
  // Reference to the Firestore collection where group chat rooms are stored
  CollectionReference<Map<String, dynamic>> groupChatRooms =
      FirebaseFirestore.instance.collection('group_chatrooms');

  // Add a new document to the collection (Firestore will automatically generate a unique ID for the document)
  DocumentReference newGroupChatRoomRef = await groupChatRooms.add({
    'createdAt': Timestamp.now(),
    'members': [],
  });

  // Retrieve the auto-generated document ID
  String groupChatRoomId = newGroupChatRoomRef.id;

  return groupChatRoomId;
}
