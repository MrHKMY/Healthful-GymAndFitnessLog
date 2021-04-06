import 'dart:convert';

import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
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
    return SafeArea(
        child: Stack(children: [
      Container(
        color: Colors.greenAccent,
        //height: 500,
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
                  initialCalendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarController: _calendarController,
                  calendarStyle: CalendarStyle(
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Colors.green,
                  ),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonDecoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    formatButtonShowsNext: false,
                  ),
                  onDaySelected: (date, events, holidays) {
                    setState(() {
                      _selectedEvents = events;
                    });
                  },
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orange,
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
                        height: MediaQuery.of(context).size.height / 20,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey)),
                        child: Center(
                          child: Text(
                            event,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
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
              backgroundColor: Colors.green,
              child: Icon(Icons.add),
              onPressed: _showAddDialog))
    ]));
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
                        date: a.substring(0,10)
                    );
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
      backgroundColor: Colors.teal,
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

class MainScreen3 extends StatelessWidget {
  const MainScreen3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Go Back to Second Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
