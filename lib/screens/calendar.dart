import 'dart:convert';
import 'dart:math';

import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
import 'package:calendar/model/progress.dart';
import 'package:calendar/screens/history.dart';
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

  //int _counter = 0;
  String _chosenValue;
  int minValue = 0;
  int maxValue;
  ValueChanged<int> onChanged;
  int counter = 0;

  var list = <String> [
    "\"Success usually comes to those who are too busy to be looking for it.\" \n -Henry David Thoreau",
    "\"All progress takes place outside the comfort zone.\" \n -Michael John Bobak",
    "\"If you think lifting is dangerous, try being weak. Being weak is dangerous.\" \n -Bret Contreras",
    "\"The clock is ticking. Are you becoming the person you want to be?\" \n -Greg Plitt",
    "\"The only place where success comes before work is in the dictionary.\" \n -Vidal Sassoon",
    "\"Whether you think you can, or you think you can’t, you’re right.\" \n -Henry Ford",
    "\"The successful warrior is the average man, with laser-like focus.\" \n -Bruce Lee",
    "\"You must expect great things of yourself before you can do them.\" \n -Michael Jordan",
    "\"Action is the foundational key to all success.\" \n -Pablo Picasso",
    "\"Well done is better than well said.\" \n -Benjamin Franklin",
    "\"All our dreams can come true if we have the courage to pursue them.\" \n -Walt Disney",
    "\"Today I will do what others won’t, so tomorrow I can accomplish what others can’t.\" \n -Jerry Rice",
    "\"A champion is someone who gets up when they can’t.\" \n -Jack Dempsey",
    "\"If something stands between you and your success, move it. Never be denied.\" \n -Dwayne Johnson",
    "\"You have to think it before you can do it. The mind is what makes it all possible.\" \n -Kai Greene",
    "\"Things work out best for those who make the best of how things work out.\" \n -John Wooden",
    "\"Success is walking from failure to failure with no loss of enthusiasm.\" \n -Winston Churchill",
    "\"We are what we repeatedly do. Excellence then is not an act but a habit.\" \n -Aristotle",
    "\"Don’t count the days, make the days count.\" \n -Muhammad Ali",
    "\"Scratches at level 6 with deeper grooves at level 7.\" \n -JerryRigEverything",];
  var rand = new Random();


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

    int i = rand.nextInt(list.length);
    String quotes = list[i];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                      padding: EdgeInsets.all(5),
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
                                  snapshot.data.toString() != "null"
                                      ? snapshot.data.toString()
                                      : "",
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
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          //color: Color(0xFF1F3546),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          quotes,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Color(0xFF1F3546),
                          borderRadius: BorderRadius.circular(20)),
                      margin:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: TableCalendar(
                        events: _events,
                        formatAnimation: FormatAnimation.slide,
                        initialCalendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarController: _calendarController,
                        calendarStyle: CalendarStyle(
                            weekdayStyle: TextStyle(
                                color: Colors.white,
                                //fontWeight: FontWeight.bold
                            ),
                            weekendStyle: TextStyle(
                                color: Colors.white,
                                //fontWeight: FontWeight.bold
                            ),
                            outsideStyle: TextStyle(color: Colors.grey[700]),
                            unavailableStyle:
                                TextStyle(color: Colors.grey[700]),
                            outsideWeekendStyle:
                                TextStyle(color: Colors.grey[700]),
                            canEventMarkersOverflow: true,
                            //cellMargin: EdgeInsets.all(20),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 40,),
                            eventDayStyle: TextStyle(color: Colors.white)),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: Color(0xFF30A9B2),
                          ),
                          weekendStyle: TextStyle(
                              color: Color(0xFF3DD94C),
                              //fontWeight: FontWeight.bold
                          ),
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
                                color: Color(0xFF30B25B),
                                shape: BoxShape.circle),
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
                    ..._selectedEvents.map((event) => GestureDetector(
                      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryScreen())),
                      child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1F3546),
                              borderRadius: BorderRadius.circular(10),
                              //border: Border.all(color: Color(0xFF30A9B2)),
                            ),
                            height: MediaQuery.of(context).size.height / 20,
                            width: double.infinity,
                            margin:
                                EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Center(
                                child: Text(
                                  event,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
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
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              backgroundColor: Color(0xFF1F3546),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              title: Text("Today's Achievement: "),
                              titleTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        //margin: EdgeInsets.only(left: 25, right: 25),
                                        padding: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: new DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            focusColor: Colors.green,
                                            dropdownColor: Colors.black,
                                            value: _chosenValue,
                                            //style: TextStyle(color: Colors.pink),
                                            hint: Text(
                                              "Muscle Focus",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            iconEnabledColor: Colors.red,
                                            items: <String>[
                                              "Chest",
                                              "Abs",
                                              "Biceps",
                                              "Triceps",
                                              "Shoulders",
                                              "Forearm",
                                              "Hips",
                                              "Thigh",
                                              "Calves",
                                              "Whole Body",
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ));
                                            }).toList(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _chosenValue = newValue;
                                              });
                                            },
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      //margin: EdgeInsets.only(left: 25, right: 25),
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                          controller: _eventController,
                                          decoration: InputDecoration(
                                            hintText: "Exercise Name: ",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Set Count: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 30, right: 30),
                                      //padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal: 18.0),
                                            iconSize: 32.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              setState(() {
                                                if (counter >= 1) counter--;
                                              });
                                            },
                                          ),
                                          Text(
                                            '$counter',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal: 18.0),
                                            iconSize: 32.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              setState(() {
                                                counter++;
                                                //onChanged(counter);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _eventController.clear();
                                      _chosenValue = null;
                                      counter = 0;
                                      Navigator.pop(context);
                                    }),
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
                                    String a = _calendarController.selectedDay
                                        .toString();

                                    Activities _newActivity = Activities(
                                        activity: _eventController.text,
                                        focus: _chosenValue,
                                        setCount: counter,
                                        date: a.substring(0, 10));
                                    _actID = await _dbHelper
                                        .insertActivity(_newActivity);
                                    setState(() {
                                      if (_events[_calendarController
                                              .selectedDay] !=
                                          null) {
                                        _events[_calendarController.selectedDay]
                                            .add(_eventController.text);
                                      } else {
                                        _events[
                                            _calendarController.selectedDay] = [
                                          _eventController.text
                                        ];
                                      }
                                      prefs.setString("events",
                                          json.encode(encodeMap(_events)));
                                      //_focus = _chosenValue;
                                      // prefs.setString(
                                      //   "focus", _chosenValue);
                                      //print(_events);
                                      _eventController.clear();
                                      _chosenValue = null;
                                      counter = 0;
                                      Navigator.pop(context);
                                    });
                                  },
                                )
                              ],
                            );
                          });
                        });
                    ;
                  })),
          //TODO add another button to show history screen
        ]),
      ),
    );
  }

  _showAddDialog() async {
    final menu = new DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        focusColor: Colors.green,
        dropdownColor: Colors.black,
        value: _chosenValue,
        //style: TextStyle(color: Colors.pink),
        hint: Text(
          "Muscle Focus",
          style: TextStyle(color: Colors.grey),
        ),
        iconEnabledColor: Colors.red,
        items: <String>[
          "Chest",
          "Abs",
          "Biceps",
          "Triceps",
          "Shoulders",
          "Forearm",
          "Hips",
          "Thigh",
          "Calves",
          "Whole Body",
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.white),
              ));
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            _chosenValue = newValue;
          });
        },
      ),
    );

    int minValue;
    int maxValue;
    ValueChanged<int> onChanged;
    int counter = 0;

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xFF1F3546),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text("What have you achieve today?"),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      //margin: EdgeInsets.only(left: 25, right: 25),
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: menu,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      //margin: EdgeInsets.only(left: 25, right: 25),
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextField(
                          controller: _eventController,
                          decoration: InputDecoration(
                            hintText: "Exercise Name: ",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
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
                                if (counter > minValue) {
                                  counter--;
                                }
                                onChanged(counter);
                              });
                            },
                          ),
                          Text(
                            '$counter',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
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
                                if (counter < maxValue) {
                                  counter++;
                                }
                                onChanged(counter);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
            );
          });
        });
  }
}
