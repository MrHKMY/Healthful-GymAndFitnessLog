import 'package:calendar/screens/startup/freq_water.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calendar/main.dart';
import 'package:calendar/route_animation.dart';

class CalorieStartUp extends StatefulWidget {
  @override
  _CalorieStartUpState createState() => _CalorieStartUpState();
}

class _CalorieStartUpState extends State<CalorieStartUp> {
  TextEditingController numberController;
  String theInput;
  String selected = "null";
  int number = 0;

  @override
  void initState() {
    numberController = TextEditingController();
    super.initState();
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
                      "Your daily calorie intake target :",
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
                    width: 300,
                    margin: EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF1F3546),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(width: 3, color: Colors.teal),
                    ),
                    child: TextField(
                      onTap: () {
                        setState(() {
                          selected = 'null';
                        });
                      },
                      textAlign: TextAlign.center,
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "kcal",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
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
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(5),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ))),
                        onPressed: () async {
                          theInput = numberController.text.toString();
                          if (theInput != "") {
                            number = int.parse(theInput);
                          }

                          if (number > 0) {
                            print("Calorie intake : $number");
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("prefCal", theInput);
                            Navigator.of(context).push(
                                new SlideRightRoute(page: new FreqWater()));
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
