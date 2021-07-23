import 'package:calendar/database_helper.dart';
import 'package:calendar/model/userInfo.dart';
import 'package:calendar/screens/startup/freq_supplement.dart';
import 'package:calendar/screens/startup/freq_workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calendar/main.dart';
import 'package:calendar/route_animation.dart';

import 'package:calendar/screens/startup/freq_water.dart';

class GoalsAsk extends StatefulWidget {
  @override
  _GoalsAskState createState() => _GoalsAskState();
}

class _GoalsAskState extends State<GoalsAsk> {
  String ageInput, heightInput;
  String selected = "null";
  String goals;
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Color(0xFF1F3546),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Workout Goals :",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = '1';
                      });
                    },
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF1F3546),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: selected == '1' ? 3 : 1,
                            color: selected == '1' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "Lose Fat",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '1' ? Colors.teal : Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = '2';
                      });
                    },
                    child: Container(
                      //padding: EdgeInsets.all(10),
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF1F3546),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: selected == '2' ? 3 : 1,
                            color: selected == '2' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "Gain Muscle",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '2' ? Colors.teal : Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = '3';
                      });
                    },
                    child: Container(
                      //padding: EdgeInsets.all(10),
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF1F3546),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: selected == '3' ? 3 : 1,
                            color: selected == '3' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "Increase Body Strength",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '3' ? Colors.teal : Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = '4';
                      });
                    },
                    child: Container(
                      //padding: EdgeInsets.all(10),
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF1F3546),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: selected == '4' ? 3 : 1,
                            color: selected == '4' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "Increase Overall Fitness",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '4' ? Colors.teal : Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = '5';
                      });
                    },
                    child: Container(
                      //padding: EdgeInsets.all(10),
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF1F3546),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: selected == '5' ? 3 : 1,
                            color: selected == '5' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "Increase Cardio Resistance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '5' ? Colors.teal : Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),

                  Container(
                    child: TextButton(
                        child: Text("Save"),
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green,
                            shadowColor: Colors.black,
                            elevation: 5),
                        onPressed: () async {

                          switch (selected){
                            case "1":
                              goals = "Lose Fat";
                              break;
                            case "2" :
                              goals = "Gain Muscle";
                              break;
                            case "3" :
                              goals = "Increase Body Strength";
                              break;
                            case "4" :
                              goals = "Increase Overall Fitness";
                              break;
                            case "5" :
                              goals = "Increase Cardio Resistance";
                              break;
                          }

                          if (selected != "null") {
                            print("Goals : $goals");
                            _dbHelper.updateGoalsInfo(goals);
                            Navigator.of(context).push(
                                new SlideRightRoute(page: new FreqWorkout()));

                          }

                          }
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
