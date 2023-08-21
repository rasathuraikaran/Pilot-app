import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quiz_app_pilot/screens/welcome/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * 1,
            decoration: BoxDecoration(
              color: Color(0xFF1C2341),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                    ),
                  ),
                  Text(
                    "Want to be a Pilot?",
                    style: TextStyle(
                      fontSize: 24, // Set your desired font size here
                      fontWeight: FontWeight
                          .bold, // You can also customize other properties like fontWeight
                      color: Colors.white, // Set the text color
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              color: Color.fromARGB(255, 0, 43, 172),
                              child: ListTile(
                                tileColor: Colors.amber,
                                focusColor: Colors.white,
                                title: Text(categories[index].title),
                                leading: categories[index].svgSrc.isNotEmpty
                                    ? Container(
                                        child: SvgPicture.asset(
                                            categories[index].svgSrc),
                                        height: 70,
                                        width: 50,
                                      )
                                    : null,
                                onTap: () {
                                  // Navigate to the HomeScreen when ListTile is tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Category {
  final String title;
  final String svgSrc;

  Category({required this.title, required this.svgSrc});
}

List<Category> categories = [
  Category(
      title: "Pilot's Handbook of Aeronautical Knowledge",
      svgSrc: "assets/icons/b.svg"),
  Category(title: "The Art of Flying", svgSrc: "assets/icons/b.svg"),
  Category(
      title: "The Thinking Pilot's Flight Manua", svgSrc: "assets/icons/b.svg"),
  Category(title: "Weather Flying", svgSrc: "assets/icons/b.svg"),
  Category(
      title: "The Advanced Pilot's Flight Manual",
      svgSrc: "assets/icons/b.svg"),
  Category(title: "The Complete Private Pilot", svgSrc: "assets/icons/b.svg"),
  Category(
      title: "Aerodynamics for Naval Aviators", svgSrc: "assets/icons/b.svg"),
  Category(
      title: "The Flight Instructor's Manual", svgSrc: "assets/icons/b.svg"),
  Category(title: "Aviation Weather", svgSrc: "assets/icons/b.svg"),
  Category(title: "The Instrument Flight Manual", svgSrc: "assets/icons/b.svg"),
  Category(
      title: "The Turbine Pilot's Flight Manual", svgSrc: "assets/icons/b.svg"),
];
