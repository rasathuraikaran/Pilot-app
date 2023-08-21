import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:quiz_app_pilot/constants.dart';
import 'package:quiz_app_pilot/controllers/question_controller.dart';
import 'package:quiz_app_pilot/screens/welcome/quiz/quiz_screen.dart';

class QuizLevelSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C2341),
      appBar: AppBar(
        backgroundColor: Color(0xFF1C2341),
        title: Text('Select Quiz Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // Navigate to the quiz page with the selected level
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(level: 'Easy'),
                  ),
                );
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
                  "Easy",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Navigate to the quiz page with the selected level
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(level: 'Medium'),
                  ),
                );
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
                  "Medium",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Navigate to the quiz page with the selected level
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(level: 'Hard'),
                  ),
                );
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
                  "Hard",
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
    );
  }
}
