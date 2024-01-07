// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   // Google sign in
//   signInWithGoogle() async {
//     // begin interactive sign in process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//     // obtain auth details from request
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;

//     // create a new credential for user
//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );

//     // finally, lets sign in
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
// }

// when filling remember to secure api key, reversed client id etc which are in googleplist.info