// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Get connection to firestore & auth
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final FirebaseAuth _fireauth = FirebaseAuth.instance;

// Store the chatroom ID
String? chatroomIdString;

Future<String> getGroupChatRoomId() async {
  // final currentUser = _fireauth.currentUser!;
  // final userData =
  //     await _firestore.collection('users').doc(currentUser.uid).get();
  return "tempGroupChatRoomID";
}
