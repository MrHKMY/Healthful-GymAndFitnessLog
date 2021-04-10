import 'dart:convert';

import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
                      weekdayStyle: TextStyle(color: Colors.white),
                      weekendStyle: TextStyle(color: Colors.white),
                      outsideStyle: TextStyle(color: Colors.grey),
                      unavailableStyle: TextStyle(color: Colors.grey),
                      outsideWeekendStyle: TextStyle(color: Colors.grey),
                      canEventMarkersOverflow: true,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Color(0xFF30A9B2)),
                      weekendStyle: TextStyle(color: Color(0xFF3DD94C)),
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
                              color: Color(0xFF30A9B2),
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.all(4.0),
                            width: 5,
                            height: 5,
                          )
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
                : kBottomNavigationBarHeight + 10,
            right: 10,
            child: FloatingActionButton(
                backgroundColor: Color(0xFF30A9B2),
                child: Icon(Icons.add),
                onPressed: _showAddDialog))
      ]),
    );
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("New Event"),
              content: TextField(controller: _eventController),
              actions: <Widget>[
                FlatButton(
                  child: Text("Save"),
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

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xff465466),
      body: Stack(children: [
        Container(
          margin: EdgeInsets.all(50),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/muscle_transparent.png"),
                fit: BoxFit.cover),
          ),
        ),
        Positioned(
            top: 4,
            right: 110,
            left: 110,
            child: WeightWidget(
              parts: "Weight",
              measurement: "45.56",
            )),
        Positioned(
            top: 130,
            left: 30,
            child: WeightWidget(
              parts: "Chest",
              measurement: "30.00",
            )),
        Positioned(
            top: 190,
            left: 30,
            child: WeightWidget(
              parts: "Waist",
              measurement: "30.00",
            )),
        Positioned(
            top: 250,
            left: 30,
            child: WeightWidget(
              parts: "Hips",
              measurement: "20.00",
            )),
        Positioned(
          top: 120,
          right: 20,
            child: ArmWidget(
              twoPart: "Upper Arm",
              leftMeasurement: "11",
              rightMeasurement: "11.11",
        )),
        Positioned(
            top: 215,
            right: 20,
            child: ArmWidget(
              twoPart: "Forearm",
              leftMeasurement: "11",
              rightMeasurement: "11.11",
            )),
        Positioned(
            top: 325,
            left: 30,
            child: ArmWidget(
              twoPart: "Thigh",
              leftMeasurement: "11",
              rightMeasurement: "11.11",
            )),
        Positioned(
            top: 420,
            left: 30,
            child: ArmWidget(
              twoPart: "Calf",
              leftMeasurement: "11",
              rightMeasurement: "11.11",
            )),
        Positioned(
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight + 10,
            child: FloatingActionButton(
              child: Icon(Icons.bar_chart_rounded),

        ),)
      ]),
    ));
  }
}
