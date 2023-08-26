import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app_pilot/constants.dart';
import 'package:quiz_app_pilot/controllers/question_controller.dart';
import 'package:quiz_app_pilot/start.dart';

class ScoreScreen extends StatelessWidget {
  final String level;

  const ScoreScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Text('User not logged in');
    }

    QuestionController _qnController = Get.put(QuestionController(level));

    int userScore = _qnController.numOfCorrectAns * 20;

    DatabaseReference _userScoreRef =
        FirebaseDatabase.instance.reference().child('users').child(user.uid);
    DatabaseReference newScoreRef = _userScoreRef.child('scores').push();
    newScoreRef.set(userScore);

    // Load these scores from your _fetchUserData function

    String message = "";
    if (userScore >= 100) {
      message = 'Great job! You nailed it!';
    } else if (userScore >= 80) {
      message = 'Well done! You are on the right track.';
    } else if (userScore >= 60) {
      message = 'Good effort! Keep practicing.';
    } else if (userScore >= 40) {
      message = 'You can do better. Review the material';
    } else {
      message = 'You need more practice. Study the material thoroughly.';
    }

    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyStatelessWidget()),
        );
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        body: Container(
          color: Color(0xFF1C2341),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
              Column(
                children: [
                  Spacer(flex: 3),
                  Text(
                    "Score",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: kSecondaryColor),
                  ),
                  Spacer(),
                  Text(
                    "${_qnController.numOfCorrectAns * 20}/100",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: kSecondaryColor),
                  ),
                  if (message == "Keep it up!")
                    Container(
                      child: Lottie.asset('assets/icons/champ.json'),
                    )
                  else
                    Container(
                      child: Lottie.asset('assets/icons/think.json'),
                    ),
                  Text(
                    message,
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(flex: 3),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
