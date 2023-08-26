import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:quiz_app_pilot/start.dart';

import '../../constants.dart';

class UserDetails extends StatefulWidget {
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final fname = TextEditingController();
  final lname = TextEditingController();
  final address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var uid;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  // Future<void> _submit(var fname, var lname, var enumber) async {
  //   Customer customer = new Customer(
  //       fname: fname, lname: lname, qrcode: widget.qr, eContactNo: enumber);
  //   await Provider.of<Customers>(context, listen: false).addCustomer(customer);

  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //   return;

  //   // var snapshot = await _dbRef.child("UserDetails/$myUserId").get();
  //   //print(snapshot);
  // }

  Future<void> _submit(var fname, var lname, var address) async {
    bool isValid = false;
    if (_formKey.currentState == null) {
      isValid = false;
    } else if (_formKey.currentState!.validate()) {
      isValid = true;
    }

    try {
      print('ok da chellam paa');
      print(fname);

      final url = Uri.parse(
          'https://pilotquizapp-default-rtdb.firebaseio.com/usersDetails.json');
      final response = await http.get(url);

      print('ok da chellam');

      // final url2 = Uri.parse(
      //     'https://roadsafe-ab1d9-default-rtdb.firebaseio.com/accident_check/$uid.json');
      // print("hari si mass");
      // print(uid);

      // await http.post(url2,
      //     body: json.encode({
      //       'check1': 'false',
      //       'check2': 'true',
      //     }));

      await http.post(url,
          body: json.encode({
            'FirstName': '$fname',
            'LastName': '$lname',
            'address': '$address',
            'uid': '$uid'
          }));

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyStatelessWidget()));
      return;
    } on PlatformException catch (err) {
      var message = "error irukkuda check your credential";
      if (err.message != null) message = err.message!;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    print("str uid");
    print(uid);
    super.initState();
  }

  // var snapshot = await _dbRef.child("UserDetails/$myUserId").get();
  //print(snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1C2341),
        body: Center(
          child: Form(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                const Spacer(),
                const Spacer(),
                SizedBox(
                  height: 120,
                ),
                TextFormField(
                  key: Key("fname-field"),
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'Invalid name!';
                    }
                    return null;
                  },
                  controller: fname,
                  decoration: InputDecoration(
                    hintText: "First Name",
                    filled: true,
                    fillColor: Color(0xFF1C2341),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  key: Key("lname-field"),
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'Invalid name!';
                    }
                    return null;
                  },
                  controller: lname,
                  decoration: InputDecoration(
                    hintText: "Last Name",
                    filled: true,
                    fillColor: Color(0xFF1C2341),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  key: Key("enumber-field"),
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'Invalid name!';
                    }
                    return null;
                  },
                  controller: address,
                  decoration: InputDecoration(
                    hintText: "Address",
                    filled: true,
                    fillColor: Color(0xFF1C2341),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(height: 100),
                InkWell(
                  onTap: () async {
                    await _submit(fname.text, lname.text, address.text);
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
              ],
            ),
          ),
        ));
  }
}
