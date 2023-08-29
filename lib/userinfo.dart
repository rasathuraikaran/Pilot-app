import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:quiz_app_pilot/newwelcomeScreen.dart';
import 'package:quiz_app_pilot/start.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var uid;
  bool showPassword = false;
  late String fname = "";
  late String lname = "";
  late String enumber = "";

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Future<void> _start(String uid) async {
    final url = Uri.parse(
        'https://pilotquizapp-default-rtdb.firebaseio.com/usersDetails.json');

    final response = await http.get(url);
    final extractData = json.decode(response.body) as Map<String, dynamic>;

    extractData.forEach(
      (key, value) async {
        if (uid == value['uid']) {
          fname = value['FirstName'];
          lname = value['LastName'];
          enumber = value['address'];

          setState(() {});
        
        }
      },
    );
  }

  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;

    _start(uid);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C2341),
      appBar: AppBar(
        backgroundColor: Color(0xFF1C2341),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NewWelcomeScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyStatelessWidget()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "http://www.clker.com/cliparts/d/L/P/X/z/i/no-image-icon-md.png",
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("First Name", fname, false),
              buildTextField("Last Name", lname, false),
              buildTextField("Address", enumber, true),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize:
                            Size(100, 40) // put the width and height you want
                        ),
                    onPressed: () => Navigator.of(context).pop(false),
                    //return false when click on "NO"
                    child: Text('CANCEL'),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize:
                            Size(100, 40) // put the width and height you want
                        ),
                    onPressed: () => Navigator.of(context).pop(true),
                    //return true when click on "Yes"
                    child: Text('SAVE'),
                  ),
                  // OutlineButon(
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20)),
                  //   onPressed: () {},
                  //   child: Text("CANCEL",
                  //       style: TextStyle(
                  //           fontSize: 14,
                  //           letterSpacing: 2.2,
                  //           color: Colors.black)),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   color: Colors.green,
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  //   elevation: 2,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20)),
                  //   child: Text(
                  //     "SAVE",
                  //     style: TextStyle(
                  //         fontSize: 14,
                  //         letterSpacing: 2.2,
                  //         color: Colors.white),
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                filled: true,
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                fillColor: Color(0xFF1C2341),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ],
        ));
  }
}
