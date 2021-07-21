import 'package:calendar/screens/startup/supplement_ask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calendar/main.dart';
import 'package:calendar/route_animation.dart';

class FreqSupplement extends StatefulWidget {
  @override
  _FreqSupplementState createState() => _FreqSupplementState();
}

class _FreqSupplementState extends State<FreqSupplement> {
  TextEditingController numberController;
  String theInput;
  String selected = "null";
  int counter = 0;

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
                      "Your daily supplements intake frequency:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    //padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            //color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),),
                            border: Border.all(
                                  width: 3,
                                color: Colors.teal),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Theme.of(context).accentColor,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 18.0),
                            iconSize: 32.0,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                if (counter >= 1) counter--;
                              });
                            },
                          ),
                        ),
                        Text(
                          '$counter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            //color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),),
                            border: Border.all(
                                width: 3,
                                color: Colors.teal),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).accentColor,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 18.0),
                            iconSize: 32.0,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                counter++;
                              });
                            },
                          ),
                        ),
                      ],
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


                          if(counter != 0){
                            print("Done selected : $counter");
                            selected = counter.toString();
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setString("prefSupp", selected);
                            Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
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
