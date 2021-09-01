import 'dart:async';

import 'package:calendar/database_helper.dart';
import 'package:calendar/model/userInfo.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _visible = false;
  Timer timer;
  TextEditingController nameInputController,
      ageInputController,
      heightInputController;
  String _selectedGender = genderMap.keys.first;
  String _chosenValue;
  int _userInfo = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();

  static final Map<String, String> genderMap = {
    'Male': 'Male',
    'Female': 'Female',
  };

  @override
  void initState() {
    _visible = false;
    timer = Timer(
        Duration(milliseconds: 100),
            () => setState(() {
          _visible = true;
        }));
    nameInputController = TextEditingController();
    heightInputController = TextEditingController();
    ageInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final genderSelectionTile = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 5),
          ),
          CupertinoRadioChoice(
              choices: genderMap,
              selectedColor: Color(0xFF30A9B2),
              notSelectedColor: Color(0xFF1F3546),
              onChange: onGenderSelected,
              initialKeyValue: _selectedGender)
        ],
      ),
    );

    final menu = new DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          focusColor: Colors.green,
          dropdownColor: Color(0xFF1F3546),
          value: _chosenValue,
          //style: TextStyle(color: Colors.pink),
          hint: Text(
            "Fitness Goals",
            style: TextStyle(color: Colors.grey),
          ),
          iconEnabledColor: Colors.red,
          items: <String>[
            "Increase overall fitness",
            "Gain muscle",
            "Lose fat",
            "Increase cardio resistance",
            "Increase strength",
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ));
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              _chosenValue = newValue;
            });
          },
        ));

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: height,
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(12),
                  //alignment: Alignment.bottomLeft,
                  foregroundDecoration: RotatedCornerDecoration(
                    color: Color(0xFF30A9B2),
                    geometry: const BadgeGeometry(
                        width: 300,
                        height: 100,
                        alignment: BadgeAlignment.topLeft),
                    labelInsets: const LabelInsets(baselineShift: 2),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(12),
                  //alignment: Alignment.bottomLeft,
                  foregroundDecoration: const RotatedCornerDecoration(
                    badgeShadow:
                    BadgeShadow(
                        color: Colors.black, elevation: 4),
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   stops: [0, 1],
                    //   colors: [Colors.blue, Colors.greenAccent],
                    // ),
                    color: Color(0xFF1F3546),
                    geometry: const BadgeGeometry(
                        width: 250,
                        height: 80,
                        alignment: BadgeAlignment.topLeft),
                    labelInsets: const LabelInsets(baselineShift: 2),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(12),
                  //alignment: Alignment.bottomLeft,
                  foregroundDecoration: RotatedCornerDecoration(
                    color: Color(0xFF30A9B2),
                    geometry: BadgeGeometry(
                        width: width,
                        height: 60,
                        alignment: BadgeAlignment.bottomRight),
                    labelInsets: const LabelInsets(baselineShift: 2),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(12),
                  //alignment: Alignment.bottomLeft,
                  foregroundDecoration: const RotatedCornerDecoration(
                    badgeShadow:
                    BadgeShadow(
                        color: Colors.black, elevation: 4),
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   stops: [0, 1],
                    //   colors: [Colors.blue, Colors.greenAccent],
                    // ),
                    color: Color(0xFF1F3546),
                    geometry: const BadgeGeometry(
                        width: 350,
                        height: 50,
                        alignment: BadgeAlignment.bottomRight),
                    labelInsets: const LabelInsets(baselineShift: 2),
                  ),
                ),
                // Container(
                //   color: Colors.transparent,
                //   padding: const EdgeInsets.all(12),
                //   //alignment: Alignment.bottomLeft,
                //   foregroundDecoration: RotatedCornerDecoration(
                //     color: Color(0xFF30A9B2),
                //     geometry: BadgeGeometry(
                //         width: width,
                //         height: 60,
                //         alignment: BadgeAlignment.bottomLeft),
                //     labelInsets: const LabelInsets(baselineShift: 2),
                //   ),
                // ),
                // Container(
                //   color: Colors.transparent,
                //   padding: const EdgeInsets.all(12),
                //   //alignment: Alignment.bottomLeft,
                //   foregroundDecoration: const RotatedCornerDecoration(
                //     badgeShadow:
                //     BadgeShadow(
                //         color: Colors.black, elevation: 4),
                //     // gradient: LinearGradient(
                //     //   begin: Alignment.topLeft,
                //     //   end: Alignment.bottomRight,
                //     //   stops: [0, 1],
                //     //   colors: [Colors.blue, Colors.greenAccent],
                //     // ),
                //     color: Color(0xFF1F3546),
                //     geometry: const BadgeGeometry(
                //         width: 350,
                //         height: 50,
                //         alignment: BadgeAlignment.bottomLeft),
                //     labelInsets: const LabelInsets(baselineShift: 2),
                //   ),
                // ),
                Align(
                  alignment: Alignment(0, -0.7),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Update Profile:",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          fontFamily: "Times"),
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment(0, -1),
                //   child: AnimatedOpacity(
                //     opacity: _visible ? 1.0 : 0.0,
                //     duration: Duration(milliseconds: 500),
                //     child: Container(
                //       padding: EdgeInsets.symmetric(horizontal: 50),
                //       height: 220,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.only(
                //             topRight: Radius.circular(0.0),
                //             bottomLeft: Radius.circular(150.0)),
                //         //border: Border.all(color: Color(0xFF30A9B2)),
                //         color: Color(0xFF1F3546),
                //       ),
                //     ),
                //   ),
                // ),
                // Align(
                //   alignment: Alignment(0, -1),
                //   child: AnimatedOpacity(
                //     opacity: _visible ? 1.0 : 0.0,
                //     duration: Duration(milliseconds: 500),
                //     child: Container(
                //       padding: EdgeInsets.symmetric(horizontal: 50),
                //       height: 205,
                //       //width: width-20,
                //       decoration: BoxDecoration(
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black,
                //             spreadRadius: 1,
                //             blurRadius: 1,
                //             offset: Offset(2, 2),
                //           ),
                //         ],
                //         borderRadius: BorderRadius.only(
                //             topRight: Radius.circular(0.0),
                //             bottomLeft: Radius.circular(150.0)),
                //         //border: Border.all(color: Color(0xFF30A9B2)),
                //         color: Color(0xFF30A9B2),
                //       ),
                //     ),
                //   ),
                // ),
                Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF1F3546),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0xFF30A9B2),
                          //     spreadRadius: 1,
                          //     blurRadius: 1,
                          //     offset: Offset(2, 2),
                          //   ),
                          //],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextField(
                          controller: nameInputController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "Name: ",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[0-9.,]')),
                          ],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFF1F3546),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Color(0xFF30A9B2),
                                //     spreadRadius: 1,
                                //     blurRadius: 1,
                                //     offset: Offset(2, 2),
                                //   ),
                                // ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: TextField(
                                controller: ageInputController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Age: ",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF1F3546),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Color(0xFF30A9B2),
                                //     spreadRadius: 1,
                                //     blurRadius: 1,
                                //     offset: Offset(2, 2),
                                //   ),
                                // ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: TextField(
                                controller: heightInputController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Height (metre): ",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.]')),
                                ],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 25),
                        child: genderSelectionTile,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 25, right: 25),
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFF1F3546),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0xFF30A9B2),
                          //     spreadRadius: 1,
                          //     blurRadius: 1,
                          //     offset: Offset(2, 2),
                          //   ),
                          // ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: menu,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: TextButton(
                            child: Text(
                              "Save",
                            ),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.green,
                                shadowColor: Colors.black,
                                elevation: 5),
                            onPressed: () async {
                              if (nameInputController.text.isEmpty ||
                                  ageInputController.text.isEmpty ||
                                  heightInputController.text.isEmpty ||
                                  _chosenValue == null) {
                                return;
                              }
                              UserInfo _newInfo = UserInfo(
                                id: 1,
                                name: nameInputController.text,
                                age: int.parse(ageInputController.text),
                                gender: _selectedGender,
                                height: double.parse(heightInputController.text),
                                goals: _chosenValue,
                                //bodyPart: part,
                                //center: double.parse(weightInputController.text),
                              );
                              //date: a.substring(0, 10));
                              _userInfo = await _dbHelper.updateAgeInfo(1,2);
                              setState(() {
                                //getProgress(part);
                                nameInputController.clear();
                                ageInputController.clear();
                                heightInputController.clear();
                                Navigator.of(context).pop();

                                // Navigator.of(context).pop(new ScaleRoute(
                                //     page: new ProvidedStylesExample()));
                                //Navigator.pop(context, SlideRightRoute(page: ProfileScreen()));
                              });
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onGenderSelected(String genderKey) {
    setState(() {
      _selectedGender = genderKey;
    });
  }
}
