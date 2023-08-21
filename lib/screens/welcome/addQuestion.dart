import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quiz_app_pilot/constants.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  TextEditingController questionController = TextEditingController();
  TextEditingController optionsController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  String predictedLevel = "";

  Future<void> classifyQuestion() async {
    final response = await http.post(
      Uri.parse(
          'http://13.48.136.131:5000/predict_level'), // Replace with your backend endpoint
      body: json.encode({
        'question': questionController.text,
        'options': optionsController.text.split('\n'),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        predictedLevel = data['predicted_level'];
        print(predictedLevel);
      });
    }
    addQuestionToDatabase();
  }

  Future<void> addQuestionToDatabase() async {
    int randomId =
        DateTime.now().millisecondsSinceEpoch; // Generate a random ID
    List<String> optionsList = optionsController.text.split('\n');

    // Create an options object with numerical keys
    Map<String, dynamic> optionsObject = {};
    for (int i = 0; i < optionsList.length; i++) {
      optionsObject[i.toString()] = optionsList[i];
    }

    // Create the question data structure
    Map<String, dynamic> questionData = {
      'answer_index':
          answerController.text, // You need to set this value appropriately
      'id': randomId,
      'level': predictedLevel,
      'options': optionsObject,
      'question': questionController.text,
    };
    final DatabaseReference database = FirebaseDatabase.instance.reference();

    await database
        .child('physics_mcqs')
        .child(randomId.toString())
        .set(questionData);

    // Clear text fields after successful submission
    questionController.clear();
    optionsController.clear();
    answerController.clear();

    setState(() {
      predictedLevel = ""; // Reset predictedLevel after submitting
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
        backgroundColor: Color(0xFF1C2341),
      ),
      backgroundColor: Color(0xFF1C2341),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextFormField(
                controller: questionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF1C2341),
                  hintText: "Question",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                controller: optionsController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF1C2341),
                  hintText: "Options (one per line)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                maxLines: null,
              ),
              SizedBox(height: 30.0),
              TextFormField(
                controller: answerController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF1C2341),
                  hintText: "Answer",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                maxLines: null,
              ),
              SizedBox(height: 200.0),
              InkWell(
                onTap: () async {
                  await classifyQuestion();
                  // Now you can store the data in the Realtime Database
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
                    "Submit",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Predicted Level: $predictedLevel'),
            ],
          ),
        ),
      ),
    );
  }
}
