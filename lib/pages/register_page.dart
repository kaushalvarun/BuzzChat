import 'package:buzzchatv2/components/my_button.dart';
import 'package:buzzchatv2/components/square_tile.dart';
// import 'package:buzzchatv2/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function() onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // create user email and password
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showErrorMessage(context, 'Passwords don\'t match');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(context, e.code);
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
                  const Icon(
                    Icons.question_answer,
                    size: 100,
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // welcome
                  const Text(
                    'Welcome to our App!',
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

                  // confirm password
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Re-enter password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // sign up button
                  MyButton(
                    onTap: signUserUp,
                    msg: 'Sign Up',
                  ),

                  const SizedBox(height: 50),
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

                  const SizedBox(height: 30),

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

                  // not a member? register now
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
