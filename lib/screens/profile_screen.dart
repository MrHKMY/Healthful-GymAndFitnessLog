import 'dart:async';

import 'package:calendar/model/progress.dart';
import 'package:calendar/model/userInfo.dart';
import 'package:calendar/screens/startup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calendar/database_helper.dart';

import 'package:calendar/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _visible = false;
  final Duration delay = Duration(milliseconds: 50);
  Timer timer;
  TextEditingController weightInputController;
  int _progressID = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();
  double bmiValue;

  @override
  void initState() {
    _visible = false;
    timer = Timer(
        Duration(milliseconds: 100),
        () => setState(() {
              _visible = true;
            }));
    weightInputController = TextEditingController();
    // Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
    //   _visible = true;
    // }));
    //getBmiValue();
    super.initState();
  }

  @override
  void dispose() {
    // if (timer != null) timer.cancel();
    // _visible = false;
    super.dispose();
  }

  Future<String> getBmiValue() async {
    String weight = await _dbHelper.retrieve1Part("Weight");
    String height = await _dbHelper.retrieveUserInfo("Height");
    double bmiHeight = double.parse(height);
    double bmiWeight = double.parse(weight);

    bmiValue = bmiWeight / (bmiHeight * bmiHeight);
    bmiValue = num.parse(bmiValue.toStringAsFixed(2));

    return bmiValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double bottom = MediaQuery.of(context).viewInsets.bottom > 0
        ? 0.0
        : kBottomNavigationBarHeight;

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    //   statusBarIconBrightness: Brightness.light,
    //   //statusBarBrightness: Brightness.light,
    //   //systemNavigationBarIconBrightness: Brightness.dark,
    // ));

    // FutureBuilder(
    //     future: _dbHelper.retrieveUserInfo("Height"),
    //     builder: (context, snapshot) {
    //       bmiHeight = snapshot.data.toString();
    //       return bmiHeight;
    //     }
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 10,
        centerTitle: true,
        backgroundColor: Color(0xFF1F3546),
        brightness: Brightness.light,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: screenHeight,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? 0.0
                  : kBottomNavigationBarHeight,
            ),
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
                        color: Color(0xFF1F3546),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -1),
                  child: AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      height: 205,
                      //width: width-20,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(2, 2),
                          ),
                        ],
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
                        //todo onTap to change profile photo
                        child: CircleAvatar(
                          maxRadius: 65,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: ExactAssetImage(
                                "assets/images/profile_image.png"),
                            maxRadius: 60,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: FutureBuilder(
                            future: _dbHelper.retrieveUserInfo("Name"),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data.toString() != "null"
                                    ? snapshot.data.toString()
                                    : "Anonymous",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.black,
                                    fontFamily: "Times"),
                              );
                            },
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
                          GestureDetector(
                            onTap: () {
                              _showDialog("Weight");
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FutureBuilder(
                                    future: _dbHelper.retrieve1Part("Weight"),
                                    builder: (context, snapshot) {
                                      return Text(
                                        //todo this not updated if user loaded profile first, before user input weight in progress
                                        snapshot.data.toString() != "null"
                                            ? snapshot.data.toString()
                                            : "?",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      );
                                    }),
                                Text(
                                  "Weight (kg)",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
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
                              FutureBuilder(
                                  future: _dbHelper.retrieveUserInfo("Height"),
                                  builder: (context, snapshot) {
                                    // String a = snapshot.data.toString();
                                    // double b = double.parse(a);
                                    // b = num.parse(b.toStringAsFixed(3));
                                    return Text(
                                      //b.toString(),
                                      snapshot.data.toString() != "null"
                                          ? snapshot.data.toString()
                                          : "?",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    );
                                  }),
                              Text(
                                "Height (m)",
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
                              FutureBuilder(
                                  future: _dbHelper.retrieveUserInfo("Age"),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString() != "null"
                                          ? snapshot.data.toString()
                                          : "?",
                                      style: TextStyle(color: Colors.grey),
                                    );
                                  }),
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
                              FutureBuilder(
                                  future: _dbHelper.retrieveUserInfo("Gender"),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString() != "null"
                                          ? snapshot.data.toString()
                                          : "?",
                                      style: TextStyle(color: Colors.grey),
                                    );
                                  }),
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
                              FutureBuilder(
                                  future: _dbHelper.retrieveUserInfo("Goals"),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString() != "null"
                                          ? snapshot.data.toString()
                                          : "?",
                                      style: TextStyle(color: Colors.grey),
                                    );
                                  }),
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
                              FutureBuilder(
                                  future: getBmiValue(),
                                  builder: (context, snapshot) {
    switch (snapshot.connectionState) {
    // Uncompleted State
      case ConnectionState.none:
      case ConnectionState.waiting:
        return Center(child: CircularProgressIndicator());
        break;
      default:
      // Completed with error
        if (snapshot.hasError)
          return Container(
              child: Text(snapshot.error.toString()));
        return Text(
          snapshot.data.toString() != "null"
              ? snapshot.data.toString()
              : "?",
          style: TextStyle(color: getColor(snapshot.data.toString())),
        );
    }}),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              //_showDialog("Info");
                              //TODO remove below navigator if possible
                              Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfileScreen())).then((value) { setState(() {});

                              },
                              );},
                            child: Row(
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
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(String part) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color(0xFF1F3546),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              title: Text("Enter Weight (in Kg)"),
              content: TextField(
                controller: weightInputController,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                ],
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      weightInputController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    )),
                TextButton(
                  child: Text(
                    "Save",
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    if (weightInputController.text.isEmpty) {
                      return;
                    }
                    Progress _newProgress = Progress(
                      bodyPart: part,
                      center: double.parse(weightInputController.text),
                    );
                    //date: a.substring(0, 10));
                    _progressID = await _dbHelper.insertProgress(_newProgress);
                    setState(() {
                      //getProgress(part);
                      weightInputController.clear();
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }

  getColor(String bmi) {
    double a = double.parse(bmi);
    if (a < 18.5) return Colors.orange;
    if (a >= 18.5 && a <= 24.9) return Colors.green;
    if (a >= 25.0 && a <= 29.9) return Colors.yellow;
    if (a >= 30 ) return Colors.red;
  }
}
