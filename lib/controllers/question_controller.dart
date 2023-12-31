import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:quiz_app_pilot/models/Questions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quiz_app_pilot/screens/welcome/score/score_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// We use get package for our state management

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  // Lets animated our progress bar
  final String level;
  late AnimationController _animationController;
  late Animation _animation;

  QuestionController(this.level);
  // so that we can access our animation outside
  Animation get animation => this._animation;

  late PageController _pageController;
  RxList _questions = [].obs;

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('physics_mcqs');
  PageController get pageController => this._pageController;

  RxList get questions => this._questions;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  int _correctAns = 0;
  int get correctAns => this._correctAns;

  late int _selectedAns;
  int get selectedAns => this._selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => this._numOfCorrectAns;

 

  // called immediately after the widget is allocated memory
  @override
  void onInit() async {
    print(_questions);
    _pageController = PageController();
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    _animationController =
        AnimationController(duration: Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // update like setState
        update();
      });

    // start our animation
    _animationController.forward().whenComplete(nextQuestion);

    // Once 60s is completed go to the next qn
    await fetchQuestionsByLevel(level);


    print(_questions);
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    // Clear the questions list

    _animationController.dispose();
    _pageController.dispose();
  }

 

  Future<void> fetchQuestions1() async {
    final DatabaseReference database = FirebaseDatabase.instance.reference();

    database.child('physics_mcqs').once().then((DatabaseEvent event) {
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
        _questions.shuffle();
      }
    }).catchError((error) {
      // Handle error
      print("Error fetching questions: $error");
    });
  }

  void clearList() {
    _questions.clear();
  }

  Future<void> fetchQuestionsByLevel(String level) async {
    final DatabaseReference database = FirebaseDatabase.instance.reference();

    database.child('physics_mcqs').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, questionData) {
          String questionLevel = questionData['level'];

          if (questionLevel == level) {
            _questions.add(Question(
              id: questionData['id'],
              question: questionData['question'],
              options: List<String>.from(questionData['options']),
              answer: questionData['answer_index'],
            ));
          }
        });

        _questions.shuffle();
        // Now you can do something with the filtered and shuffled questions.
      }
    }).catchError((error) {
      // Handle error
      print("Error fetching questions: $error");
    });
  }

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) {
      _numOfCorrectAns++;

      print(numOfCorrectAns);
    }
    ;

    // It will stop the counter
    _animationController.stop();
    update();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber.value != 5) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(nextQuestion);
    } else {
  
      print(numOfCorrectAns);
      Get.to(ScoreScreen(
        level: level,
      ));

      // Get package provide us simple way to naviigate another page
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }
}
