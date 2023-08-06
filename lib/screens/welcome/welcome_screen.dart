import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app_pilot/models/Questions.dart';
import 'package:quiz_app_pilot/screens/welcome/quiz/quiz_screen.dart';

import '../../constants.dart';
import 'package:firebase_database/firebase_database.dart';

class WelcomeScreen extends StatelessWidget {
  List<Question> _questions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 2), //2/6
                  Text(
                    "Let's Play Quiz,",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text("Best of luck"),
                  Spacer(), // 1/6

                  Spacer(), // 1/6
                  InkWell(
                   
                     onTap: () => Get.to(QuizScreen()),
                    // Pass contex,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Lets Start Quiz",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(flex: 2), // it will take 2/6 spaces
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchQuestions() async {
    final DatabaseReference database = FirebaseDatabase.instance.reference();
    print("karan is ");
    DataSnapshot snapshot =
        await database.child('QuestionsList').once() as DataSnapshot;

    if (snapshot.value != null && snapshot.value is Map) {
      print("karan is mass");

      print(snapshot.value);
      print("karan is thamamass");

      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    }
  }

  Future<void> fetchQuestions1() async {
    final DatabaseReference database = FirebaseDatabase.instance.reference();

    database.child('QuestionsList').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, questionData) {
          _questions.add(Question(
            id: questionData['id'],
            question: questionData['question'],
            options: List<String>.from(questionData['options']),
            answer: questionData['answer_index'],
          ));
        });

        print(_questions);
      }
    }).catchError((error) {
      // Handle error
      print("Error fetching questions: $error");
    });
  }

  void addSampleData() {
    final DatabaseReference database = FirebaseDatabase.instance.reference();

    List<Map<String, dynamic>> sampleData = [
      {
        "id": 5,
        "question":
            "Which of the following is a fundamental force of nature responsible for radioactivity and nuclear reactions?",
        "options": [
          "Gravitational force",
          "Electromagnetic force",
          "Weak nuclear force",
          "Strong nuclear force"
        ],
        "answer_index": 3
      },
      {
        "id": 6,
        "question": "What is the SI unit of electric current?",
        "options": ["Volt", "Ampere", "Ohm", "Watt"],
        "answer_index": 1
      },
      {
        "id": 7,
        "question":
            "Which scientist is known for his laws of planetary motion?",
        "options": [
          "Isaac Newton",
          "Albert Einstein",
          "Galileo Galilei",
          "Johannes Kepler"
        ],
        "answer_index": 3
      },
      {
        "id": 8,
        "question":
            "What is the phenomenon where light waves change direction as they pass from one medium to another?",
        "options": ["Diffraction", "Refraction", "Reflection", "Interference"],
        "answer_index": 1
      },
      {
        "id": 9,
        "question": "Which of these particles has a positive charge?",
        "options": ["Electron", "Neutron", "Proton", "Photon"],
        "answer_index": 2
      },
      {
        "id": 10,
        "question":
            "The process of a substance changing directly from a solid to a gas is called:",
        "options": ["Melting", "Vaporization", "Condensation", "Sublimation"],
        "answer_index": 3
      },
    ];

    for (var data in sampleData) {
      database.child('QuestionsList').push().set(data);
    }
  }
}
