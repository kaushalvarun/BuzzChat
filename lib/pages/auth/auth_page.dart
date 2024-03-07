import 'package:buzz_chat/pages/auth/login_or_register_page.dart';
import 'package:buzz_chat/pages/home_page.dart';
import 'package:buzz_chat/pages/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // checking if user is logged in or not
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // if firebase waiting show splash screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        // user logged in
        if (snapshot.hasData) {
          return const HomePage();
        }
        // user not logged in
        else {
          return const LoginOrRegister();
        }
      },
    );
  }
}
