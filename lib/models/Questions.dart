import 'package:firebase_database/firebase_database.dart';

class Question {
  final int id, answer;
  final String question;
  final List<String> options;

  Question(
      {required this.id,
      required this.question,
      required this.answer,
    
      required this.options});
}


 
 
