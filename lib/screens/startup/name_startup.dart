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

class NameAsk extends StatefulWidget {
  @override
  _NameAskState createState() => _NameAskState();
}

class _NameAskState extends State<NameAsk> {
  TextEditingController nameController;
  String theInput;
  String _selectedGender = "null";
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
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
                      "Create your profile :",
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
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Enter your name",
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = 'Male';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFF1F3546),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: _selectedGender == 'Male' ? 3 : 1,
                                color: _selectedGender == 'Male'
                                    ? Colors.blue
                                    : Colors.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/male_icon.png",
                                color: Colors.blue,
                                scale: 20,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  "Male",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _selectedGender == 'Male'
                                          ? Colors.blue
                                          : Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = 'Female';
                          });
                        },
                        child: Container(
                          //padding: EdgeInsets.all(10),
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFF1F3546),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: _selectedGender == 'Female' ? 3 : 1,
                                color: _selectedGender == 'Female'
                                    ? Colors.pinkAccent
                                    : Colors.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/female_icon.png",
                                color: Colors.pinkAccent,
                                scale: 20,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  "Female",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _selectedGender == 'Female'
                                          ? Colors.pinkAccent
                                          : Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                          theInput = nameController.text.trim();
                          if (_selectedGender != "null" && theInput.isNotEmpty) {

                            UserInfo _newInfo = UserInfo(
                                name: theInput,
                                gender: _selectedGender,
                            );
                            await _dbHelper.insertInfo(_newInfo);
                            print(nameController.text);
                            print(_selectedGender);
                            Navigator.of(context).push(
                                new SlideRightRoute(page: new FreqWorkout()));
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
