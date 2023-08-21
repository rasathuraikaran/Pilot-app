import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_pilot/controllers/question_controller.dart';
import '../../../../constants.dart';
import '../../../../models/Questions.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.question,
    required this.level,
  }) : super(key: key);

  final Question question;
  final String level;

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController(level));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: SingleChildScrollView(
        // Add SingleChildScrollView here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: kBlackColor),
            ),
            SizedBox(height: kDefaultPadding / 2),
            ...List.generate(
              question.options.length,
              (index) => Option(
                level: level,
                index: index,
                text: question.options[index],
                press: () => _controller.checkAns(question, index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
