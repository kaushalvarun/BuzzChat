import 'package:buzzchatv2/components/my_button.dart';
import 'package:buzzchatv2/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // terxt editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // print(e.code);
      // WRONG username
      if (e.code == "invalid-email") {
        showErrorMessage(context, 'Wrong Username');
      }
      // WRONG password
      else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        showErrorMessage(context, 'Wrong Password');
      }
    }
  }

  void showErrorMessage(BuildContext context, String errorMsg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.amber[200],
          title: Text(errorMsg),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[50], // bg color for login page
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  // logo
                  Image.asset(
                    'lib/images/buzzchatLogo.jpeg',
                    height: 175,
                    width: 175,
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // welcome back
                  const Text(
                    'Welcome back, you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // username
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Enter username',
                    obscureText: false,
                  ),

                  // password
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Enter password',
                    obscureText: true,
                  ),

                  // forgot password
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: signUserIn,
                    msg: 'Sign In',
                  ),

                  const SizedBox(height: 25),

                  // or continue with
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 10),

                  // Sign in with Google and Apple
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SquareTile(
                      imagePath: 'lib/images/google.png',
                      onTap: () => {}, //AuthService().signInWithGoogle(),
                    ),
                    SizedBox(width: 20),
                    SquareTile(
                        imagePath: 'lib/images/apple.png',
                        onTap: () => {} //AuthService().signInWithGoogle(),
                        ),
                  ]),
                  // const SizedBox(height: 10),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?',
                          style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text('Register Now',
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
