import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/svg.dart';
import 'package:quiz_app_pilot/controllers/question_controller.dart';

import '../../../../constants.dart';
import 'progress_bar.dart';
import 'question_card.dart';

class Body extends StatefulWidget {
  final String level;

  const Body({super.key, required this.level});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
   late QuestionController _questionController;
 
  @override
  void setState(VoidCallback fn) {
    _questionController.questions;
    // TODO: implement setState
    super.setState(fn);
  }
@override
  void initState() {
    // TODO: implement initState
    
        _questionController = Get.put(QuestionController( widget.level));

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(level: widget.level,),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      text:
                          "Question ${_questionController.questionNumber.value}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: kSecondaryColor),
                      children: [
                        TextSpan(
                          text: "/5",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: kDefaultPadding),
              Expanded(
                  child: Obx((() => PageView.builder(
                        // Block swipe to next qn
                        physics: NeverScrollableScrollPhysics(),
                        controller: _questionController.pageController,
                        onPageChanged: _questionController.updateTheQnNum,
                        itemCount: _questionController.questions.length,
                        itemBuilder: (context, index) => QuestionCard(
                          level: widget.level,
                            question: _questionController.questions[index]),
                      )))),
            ],
          ),
        )
      ],
    );
  }
}
