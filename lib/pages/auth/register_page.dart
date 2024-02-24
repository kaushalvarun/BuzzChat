import 'package:buzzchatv2/components/general_components/my_button.dart';
import 'package:buzzchatv2/components/general_components/my_text_field.dart';
import 'package:buzzchatv2/components/general_components/square_tile.dart';
import 'package:buzzchatv2/util/error_msg_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function() onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // create user with email and password
    try {
      if (_passwordController.text == _confirmPasswordController.text) {
        Navigator.pop(context);
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.toLowerCase(),
          password: _passwordController.text,
        );

        // grab newly created user info
        // ! signifies that user will not be null and will always exist
        final user = FirebaseAuth.instance.currentUser!;

        // Adding additional user data to firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': _usernameController.text,
          'email': _emailController.text,
          'status': 'Unavailable',
        });
      } else {
        Navigator.pop(context);
        showErrorMessage(context, 'Passwords don\'t match');
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, e.code);
    }
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
                    height: 20,
                  ),

                  // welcome
                  const Text(
                    'Welcome to our App!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // email field
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Enter email',
                    obscureText: false,
                  ),

                  // username field
                  MyTextField(
                    controller: _usernameController,
                    hintText: 'Enter username',
                    obscureText: false,
                  ),

                  // password field
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Enter password',
                    obscureText: true,
                  ),

                  // confirm password field
                  MyTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Re-enter password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 15),

                  // sign up button
                  MyButton(
                    onTap: signUserUp,
                    msg: 'Sign Up',
                  ),

                  const SizedBox(height: 20),

                  // already a member, sign in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a member?',
                          style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text('Login here',
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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

                  // Sign in with Google and Apple
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SquareTile(
                      imagePath: 'lib/images/google.png',
                      onTap: () => {}, //AuthService().signInWithGoogle(),
                    ),
                    const SizedBox(width: 20),
                    SquareTile(
                      imagePath: 'lib/images/apple.png',
                      onTap: () => {}, //AuthService().signInWithGoogle(),
                    ),
                  ]),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ));
  }
}
