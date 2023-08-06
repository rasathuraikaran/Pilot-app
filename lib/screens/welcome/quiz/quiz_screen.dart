import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_pilot/controllers/question_controller.dart';

import 'components/body.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuestionController _controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = Get.put(QuestionController());
      _controller.questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _controller.nextQuestion,
            child: Text("Skip"),
          ),
        ],
      ),
      body: Body(),
    );
  }
}
