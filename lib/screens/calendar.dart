import 'dart:convert';
import 'dart:math';

import 'package:calendar/database_helper.dart';
import 'package:calendar/model/nutrition.dart';
import 'package:calendar/screens/history.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
  int waterID = 0;

  //int _counter = 0;
  int minValue = 0;
  int maxValue;
  ValueChanged<int> onChanged;
  int counter = 0;
  double waterCount;
  String waterCountString;
  double workoutGoals = 0;
  var iconColor;
  String quotes = "a";
  String selected;

  var list = <String>[
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
    "\"Scratches at level 6 with deeper grooves at level 7.\" \n -JerryRigEverything",
  ];
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
    getTotalWater();
    randomQuotes();
  }

  randomQuotes() {
    int i = rand.nextInt(list.length);
    quotes = list[i];
  }

  Future<double> getTotalWater() async {
    waterCountString = await _dbHelper.retrieveWater();
    print(waterCountString);
    waterCount =
        waterCountString != "null" ? double.parse(waterCountString) : 0;
    print(waterCount);
    return waterCount;
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
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  bottomRight: Radius.circular(50))),
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
                                padding: const EdgeInsets.all(10.0),
                                child: FutureBuilder(
                                  future: _dbHelper.retrieveUserInfo("Name"),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString() != "null"
                                          ? snapshot.data.toString()
                                          : "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: "Times"),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                      padding: EdgeInsets.all(0),
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                            width: 150,
                            height: 150,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            decoration: BoxDecoration(
                                color: Color(0xFF1F3546),
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: SfRadialGauge(
                                enableLoadingAnimation: true,
                                animationDuration: 2500,
                                title: GaugeTitle(
                                  text: "Weekly Workout Goals:",
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 0,
                                      maximum: 10,
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 1,
                                      canScaleToFit: false,
                                      axisLineStyle: AxisLineStyle(
                                        thickness: 0.15,
                                        cornerStyle: CornerStyle.bothCurve,
                                        color: Color.fromARGB(30, 0, 169, 181),
                                        thicknessUnit: GaugeSizeUnit.factor,
                                      ),
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                            enableAnimation: true,
                                            animationDuration: 2500,
                                            animationType:
                                                AnimationType.easeOutBack,
                                            value: workoutGoals,
                                            width: 0.15,
                                            sizeUnit: GaugeSizeUnit.factor,
                                            cornerStyle: CornerStyle.bothCurve,
                                            gradient: const SweepGradient(
                                                colors: <Color>[
                                                  Color(0xFF00a9b5),
                                                  Colors.green,
                                                ],
                                                stops: <double>[
                                                  0.25,
                                                  0.75
                                                ])),
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            positionFactor: 0.1,
                                            angle: 90,
                                            widget: Text.rich(TextSpan(
                                                text: workoutGoals.toString() !=
                                                        "null"
                                                    ? workoutGoals.toString()
                                                    : "0",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                                children: [
                                                  TextSpan(
                                                    text: "%",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                ])))
                                      ])
                                ])),
                        Flexible(
                          flex: 2,
                          child: Container(
                            height: 150,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color(0xFF1F3546),
                                borderRadius: BorderRadius.circular(20)),
                            margin:
                                EdgeInsets.only(right: 10, top: 5, bottom: 5),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FutureBuilder(
                                      future: _dbHelper.retrieveWater(),
                                      builder: (context, snapshot) {
                                        return Text.rich(TextSpan(
                                            text: "Water : ",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    snapshot.data.toString() !=
                                                            "null"
                                                        ? waterCountString
                                                        : "0",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(text: " / 15")
                                            ]));
                                      }),
                                  FutureBuilder(
                                      future: _dbHelper.retrieveWater(),
                                      builder: (context, snapshot) {
                                        String a =
                                            snapshot.data.toString() != "null"
                                                ? snapshot.data.toString()
                                                : "0";
                                        var doubleValue = double.parse(a);

                                        return SfLinearGauge(
                                          minimum: 0,
                                          maximum: 15,
                                          showAxisTrack: true,
                                          showTicks: false,
                                          showLabels: false,
                                          axisTrackStyle: LinearAxisTrackStyle(
                                            color: Colors.white30,
                                            edgeStyle:
                                                LinearEdgeStyle.bothCurve,
                                            thickness: 10,
                                          ),
                                          barPointers: [
                                            LinearBarPointer(
                                              value: doubleValue,
                                              shaderCallback: (bounds) =>
                                                  LinearGradient(
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: [
                                                    Colors.lightBlueAccent,
                                                    Colors.blue
                                                  ]).createShader(bounds),
                                              thickness: 10,
                                              edgeStyle:
                                                  LinearEdgeStyle.bothCurve,
                                              position:
                                                  LinearElementPosition.cross,
                                              color: Colors.green,
                                              animationType:
                                                  LinearAnimationType.ease,
                                              animationDuration: 2500,
                                            )
                                          ],
                                        );
                                      }),
                                  Text(
                                    "Calorie Intake : 1553 / 2000",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SfLinearGauge(
                                    minimum: 0,
                                    maximum: 100,
                                    showAxisTrack: true,
                                    showTicks: false,
                                    showLabels: false,
                                    axisTrackStyle: LinearAxisTrackStyle(
                                      color: Colors.white30,
                                      edgeStyle: LinearEdgeStyle.bothCurve,
                                      thickness: 10,
                                    ),
                                    barPointers: [
                                      LinearBarPointer(
                                        value: 80,
                                        shaderCallback: (bounds) =>
                                            LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                              Colors.yellow[200],
                                              Colors.yellow[600]
                                            ]).createShader(bounds),
                                        thickness: 10,
                                        edgeStyle: LinearEdgeStyle.bothCurve,
                                        position: LinearElementPosition.cross,
                                        color: Colors.green,
                                        animationType: LinearAnimationType.ease,
                                        animationDuration: 2500,
                                      )
                                    ],
                                  ),
                                  FutureBuilder(
                                      future: _dbHelper.retrieveSuppCount(),
                                      builder: (context, snapshot) {
                                        return Text.rich(TextSpan(
                                            text: "Supplement : ",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: snapshot.data
                                                            .toString() !=
                                                        "null"
                                                    ? snapshot.data.toString()
                                                    : "0",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(text: " / 6")
                                            ]));
                                      }),
                                  SizedBox(
                                      height: 20,
                                      width: 180,
                                      child: FutureBuilder(
                                          initialData: [],
                                          future:
                                              _dbHelper.retrieveSupplement(),
                                          builder: (context, snapshot) {
                                            return Center(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (context, index) {
                                                  if (snapshot
                                                          .data[index].type ==
                                                      "Post") {
                                                    iconColor = Colors.green;
                                                  } else {
                                                    iconColor = Colors.orange;
                                                  }
                                                  return Icon(
                                                    Icons.local_fire_department,
                                                    color: iconColor,
                                                    size: 20,
                                                  );
                                                },
                                              ),
                                            );
                                          }))
                                ]),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Color(0xFF1F3546),
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: TableCalendar(
                        events: _events,
                        //availableCalendarFormats: const{ CalendarFormat.month: "Month"},
                        availableGestures: AvailableGestures.horizontalSwipe,
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
                            canEventMarkersOverflow: false,
                            //cellMargin: EdgeInsets.all(5),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 5,
                            ),
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
                                margin: const EdgeInsets.all(4),
                                width: 9,
                                height: 9,
                              ),
                            ];
                          },
                          selectedDayBuilder: (context, date, events) =>
                              //Todo Tap on selectedDay will also update today's gauge and charts water, calorie, supplement
                              Container(
                            margin: const EdgeInsets.all(0),
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
                              margin: const EdgeInsets.all(0),
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
                          onTap: () => Navigator.push(
                              //TODO ontap to expand down showing workout detail with little arrow to go to history screen
                              //TODO use ExpansionPanel
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HistoryScreen())),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF1F3546),
                              borderRadius: BorderRadius.circular(20),
                              //border: Border.all(color: Color(0xFF30A9B2)),
                            ),
                            height: MediaQuery.of(context).size.height / 20,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
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
          ),
          FabCircularMenu(
              fabMargin: EdgeInsets.only(
                  right: 30, bottom: kBottomNavigationBarHeight + 30),
              ringWidth: 60,
              ringDiameter: 250,
              fabColor: Colors.teal,
              ringColor: Colors.teal[400],
              fabOpenIcon: Image.asset(
                "assets/images/goals_icon.png",
                scale: 12,
              ),
              children: <Widget>[
                IconButton(
                    icon: Image.asset(
                      "assets/images/water9.png",
                      //color: Colors.white,
                      scale: 1,
                    ),
                    onPressed: () async {
                      Water addWater = Water(
                        litre: 1,
                      );
                      waterID = await _dbHelper.insertWater(addWater);
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: new Text("Water intake recorded."),
                        duration: Duration(seconds: 1),
                      ));
                      setState(() {
                        getTotalWater();
                      });
                      print('Added Water');
                    }),
                IconButton(
                    icon: Image.asset(
                      "assets/images/protein.png",
                      scale: 1,
                    ),
                    onPressed: () {
                      _showSupplementDialog();
                    }),
                IconButton(
                    icon: Image.asset(
                      "assets/images/dumbbell2.png",
                      scale: 1,
                    ),
                    onPressed: () {
                      // ignore: unnecessary_statements
                      workoutGoals++;
                      setState(() {});
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return StatefulBuilder(
                      //           builder: (context, setState) {
                      //         return AlertDialog(
                      //           backgroundColor: Color(0xFF1F3546),
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(20))),
                      //           title: Text("Today's Achievement: "),
                      //           titleTextStyle: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 20,
                      //               fontWeight: FontWeight.bold),
                      //           content: SingleChildScrollView(
                      //             child: Column(
                      //               children: [
                      //                 Container(
                      //                     width: double.infinity,
                      //                     //margin: EdgeInsets.only(left: 25, right: 25),
                      //                     padding: EdgeInsets.only(left: 10),
                      //                     decoration: BoxDecoration(
                      //                       color: Colors.black,
                      //                       borderRadius: BorderRadius.all(
                      //                         Radius.circular(10),
                      //                       ),
                      //                     ),
                      //                     child:
                      //                         new DropdownButtonHideUnderline(
                      //                       child: DropdownButton<String>(
                      //                         focusColor: Colors.green,
                      //                         dropdownColor: Colors.black,
                      //                         value: _chosenValue,
                      //                         //style: TextStyle(color: Colors.pink),
                      //                         hint: Text(
                      //                           "Muscle Focus",
                      //                           style: TextStyle(
                      //                               color: Colors.grey),
                      //                         ),
                      //                         iconEnabledColor: Colors.red,
                      //                         items: <String>[
                      //                           "Chest",
                      //                           "Abs",
                      //                           "Biceps",
                      //                           "Triceps",
                      //                           "Shoulders",
                      //                           "Forearm",
                      //                           "Hips",
                      //                           "Thigh",
                      //                           "Calves",
                      //                           "Whole Body",
                      //                         ].map<DropdownMenuItem<String>>(
                      //                             (String value) {
                      //                           return DropdownMenuItem<String>(
                      //                               value: value,
                      //                               child: Text(
                      //                                 value,
                      //                                 style: TextStyle(
                      //                                     color: Colors.white),
                      //                               ));
                      //                         }).toList(),
                      //                         onChanged: (String newValue) {
                      //                           setState(() {
                      //                             _chosenValue = newValue;
                      //                           });
                      //                         },
                      //                       ),
                      //                     )),
                      //                 SizedBox(
                      //                   height: 10,
                      //                 ),
                      //                 Container(
                      //                   width: double.infinity,
                      //                   //margin: EdgeInsets.only(left: 25, right: 25),
                      //                   padding: EdgeInsets.only(left: 10),
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.black,
                      //                     borderRadius: BorderRadius.all(
                      //                       Radius.circular(10),
                      //                     ),
                      //                   ),
                      //                   child: TextField(
                      //                       controller: _eventController,
                      //                       decoration: InputDecoration(
                      //                         hintText: "Exercise Name: ",
                      //                         hintStyle:
                      //                             TextStyle(color: Colors.grey),
                      //                       ),
                      //                       style: TextStyle(
                      //                         color: Colors.white,
                      //                       )),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 15,
                      //                 ),
                      //                 Text(
                      //                   "Set Count: ",
                      //                   style: TextStyle(color: Colors.white),
                      //                 ),
                      //                 Container(
                      //                   margin: EdgeInsets.only(
                      //                       left: 30, right: 30),
                      //                   //padding: EdgeInsets.only(left: 10),
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.black,
                      //                     borderRadius: BorderRadius.all(
                      //                       Radius.circular(10),
                      //                     ),
                      //                   ),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceAround,
                      //                     children: [
                      //                       IconButton(
                      //                         icon: Icon(
                      //                           Icons.remove,
                      //                           color: Theme.of(context)
                      //                               .accentColor,
                      //                         ),
                      //                         padding: EdgeInsets.symmetric(
                      //                             vertical: 4.0,
                      //                             horizontal: 18.0),
                      //                         iconSize: 32.0,
                      //                         color: Theme.of(context)
                      //                             .primaryColor,
                      //                         onPressed: () {
                      //                           setState(() {
                      //                             if (counter >= 1) counter--;
                      //                           });
                      //                         },
                      //                       ),
                      //                       Text(
                      //                         '$counter',
                      //                         textAlign: TextAlign.center,
                      //                         style: TextStyle(
                      //                           color: Colors.white,
                      //                           fontSize: 18.0,
                      //                           fontWeight: FontWeight.w500,
                      //                         ),
                      //                       ),
                      //                       IconButton(
                      //                         icon: Icon(
                      //                           Icons.add,
                      //                           color: Theme.of(context)
                      //                               .accentColor,
                      //                         ),
                      //                         padding: EdgeInsets.symmetric(
                      //                             vertical: 4.0,
                      //                             horizontal: 18.0),
                      //                         iconSize: 32.0,
                      //                         color: Theme.of(context)
                      //                             .primaryColor,
                      //                         onPressed: () {
                      //                           setState(() {
                      //                             counter++;
                      //                             //onChanged(counter);
                      //                           });
                      //                         },
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           actions: <Widget>[
                      //             TextButton(
                      //                 child: Text(
                      //                   "Cancel",
                      //                   style: TextStyle(color: Colors.white),
                      //                 ),
                      //                 onPressed: () {
                      //                   _eventController.clear();
                      //                   _chosenValue = null;
                      //                   counter = 0;
                      //                   Navigator.pop(context);
                      //                 }),
                      //             TextButton(
                      //               child: Text("Save"),
                      //               style: TextButton.styleFrom(
                      //                 primary: Colors.white,
                      //                 backgroundColor: Colors.teal,
                      //                 shadowColor: Colors.black,
                      //                 elevation: 5,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius:
                      //                       BorderRadius.circular(10.0),
                      //                 ),
                      //               ),
                      //               onPressed: () async {
                      //                 if (_eventController.text.isEmpty) {
                      //                   return;
                      //                 }
                      //                 //Save activity to Database
                      //                 String a = _calendarController.selectedDay
                      //                     .toString();
                      //
                      //                 Activities _newActivity = Activities(
                      //                     activity: _eventController.text,
                      //                     focus: _chosenValue,
                      //                     setCount: counter,
                      //                     date: a.substring(0, 10));
                      //                 _actID = await _dbHelper
                      //                     .insertActivity(_newActivity);
                      //                 setState(() {
                      //                   if (_events[_calendarController
                      //                           .selectedDay] !=
                      //                       null) {
                      //                     _events[_calendarController
                      //                             .selectedDay]
                      //                         .add(_eventController.text);
                      //                   } else {
                      //                     _events[_calendarController
                      //                         .selectedDay] = [
                      //                       _eventController.text
                      //                     ];
                      //                   }
                      //                   prefs.setString("events",
                      //                       json.encode(encodeMap(_events)));
                      //                   //_focus = _chosenValue;
                      //                   // prefs.setString(
                      //                   //   "focus", _chosenValue);
                      //                   //print(_events);
                      //                   _eventController.clear();
                      //                   _chosenValue = null;
                      //                   counter = 0;
                      //                   Navigator.pop(context);
                      //                 });
                      //               },
                      //             )
                      //           ],
                      //         );
                      //       });
                      //     });
                    })
              ])
          //TODO add another button to show history screen
        ]),
      ),
    );
  }

  _showSupplementDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xFF1F3546),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text("Supplement Intake"),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              content: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 'first';
                      });
                    },
                    child: Container(
                      //padding: EdgeInsets.all(10),
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: selected == 'first'
                                ? Colors.orange
                                : Colors.grey),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "PRE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected == 'first'
                                    ? Colors.orange
                                    : Colors.grey),
                          ),
                          Text(
                            "Workout",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: selected == 'first'
                                    ? Colors.orange
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 'second';
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: selected == 'second'
                                ? Colors.green
                                : Colors.grey),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "POST",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected == 'second'
                                    ? Colors.green
                                    : Colors.grey),
                          ),
                          Text(
                            "Workout",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: selected == 'second'
                                    ? Colors.green
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      selected = null;
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
                      Supplement addSupplement = Supplement(
                        supplement: "Protein",
                        type: "Post",
                      );
                      await _dbHelper.insertSupplement(addSupplement);
                      print("Added supplement");
                      setState(() {
                        Navigator.pop(context);
                      });
                    })
              ],
            );
          });
        });
  }
}
