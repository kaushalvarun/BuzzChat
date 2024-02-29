import 'package:buzzchatv2/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
BcUser? currentUser;

Future<BcUser?> fetchCurrentUserDetails(User? user) async {
  await _firestore
      .collection('users')
      .where('email', isEqualTo: user!.email)
      .get()
      .then((value) {
    if (value.docs.isEmpty) {
      currentUser = null;
    } else {
      Map<String, dynamic> userMap = value.docs[0].data();

      currentUser = BcUser(
          username: userMap['username'],
          email: userMap['email'],
          status: userMap['status'],
          groups: userMap['groups'],
          recentChats: userMap['recentChats']);
    }
  });
  return currentUser;
}
