import 'package:buzz_chat/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
BcUser? currentUser;

Future<BcUser?> fetchCurrentUserDetails(String email) async {
  await _firestore
      .collection('users')
      .where('email', isEqualTo: email)
      .get()
      .then((value) {
    if (value.docs.isEmpty) {
      currentUser = null;
    } else {
      Map<String, dynamic> userMap = value.docs[0].data();
      currentUser = BcUser.fromJson(userMap);
    }
  });
  return currentUser;
}
