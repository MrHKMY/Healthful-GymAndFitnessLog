import 'package:calendar/model/progress.dart';
import 'package:calendar/screens/chart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calendar/database_helper.dart';
import 'package:calendar/widgets.dart';
import 'package:calendar/route_animation.dart';


class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key key}) : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  TextEditingController weightInputController, leftController, rightController;
  int _progressID = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();
  String aaaa = "";

  @override
  void initState() {
    weightInputController = TextEditingController();
    leftController = TextEditingController();
    rightController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Progress Tracker"),
        elevation: 10,
        centerTitle: true,
        backgroundColor: Color(0xFF1F3546),
        brightness: Brightness.light,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: height,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? 0.0
                  : kBottomNavigationBarHeight + 40,
            ),
            child: Stack(children: [
              Container(
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/muscle_transparent.png"),
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                  top: height * 0.01,
                  right: width * 0.35,
                  left: width * 0.35,
                  child: GestureDetector(
                    onTap: () {
                      _showSingleDialog("Weight");
                    },
                    child: FutureBuilder(
                        future: _dbHelper.retrieve1Part("Weight"),
                        builder: (context, snapshot) {
                          return WeightWidget(
                              parts: "Weight",
                              //activity: snapshot.data[index].activity,
                              //date: snapshot.data[index].date,
                              measurement: snapshot.data.toString() != "null"
                                  ? snapshot.data.toString()
                                  : "Tap to input");
                        }),
                  )),
              Positioned(
                  top: height * 0.2,
                  left: width * 0.09,
                  child: GestureDetector(
                    onTap: () {
                      _showSingleDialog("Chest");
                    },
                    child: FutureBuilder(
                        future: _dbHelper.retrieve1Part("Chest"),
                        builder: (context, snapshot) {
                          return WeightWidget(
                              parts: "Chest",
                              measurement: snapshot.data.toString() != "null"
                                  ? snapshot.data.toString()
                                  : "Tap to input");
                        }),
                  )),
              Positioned(
                  top: height * 0.3,
                  left: width * 0.09,
                  child: GestureDetector(
                    onTap: () {
                      _showSingleDialog("Waist");
                    },
                    child: FutureBuilder(
                        future: _dbHelper.retrieve1Part("Waist"),
                        builder: (context, snapshot) {
                          return WeightWidget(
                              parts: "Waist",
                              measurement: snapshot.data.toString() != "null"
                                  ? snapshot.data.toString()
                                  : "Tap to input");
                        }),
                  )),
              Positioned(
                  top: height * 0.4,
                  left: width * 0.09,
                  child: GestureDetector(
                    onTap: () {
                      _showSingleDialog("Hips");
                    },
                    child: FutureBuilder(
                        future: _dbHelper.retrieve1Part("Hips"),
                        builder: (context, snapshot) {
                          return WeightWidget(
                              parts: "Hips",
                              measurement: snapshot.data.toString() != "null"
                                  ? snapshot.data.toString()
                                  : "Tap to input");
                        }),
                  )),
              Positioned(
                  top: height * 0.2,
                  right: width * 0.07,
                  child: GestureDetector(
                    onTap: () {
                      _showDoubleDialog("Upper Arm");
                    },
                    child: FutureBuilder(
                        future: _dbHelper.retrieve2Part("Upper Arm"),
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
                              return ArmWidget(
                                  twoPart: "Upper Arm",
                                  leftMeasurement:
                                      snapshot.data[0].toString() != "null"
                                          ? snapshot.data[0].toString()
                                          : "Tap to input",
                                  rightMeasurement:
                                      snapshot.data[1].toString() != "null"
                                          ? snapshot.data[1].toString()
                                          : "Tap to input");
                          }
                        }),
                  )),
              Positioned(
                  top: height * 0.35,
                  right: width * 0.07,
                  child: GestureDetector(
                    onTap: () {
                      _showDoubleDialog("Forearm");
                    },
                    child: FutureBuilder(
                        future: _dbHelper.retrieve2Part("Forearm"),
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
                              return ArmWidget(
                                  twoPart: "Forearm",
                                  leftMeasurement:
                                      snapshot.data[0].toString() != "null"
                                          ? snapshot.data[0].toString()
                                          : "Tap to input",
                                  rightMeasurement:
                                      snapshot.data[1].toString() != "null"
                                          ? snapshot.data[1].toString()
                                          : "Tap to input");
                          }
                        }),
                  )),
              Positioned(
                  top: height * 0.50,
                  left: width * 0.09,
                  child: GestureDetector(
                    onTap: () {
                      _showDoubleDialog("Thigh");
                    },
                    child: FutureBuilder(
                        future: _dbHelper.retrieve2Part("Thigh"),
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
                              return ArmWidget(
                                  twoPart: "Thigh",
                                  leftMeasurement:
                                      snapshot.data[0].toString() != "null"
                                          ? snapshot.data[0].toString()
                                          : "Tap to input",
                                  rightMeasurement:
                                      snapshot.data[1].toString() != "null"
                                          ? snapshot.data[1].toString()
                                          : "Tap to input");
                          }
                        }),
                  )),
              Positioned(
                  top: height * 0.65,
                  left: width * 0.09,
                  child: GestureDetector(
                      onTap: () {
                        _showDoubleDialog("Calf");
                      },
                      child: FutureBuilder(
                          //initialData: [],
                          future: _dbHelper.retrieve2Part("Calf"),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              // Uncompleted State
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                                break;
                              default:
                                // Completed with error
                                if (snapshot.hasError)
                                  return Container(
                                      child: Text(snapshot.error.toString()));
                                return ArmWidget(
                                    twoPart: "Calf",
                                    leftMeasurement:
                                        snapshot.data[0].toString() != "null"
                                            ? snapshot.data[0]
                                            : "Tap to input",
                                    rightMeasurement:
                                        snapshot.data[1].toString() != "null"
                                            ? snapshot.data[1]
                                            : "Tap to input");
                            }
                          }))),
              Positioned(
                right: width * 0.1,
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? 0.0
                    : kBottomNavigationBarHeight + 50,
                child: FloatingActionButton(
                  backgroundColor: Colors.teal[300],
                  onPressed: () {
                    Navigator.of(context).push(
                        new SlideRightRoute(page: new ChartScreen()));
                  },
                  child: Icon(Icons.bar_chart_rounded, color: Colors.black,),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  _showSingleDialog(String part) async {
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
              title: Text(part + " measurement"),
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

  _showDoubleDialog(String part) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color(0xFF1F3546),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                "$part measurement",
              ),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              content: SingleChildScrollView(
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: leftController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                      ],
                      decoration: InputDecoration(
                          helperText: "Left",
                          helperStyle: TextStyle(color: Colors.blue)),
                      style: TextStyle(color: Colors.white),
                    ),
                    TextField(
                      controller: rightController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                      ],
                      decoration: InputDecoration(
                          helperText: "Right",
                          helperStyle: TextStyle(color: Colors.blue)),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      leftController.clear();
                      rightController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    )),
                TextButton(
                  child: Text("Save"),
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
                    if (leftController.text.isEmpty ||
                        rightController.text.isEmpty) {
                      return;
                    }
                    Progress _newProgress = Progress(
                        bodyPart: part,
                        left: double.parse(leftController.text),
                        right: double.parse(rightController.text));
                    //date: a.substring(0, 10));
                    _progressID = await _dbHelper.insertProgress(_newProgress);
                    setState(() {
                      //getProgress(part);
                      //getDoublePart(part);
                      leftController.clear();
                      rightController.clear();
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ));
  }
}
