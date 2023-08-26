import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app_pilot/admin.dart';
import 'package:quiz_app_pilot/constants.dart';
import 'package:quiz_app_pilot/home.dart';
import 'package:quiz_app_pilot/screens/welcome/score/display_score.dart';
import 'package:quiz_app_pilot/screens/welcome/welcome_screen.dart';
import 'package:quiz_app_pilot/start.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      print("Sign in successful");

      if (userCredential.user?.uid == "MHzAJtqQi1Ups2fXHnXqeby6CFF3") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AdminScreen())); // Replace with actual route
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MyStatelessWidget()));
      }

      // Navigate to the next screen after successful login
      // Example: Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print("Sign in failed: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1C2341),
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Color(0xFF1C2341),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFF1C2341),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Lottie.asset('assets/icons/login.json'),
                      ),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1C2341),
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1C2341),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.0),
                      InkWell(
                        onTap: () => _signIn(context),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text(
                            "Sign In",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
