import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app_pilot/constants.dart';
import 'package:quiz_app_pilot/screens/welcome/welcome_screen.dart';
import 'package:quiz_app_pilot/start.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF1C2341),
          title: Text('SignIn'),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFF1C2341),
            child: Stack(
              children: [
                SvgPicture.asset(
                  "assets/icons/bg.svg",
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //2/6
                      Container(
                        child: Lottie.asset('assets/icons/signin.json'),
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

                      SizedBox(height: 16),
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

                      SizedBox(height: 32),

                      InkWell(
                        onTap: _onSignInButtonPressed,
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
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _onSignInButtonPressed() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      setState(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyStatelessWidget()));
      });

      print("dei succes da");
    } on FirebaseAuthException catch (e) {
      print("podadunda");
    }
    String email = _emailController.text;
    String password = _passwordController.text;

    // You can add authentication logic here to sign in the user
    // For demonstration purposes, we'll just print the email and password for now.
    print('Email: $email');
    print('Password: $password');
  }
}
