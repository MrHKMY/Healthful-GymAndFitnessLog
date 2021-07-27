import 'package:calendar/database_helper.dart';
import 'package:calendar/model/userInfo.dart';
import 'package:calendar/screens/startup/freq_supplement.dart';
import 'package:calendar/screens/startup/freq_workout.dart';
import 'package:calendar/screens/startup/goals_startup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calendar/main.dart';
import 'package:calendar/route_animation.dart';

import 'package:calendar/screens/startup/freq_water.dart';

class AgeAsk extends StatefulWidget {
  @override
  _AgeAskState createState() => _AgeAskState();
}

class _AgeAskState extends State<AgeAsk> {
  TextEditingController ageController, heightController;
  String ageInput, heightInput;
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    ageController = TextEditingController();
    heightController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
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
                      "",
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    width: 350,
                    height: 60,
                    margin: EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF1F3546),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white,
                          width: 2),
                    ),
                    child: TextField(
                      //textAlign: TextAlign.center,
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Age :",
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                        FilteringTextInputFormatter.deny(RegExp('[., -]')),
                      ],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    width: 350,
                    height: 60,
                    margin: EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF1F3546),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white,
                          width: 2),
                    ),
                    child: TextField(
                      //textAlign: TextAlign.center,
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Height (meter) :",
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: [
                        //FilteringTextInputFormatter.singleLineFormatter,
                        FilteringTextInputFormatter.deny(RegExp('[, -]')),
                      ],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 300,
                    height: 40,
                    child: TextButton(
                        child: Text("Save", style: TextStyle( color: Colors.white),),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )
                            )
                        ),
                        onPressed: () async {
                          ageInput = ageController.text;
                          heightInput = heightController.text;
                          print("Age : $ageInput");
                          print("Height : $heightInput");

                          if (ageInput.isNotEmpty && heightInput.isNotEmpty) {
                            int _age = int.parse(ageInput);
                            double _height = double.parse(heightInput);

                            // UserInfo _newInfo = UserInfo(
                            //   id: 1,
                            //   age: _age,
                            //   height: _height,
                            // );
                            await _dbHelper.updateAgeInfo(_age, _height);
                            Navigator.of(context).push(
                                new SlideRightRoute(page: new GoalsAsk()));
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
