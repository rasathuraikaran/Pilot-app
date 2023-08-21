import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app_pilot/caterccory.dart';
import 'package:quiz_app_pilot/constants.dart';
import 'package:quiz_app_pilot/home.dart';
import 'package:quiz_app_pilot/newwelcomeScreen.dart';
import 'package:quiz_app_pilot/screens/welcome/score/display_score.dart';

class MyStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * 1,
            decoration: BoxDecoration(
              color: Color(0xFF1C2341),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "One day I will become a \nPilot",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryCard(
                          title: "Quiz",
                          svgSrc: "assets/icons/quiz.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "Your Scores",
                          svgSrc: "assets/icons/score.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserScoresPage()),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "User info",
                          svgSrc: "assets/icons/user.svg",
                          press: () {},
                        ),
                        CategoryCard(
                          title: "About Us",
                          svgSrc: "assets/icons/about.svg",
                          press: () {},
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewWelcomeScreen()),
                      ); // Go back to the previous screen after logout
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Logout",
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
          )
        ],
      ),
    );
  }
}
