import 'dart:convert';

import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar/widgets.dart';

class CalendarScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const CalendarScreen(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;
  int _actID = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  prefsData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    prefsData();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Name"),
        elevation: 10,
        centerTitle: true,
        backgroundColor: Color(0xff374250),
      ),
      backgroundColor: Color(0xff465466),
      body: Stack(children: [
        Container(
          color: Color(0xff465466),
          //height: 500,
          height: double.infinity,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? 0.0
                : kBottomNavigationBarHeight,
          ),
          //backgroundColor: Colors.grey[500],
          child: SingleChildScrollView(
            //padding: EdgeInsets.only(bottom: 50),
            child: SafeArea(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TableCalendar(
                    events: _events,
                    formatAnimation: FormatAnimation.slide,
                    initialCalendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarController: _calendarController,
                    calendarStyle: CalendarStyle(
                      weekdayStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      outsideStyle: TextStyle(color: Colors.grey),
                      unavailableStyle: TextStyle(color: Colors.grey),
                      outsideWeekendStyle: TextStyle(color: Colors.grey),
                      canEventMarkersOverflow: true,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Color(0xFF30A9B2), fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(color: Color(0xFF3DD94C), fontWeight: FontWeight.bold),
                    ),
                    headerStyle: HeaderStyle(
                        leftChevronIcon: Icon(
                          CupertinoIcons.left_chevron,
                          color: Colors.grey,
                        ),
                        rightChevronIcon: Icon(
                          CupertinoIcons.right_chevron,
                          color: Colors.grey,
                        ),
                        centerHeaderTitle: true,
                        titleTextStyle: TextStyle(color: Colors.white),
                        formatButtonVisible: false),
                    onDaySelected: (date, events, holidays) {
                      setState(() {
                        _selectedEvents = events;
                      });
                    },
                    builders: CalendarBuilders(
                      markersBuilder: (context, date, events, holidays) {
                        return [
                          Container(
                            decoration: new BoxDecoration(
                              //todo(1): make color based on workout selection type
                              color: Color(0xFF30A9B2),
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.all(4.0),
                            width: 8,
                            height: 8,
                          ),
                        ];
                      },
                      selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFF30B25B), shape: BoxShape.circle),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFF30A9B2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    //calendarController = _calendarController,
                  ),
                  ..._selectedEvents.map((event) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 15,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                            child: Text(
                              event,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //     backgroundColor: Colors.green,
          //     child: Icon(Icons.add),
          //     onPressed: _showAddDialog
          //     //ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text("Snackbar")));
          //     ),
        ),
        Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? 0.0
                : kBottomNavigationBarHeight + 30,
            right: 30,
            child: FloatingActionButton(
                backgroundColor: Color(0xFF30A9B2),
                child: Icon(Icons.add),
                onPressed: _showAddDialog))
      ]),
    );
  }

  //todo(2) create better dialog for activity tracker
  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color(0xff465466),
              title: Text("New Event"),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
              content: TextField(
                controller: _eventController,
                autofocus: true,
                style: TextStyle(
                  color: Colors.white,)
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Save"),
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.teal,
                      shadowColor: Colors.black,
                      elevation: 5),
                  onPressed: () async {
                    if (_eventController.text.isEmpty) {
                      return;
                    }
                    //Save activity to Database
                    String a = _calendarController.selectedDay.toString();

                    Activities _newActivity = Activities(
                        activity: _eventController.text,
                        date: a.substring(0, 10));
                    _actID = await _dbHelper.insertActivity(_newActivity);
                    setState(() {
                      if (_events[_calendarController.selectedDay] != null) {
                        _events[_calendarController.selectedDay]
                            .add(_eventController.text);
                      } else {
                        _events[_calendarController.selectedDay] = [
                          _eventController.text
                        ];
                      }
                      prefs.setString(
                          "events", json.encode(encodeMap(_events)));
                      _eventController.clear();
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff465466),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Column(children: [
              Expanded(
                  child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.retrieveActivity(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return HistoryWidget(
                              activity: snapshot.data[index].activity,
                              date: snapshot.data[index].date,
                            );
                          },
                        );
                      }))
            ])
          ],
        ),
      ),
    );
  }
}

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
        backgroundColor: Color(0xff374250),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff465466),
      body: SafeArea(
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
          top: height * 0.53,
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
          top: height * 0.68,
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
                        return Center(child: CircularProgressIndicator());
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
          //todo(3) create fab to open new charts screen
          onPressed: () {},
          child: Icon(Icons.bar_chart_rounded),
        ),
    )
        ]),
      ),
    );
  }

  _showSingleDialog(String part) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color(0xff465466),
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
                      elevation: 5),
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
              backgroundColor: Color(0xff465466),
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
                      elevation: 5),
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
