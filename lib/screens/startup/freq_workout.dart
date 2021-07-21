import 'package:calendar/screens/startup/freq_water.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calendar/main.dart';
import 'package:calendar/route_animation.dart';

class FreqWorkout extends StatefulWidget {
  @override
  _FreqWorkoutState createState() => _FreqWorkoutState();
}

class _FreqWorkoutState extends State<FreqWorkout> {
  TextEditingController numberController;
  String theInput;
  String selected = "null";
  int number = 1;

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
                      "Your weekly workout target :",
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
                        selected = '2';
                        numberController.clear();
                      });
                    },
                    child: Container(
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
                          "2 Days a Week",
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
                        selected = '4';
                        numberController.clear();
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
                          "4 Days a Week",
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
                        selected = '6';
                        numberController.clear();
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
                          width: selected == '6' ? 3 : 1,
                            color: selected == '6' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "6 Days a Week",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '6' ? Colors.teal : Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                        hintText: "Enter your own preference",
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
                    child: TextButton(
                        child: Text("Save"),
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green,
                            shadowColor: Colors.black,
                            elevation: 5),
                        onPressed: () async {
                          theInput = numberController.text.toString();
                          if(theInput != "") {
                            number = int.parse(theInput);
                          }

                          if (numberController.text.isNotEmpty) {
                            selected = numberController.text;
                          }

                          if(selected != "null" && number > 0){
                            print("Done selected : $selected");
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("prefWork", selected);
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
