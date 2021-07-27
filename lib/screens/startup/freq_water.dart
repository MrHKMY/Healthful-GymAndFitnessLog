import 'package:calendar/screens/startup/supplement_ask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calendar/main.dart';
import 'package:calendar/route_animation.dart';

class FreqWater extends StatefulWidget {
  @override
  _FreqWaterState createState() => _FreqWaterState();
}

class _FreqWaterState extends State<FreqWater> {
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
                      "Your daily water intake target :",
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
                        selected = '8';
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
                            width: selected == '8' ? 3 : 1,
                            color: selected == '8' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "8 Glasses (Minimum)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '8' ? Colors.teal : Colors.grey),
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
                        selected = '9';
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
                            width: selected == '9' ? 3 : 1,
                            color: selected == '9' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "9 Glasses (Recommended For Women)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '9' ? Colors.teal : Colors.grey),
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
                        selected = '13';
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
                            width: selected == '13' ? 3 : 1,
                            color: selected == '13' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "13 Glasses (Recommended For Men)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == '13' ? Colors.teal : Colors.grey),
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

                  Container(width: 300,
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
                          theInput = numberController.text.toString();
                          if(theInput != "") {
                            number = int.parse(theInput);
                          }

                          if (numberController.text.isNotEmpty) {
                            selected = numberController.text;
                          }

                          if(selected != "null" && number > 0){
                            print("Water target: $selected");
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setString("prefWater", selected);
                            Navigator.of(context).push(
                                new SlideRightRoute(page: new SuppAsk()));
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
