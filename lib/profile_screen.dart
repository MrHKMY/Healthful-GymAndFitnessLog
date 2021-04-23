import 'dart:async';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {

  bool _visible = false;
  final Duration delay = Duration(milliseconds: 50);
  Timer timer;

  @override
  void initState() {
    _visible = false;
    timer = Timer(Duration(milliseconds: 100), () => setState(() {_visible = true;}));
    // Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
    //   _visible = true;
    // }));
    super.initState();
  }

  @override
  void dispose() {
    // if (timer != null) timer.cancel();
    // _visible = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 10,
        centerTitle: true,
        backgroundColor: Color(0xff374250),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -1),
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(0.0),
                        bottomLeft: Radius.circular(150.0)),
                    //border: Border.all(color: Color(0xFF30A9B2)),
                    color: Color(0xFF30A9B2),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.4, -0.8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(children: [
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      maxRadius: 65,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:
                            ExactAssetImage("assets/images/profile_image.png"),
                        maxRadius: 60,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Adam Witwicky",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 26,
                            color: Colors.black,
                            fontFamily: "Times"),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Align(
              alignment: Alignment(0.0, -0.25),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF30A9B2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "65.5 Kg",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Weight",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: Color(0xFF30A9B2),
                        indent: 10,
                        endIndent: 10,
                        thickness: 0.5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "1.70 m",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Height",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0, 0.5),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.4,
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Color(0xff465466),
                  //   borderRadius: BorderRadius.circular(20),
                  //   border: Border.all(color: Color(0xFF30A9B2)),
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                //color: Colors.blue,
                                //borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue)),
                            child: Image.asset(
                              "assets/images/age_icon.png",
                              color: Colors.blue,
                              scale: 20,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Age",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "25",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                //color: Colors.blue,
                                //borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.green)),
                            child: Image.asset(
                              "assets/images/gender_icon.png",
                              color: Colors.green,
                              scale: 20,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Gender",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "Gender Icon",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                //color: Colors.blue,
                                //borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.red)),
                            child: Image.asset(
                              "assets/images/goals_icon.png",
                              color: Colors.red[600],
                              scale: 20,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Fitness Goals",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "Keep Fit",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                //color: Colors.blue,
                                //borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange)),
                            child: Image.asset(
                              "assets/images/bmi_icon.png",
                              color: Colors.orange,
                              scale: 20,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Body Mass Index (BMI)",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "21.2",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.settings,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Settings",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
