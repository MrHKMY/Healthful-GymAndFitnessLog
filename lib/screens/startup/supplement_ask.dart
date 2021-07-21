import 'package:calendar/screens/startup/freq_supplement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calendar/main.dart';
import 'package:calendar/route_animation.dart';

class SuppAsk extends StatefulWidget {
  @override
  _SuppAskState createState() => _SuppAskState();
}

class _SuppAskState extends State<SuppAsk> {
  String theInput;
  String selected = "null";

  @override
  void initState() {
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
                      "Any Pre/Post workout supplements intake?",
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
                        selected = 'Yes';
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
                            width: selected == 'Yes' ? 3 : 1,
                            color: selected == 'Yes' ? Colors.teal : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "Yes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == 'Yes' ? Colors.teal : Colors.grey),
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
                        selected = 'No';
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
                            width: selected == 'No' ? 3 : 1,
                            color: selected == 'No' ? Colors.red[700] : Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected == 'No' ? Colors.red[700] : Colors.grey),
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

                          if(selected != "null"){
                            print("Done selected : $selected");
                            if( selected == "Yes") {
                              Navigator.of(context).push(
                                  new SlideRightRoute(page: new FreqSupplement()));
                            } else {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setString("prefSupp", "0");
                              Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
                            }
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
