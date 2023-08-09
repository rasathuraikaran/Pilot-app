import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserScoresPage extends StatefulWidget {
  @override
  _UserScoresPageState createState() => _UserScoresPageState();
}

class _UserScoresPageState extends State<UserScoresPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userScoreRef =
      FirebaseDatabase.instance.reference().child('users');

  User? _user;
  List<int> _scores = [];

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  Future<void> _fetchUserData() async {
    _user = _auth.currentUser;
    print("start karan ");
    if (_user != null) {
      _userScoreRef
          .child(_user!.uid)
          .child('scores')
          .once()
          .then((DatabaseEvent event) {
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.value != null) {
          print("object snapshoht");
          print(snapshot.value);
          Map<dynamic, dynamic> scoresMap =
              snapshot.value as Map<dynamic, dynamic>;
          List<int> scores = scoresMap.values.cast<int>().toList();
          print("karan list");
          print(scores);
          setState(() {
            _scores = scores;
          });
        }
      });
    } else {
      print("user is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Scores'),
          backgroundColor: Color(0xFF1C2341),
        ),
        body: Container(
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/icons/bg.svg",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Center(
                child: _user != null
                    ? _scores.isNotEmpty
                        ? ListView.builder(
                            itemCount: _scores.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Card(
                                  color: Color(0xFF1C2341),
                                  elevation: 4,
                                  child: ListTile(
                                    title: Text(
                                      'Score: ${_scores[index]}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    trailing: Icon(Icons
                                        .star), // You can replace this with your own icon
                                  ),
                                ),
                              );
                            },
                          )
                        : Text('No scores available.')
                    : Text('User not logged in.'),
              ),
            ],
          ),
        ));
  }
}
