import 'package:firebase_auth/firebase_auth.dart';

void signout() {
  FirebaseAuth.instance.signOut();
}
