import 'dart:convert';
import 'dart:math';

import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
import 'package:calendar/model/nutrition.dart';
import 'package:calendar/model/userInfo.dart';
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
import 'package:unicorndial/unicorndial.dart';

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
  var iconColor;
  String quotes = "a";
  String selected;
  String _chosenValue;

  String prefWaterString;
  double prefWaterDouble = 20;
  String prefWorkString;
  double prefWorkDouble = 20;
  String prefSuppString;
  double prefSuppDouble = 20;
  String prefCalString;
  double prefCalDouble = 20;

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
    prefs.setBool('seen', true);
    prefWorkString = prefs.getString('prefWork');
    prefWaterString = prefs.getString('prefWater');
    prefSuppString = prefs.getString('prefSupp');
    prefCalString = prefs.getString('prefCal');

    //TODO remove the first 0 if exist eg : 01 for water and supp
    prefWorkDouble = double.parse(prefWorkString);
    prefWaterDouble = double.parse(prefWaterString);
    prefSuppDouble = double.parse(prefSuppString);
    prefCalDouble = double.parse(prefCalString);

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
    print("Water count: $waterCountString");
    waterCount =
        waterCountString != "null" ? double.parse(waterCountString) : 0;
    return waterCount;
  }

  refreshWidget() {
    setState(() {});
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var childButtons = List<UnicornButton>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Colors.grey[100],
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
                              color: Colors.teal[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[700],
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(2.0,
                                      2.0), // shadow direction: bottom right
                                )
                              ],
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
                            color: Colors.black,
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
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: FutureBuilder(
                                future: _dbHelper.retrieveWorkoutCount(),
                                builder: (context, snapshot) {
                                  String a = snapshot.data.toString() != "null"
                                      ? snapshot.data.toString()
                                      : "0";
                                  var doubleValue = double.parse(a);
                                  var percentage = num.parse(
                                      ((doubleValue / prefWorkDouble) * 100)
                                          .toStringAsFixed(0));
                                  String percentString = percentage.toString();
                                  // switch (snapshot.connectionState) {
                                  // // Uncompleted State
                                  // case ConnectionState.none:
                                  // case ConnectionState.waiting:
                                  // return Center(child: CircularProgressIndicator());
                                  // break;
                                  // default:
                                  // // Completed with error
                                  // if (snapshot.hasError)
                                  // return Container(
                                  // child: Text("?",style: TextStyle(color: Colors.grey)));
                                  return SfRadialGauge(
                                      enableLoadingAnimation: true,
                                      animationDuration: 2500,
                                      title: GaugeTitle(
                                        text: "Weekly Workout Goals:",
                                        textStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                            minimum: 0,
                                            maximum: prefWorkDouble,
                                            showLabels: false,
                                            showTicks: false,
                                            radiusFactor: 1,
                                            canScaleToFit: false,
                                            axisLineStyle: AxisLineStyle(
                                              thickness: 0.15,
                                              cornerStyle:
                                                  CornerStyle.bothCurve,
                                              color: Colors.grey[300],
                                              thicknessUnit:
                                                  GaugeSizeUnit.factor,
                                            ),
                                            pointers: <GaugePointer>[
                                              RangePointer(
                                                  enableAnimation: true,
                                                  animationDuration: 2500,
                                                  animationType:
                                                      AnimationType.easeOutBack,
                                                  value: doubleValue,
                                                  width: 0.15,
                                                  sizeUnit:
                                                      GaugeSizeUnit.factor,
                                                  cornerStyle:
                                                      CornerStyle.bothCurve,
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
                                                      text: snapshot.data
                                                                  .toString() !=
                                                              "null"
                                                          ? percentString
                                                          : "0",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                      children: [
                                                        TextSpan(
                                                          text: "%",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18),
                                                        ),
                                                      ])))
                                            ])
                                      ]);
                                })),
                        Flexible(
                          flex: 2,
                          child: Container(
                            height: 150,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ],
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
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    snapshot.data.toString() !=
                                                            "null"
                                                        ? waterCountString
                                                        : "0",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: " / $prefWaterString")
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
                                          maximum: prefWaterDouble,
                                          showAxisTrack: true,
                                          showTicks: false,
                                          showLabels: false,
                                          axisTrackStyle: LinearAxisTrackStyle(
                                            color: Colors.grey[300],
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
                                  //TODO CALORIE charts down here
                                  FutureBuilder(
                                      future: _dbHelper.retrieveCal(),
                                      builder: (context, snapshot) {
                                        return Text.rich(TextSpan(
                                            text: "Calorie : ",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: snapshot.data
                                                            .toString() !=
                                                        "null"
                                                    ? snapshot.data.toString()
                                                    : "0",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: " / $prefCalString")
                                            ]));
                                      }),
                                  FutureBuilder(
                                      future: _dbHelper.retrieveCal(),
                                      builder: (context, snapshot) {
                                        String a =
                                            snapshot.data.toString() != "null"
                                                ? snapshot.data.toString()
                                                : "0";
                                        var doubleValue = double.parse(a);
                                        return SfLinearGauge(
                                          minimum: 0,
                                          maximum: prefCalDouble,
                                          showAxisTrack: true,
                                          showTicks: false,
                                          showLabels: false,
                                          axisTrackStyle: LinearAxisTrackStyle(
                                            color: Colors.grey[300],
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
                                                    Colors.yellow[200],
                                                    Colors.yellow[600]
                                                  ]).createShader(bounds),
                                              thickness: 10,
                                              edgeStyle:
                                                  LinearEdgeStyle.bothCurve,
                                              position:
                                                  LinearElementPosition.cross,
                                              animationType:
                                                  LinearAnimationType.ease,
                                              animationDuration: 2500,
                                            )
                                          ],
                                        );
                                      }),
                                  FutureBuilder(
                                      future: _dbHelper.retrieveSuppCount(),
                                      builder: (context, snapshot) {
                                        return Text.rich(TextSpan(
                                            text: "Supplement : ",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: snapshot.data
                                                            .toString() !=
                                                        "null"
                                                    ? snapshot.data.toString()
                                                    : "0",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: " / $prefSuppString")
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
                                            if (snapshot.data.toString() ==
                                                "[]") {
                                              return Icon(
                                                Icons.local_fire_department,
                                                color: Colors.grey[300],
                                                size: 20,
                                              );
                                            } else {
                                              return Center(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      snapshot.data.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (snapshot
                                                            .data[index].type ==
                                                        "Post") {
                                                      iconColor = Colors.green;
                                                    } else {
                                                      iconColor = Colors.orange;
                                                    }
                                                    return Icon(
                                                      Icons
                                                          .local_fire_department,
                                                      color: iconColor,
                                                      size: 20,
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                          }))
                                ]),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                              color: Colors.black,
                              //fontWeight: FontWeight.bold
                            ),
                            weekendStyle: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.bold
                            ),
                            outsideStyle: TextStyle(color: Colors.grey),
                            unavailableStyle: TextStyle(color: Colors.grey),
                            outsideWeekendStyle: TextStyle(color: Colors.grey),
                            canEventMarkersOverflow: false,
                            //cellMargin: EdgeInsets.all(5),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 5,
                            ),
                            eventDayStyle: TextStyle(color: Colors.black)),
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
                            titleTextStyle: TextStyle(color: Colors.black),
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
                              style: TextStyle(color: Colors.black),
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
                                style: TextStyle(color: Colors.black),
                              )),
                        ),
                        //calendarController = _calendarController,
                      ),
                    ),
                    ..._selectedEvents.map((event) => GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HistoryScreen())),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(1.0,
                                      1.0), // shadow direction: bottom right
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
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
                                      color: Colors.black, fontSize: 14),
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
              fabColor: Colors.teal[300],
              fabOpenColor: Colors.white,
              ringColor: Colors.teal[300],
              fabOpenIcon: Image.asset(
                "assets/images/circle_icon_transparent.png",
                scale: 1,
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
                      _showWorkoutDialog();
                    })
              ])
        ]),
      ),
    );
  }

  _showWorkoutDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Center(child: Text("Today's Achievement: ")),
              titleTextStyle: TextStyle(
                  color: Colors.black,
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
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: new DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            focusColor: Colors.green,
                            dropdownColor: Colors.teal,
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
                                    style: TextStyle(color: Colors.black),
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
                        color: Colors.grey[300],
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
                            color: Colors.black,
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Set Count: ",
                      style: TextStyle(color: Colors.black),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      //padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.teal,
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
                          Text(
                            '$counter',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.teal,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 18.0),
                            iconSize: 32.0,
                            color: Theme.of(context).primaryColor,
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
                      style: TextStyle(color: Colors.grey),
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
                    String a = _calendarController.selectedDay.toString();

                    Activities _newActivity = Activities(
                        activity: _eventController.text,
                        focus: _chosenValue,
                        setCount: counter,
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
                      //_focus = _chosenValue;
                      // prefs.setString(
                      //   "focus", _chosenValue);
                      //print(_events);
                      _eventController.clear();
                      _chosenValue = null;
                      counter = 0;
                      Navigator.pop(context);
                      refreshWidget();
                    });
                  },
                )
              ],
            );
          });
        });
  }

  _showSupplementDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Center(child: Text("Supplement Intake")),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              content: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 'Pre';
                      });
                    },
                    child: Container(
                      //padding: EdgeInsets.all(10),
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        color: selected == 'Pre' ? Colors.orange : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "PRE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            "Workout",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 'Post';
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        color: selected == 'Post' ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "POST",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            "Workout",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.black),
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
                      style: TextStyle(color: Colors.grey),
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
                      if (selected != null) {
                        Supplement addSupplement = Supplement(
                          supplement: "Protein",
                          type: selected,
                        );
                        await _dbHelper.insertSupplement(addSupplement);
                        print("Added supplement");
                        selected = null;
                        Navigator.pop(context);
                        refreshWidget();
                      }
                    }),
              ],
            );
          });
        });
  }
}
