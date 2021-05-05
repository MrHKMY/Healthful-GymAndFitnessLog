import 'dart:convert';

import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
import 'package:calendar/model/progress.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,

        body: Stack(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Colors.black,
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
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        CircleAvatar(
                          maxRadius: 25,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: ExactAssetImage(
                                "assets/images/profile_image.png"),
                            maxRadius: 60,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FutureBuilder(
                              future: _dbHelper.retrieveUserInfo("Name"),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: "Times"),
                                );
                              },
                            ),
                          ),
                        ),
                      ]),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFF1F3546),
                          borderRadius: BorderRadius.circular(10)),
                      //Todo make the quotes randomly changes when the user launch the app. From database or api maybe
                      child: Text("\" If something stands between you and your success, move it. Never be denied.\" \n -Dwayne Johnson.",
                        style: TextStyle(
                          color: Colors.white,

                      ),),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Color(0xFF1F3546),
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TableCalendar(
                        events: _events,
                        formatAnimation: FormatAnimation.slide,
                        initialCalendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarController: _calendarController,
                        calendarStyle: CalendarStyle(
                          weekdayStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          weekendStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          outsideStyle: TextStyle(color: Colors.grey[700]),
                          unavailableStyle: TextStyle(color: Colors.grey[700]),
                          outsideWeekendStyle: TextStyle(color: Colors.grey[700]),
                          canEventMarkersOverflow: true,
                          //cellMargin: EdgeInsets.all(20),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          eventDayStyle: TextStyle(color: Colors.white)
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: Color(0xFF30A9B2),
                              fontWeight: FontWeight.bold),
                          weekendStyle: TextStyle(
                              color: Color(0xFF3DD94C),
                              fontWeight: FontWeight.bold),
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
                                  border: Border.all(color: Colors.black),
                                ),
                                margin: const EdgeInsets.all(4.0),
                                width: 8,
                                height: 8,
                              ),
                            ];
                          },
                          selectedDayBuilder: (context, date, events) =>
                              Container(
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
                                //color: Color(0xFF30A9B2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        //calendarController = _calendarController,
                      ),
                    ),
                    ..._selectedEvents.map((event) => Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1F3546),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFF30A9B2)),
                          ),
                          height: MediaQuery.of(context).size.height / 15,
                          width: double.infinity,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Center(
                              child: Text(
                                event,
                                style:
                                    TextStyle(color: Colors.white, fontSize: 14),
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
      ),
    );
  }

  //todo(2) create better dialog for activity tracker = target part, exercise name, sets
  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color(0xFF1F3546),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text("What have you achieve today?"),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              content: TextField(
                  controller: _eventController,
                  autofocus: true,
                  style: TextStyle(
                    color: Colors.white,
                  )),
              actions: <Widget>[
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
