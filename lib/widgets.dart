import 'package:calendar/model/timerPainter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class HistoryWidget extends StatelessWidget {
  final String activity;
  final String date;
  final String focus;
  final int setCount;

  HistoryWidget({this.activity, this.date, this.focus, this.setCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.grey,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      //margin: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        margin: EdgeInsets.only(bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity ?? "Unnamed Task",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    date ?? 'No description added.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500], height: 1.5),
                  ),
                )
              ],
            ),
            Text(
              focus.toString(),
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "Sets: " + setCount.toString(),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryWidgetChart extends StatelessWidget {
  //final String activity;
  final String date;
  final String part;
  final String left;
  final double right;
  final double count;

  HistoryWidgetChart({this.date, this.part, this.count, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //color: Colors.blue,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date ?? 'No date',
                style: TextStyle(
                    fontSize: 12, color: Colors.white, ),
              ),

              Text(
                count.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Divider(thickness: 1, height: 10, color: Colors.grey[700], indent: 10, endIndent: 10,),
        ],
      ),
    );
  }
}

class HistoryWidgetChart2Parts extends StatelessWidget {
  //final String activity;
  final String date;
  final String part;
  final double left;
  final double right;
  final double count;

  HistoryWidgetChart2Parts({this.date, this.part, this.count, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //color: Colors.blue,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date ?? 'No date',
                style: TextStyle(
                  fontSize: 12, color: Colors.white, ),
              ),

              Text(
                "Left: " + left.toString(),
                style: TextStyle(color: Color(0xff4af699)),
              ),

              Text(
                "Right: " + right.toString(),
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          Divider(thickness: 1, height: 10, color: Colors.grey[700], indent: 10, endIndent: 10,),
        ],
      ),
    );
  }
}

class WeightWidget extends StatefulWidget {
  final String parts;
  final String measurement;

  WeightWidget({this.parts, this.measurement});

  @override
  _WeightWidgetState createState() => _WeightWidgetState();
}

class _WeightWidgetState extends State<WeightWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: Column(
        children: [
          Text(
            widget.parts,
            style: TextStyle(
                color: Color(0xFF30A9B2), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            //margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            //width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xff374250).withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Color(0xFF30A9B2)),
            ),
            child:
                Text(widget.measurement, style: TextStyle(color: Colors.white)),
          ),
        ],
      )),
    );
  }
}

class ArmWidget extends StatelessWidget {
  final String twoPart;
  final String leftMeasurement;
  final String rightMeasurement;

  ArmWidget({this.twoPart, this.leftMeasurement, this.rightMeasurement});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            twoPart,
            style: TextStyle(
                color: Color(0xFF30A9B2), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                //width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                  color: Color(0xFF1F3546),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF30A9B2)),
                ),
                child: Text(
                  "L",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(5),
                //width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff374250).withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF30A9B2)),
                ),
                child: Text(
                  leftMeasurement,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                //width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                  color: Color(0xFF1F3546),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF30A9B2)),
                ),
                child: Text(
                  "R",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(5),
                //width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff374250).withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF30A9B2)),
                ),
                child: Text(
                  rightMeasurement,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController animationController;

  //int theTime = 5;
  //ValueNotifier addSecond = ValueNotifier(false);

  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes.toString().padLeft(1, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(minutes: 0, seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Countdown Timer"),
          elevation: 10,
          centerTitle: true,
          backgroundColor: Color(0xFF1F3546),
          brightness: Brightness.light,
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black),
        ),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? 0.0
                  : kBottomNavigationBarHeight,
            ),
            child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.blueGrey,
                          height: animationController.value *
                              MediaQuery.of(context).size.height,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: FractionalOffset.center,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: CustomTimerPainter(
                                              animation: animationController,
                                              backgroundColor: Colors.black,
                                              color: Colors.red),
                                        ),
                                      ),
                                      Align(
                                        alignment: FractionalOffset.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "30 seconds",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              timerString,
                                              style: TextStyle(
                                                  fontSize: 112.0,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       Column(children: [
                            //         TextButton(
                            //           onPressed: () {},
                            //           child: Text("+1"),
                            //           style: TextButton.styleFrom(
                            //               primary: Colors.white,
                            //               backgroundColor: Colors.teal,
                            //               shadowColor: Colors.black,
                            //               elevation: 5,
                            //               shape: RoundedRectangleBorder(
                            //                   borderRadius:
                            //                       BorderRadius.circular(10))),
                            //         ),
                            //         Text("min",
                            //             style: TextStyle(color: Colors.white)),
                            //       ]),
                            //       Column(
                            //         children: [
                            //           TextButton(
                            //             onPressed: () {},
                            //             child: Text("+15"),
                            //             style: TextButton.styleFrom(
                            //                 primary: Colors.white,
                            //                 backgroundColor: Colors.teal,
                            //                 shadowColor: Colors.black,
                            //                 elevation: 5,
                            //                 shape: RoundedRectangleBorder(
                            //                     borderRadius:
                            //                         BorderRadius.circular(10))),
                            //           ),
                            //           Text("sec",
                            //               style: TextStyle(color: Colors.white)),
                            //         ],
                            //       ),
                            //       Column(children: [
                            //         MaterialButton(
                            //           onPressed: () {
                            //             setState(() {
                            //             });
                            //           },
                            //           child: Text("+5", style: TextStyle(color: Colors.white),),
                            //               color: Colors.teal,
                            //               elevation: 5,
                            //               shape: CircleBorder(),
                            //         ),
                            //         Text(
                            //           "sec",
                            //           style: TextStyle(color: Colors.white),
                            //         )
                            //       ]),
                            //     ]),
                            SizedBox(
                              height: 30.0,
                            ),
                            AnimatedBuilder(
                                animation: animationController,
                                builder: (context, child) {
                                  return FloatingActionButton.extended(
                                      backgroundColor: Colors.teal[300],
                                      onPressed: () {
                                        if (animationController.isAnimating)
                                          animationController.stop();
                                        else {
                                          animationController.reverse(
                                              from: animationController.value ==
                                                      0.0
                                                  ? 1.0
                                                  : animationController.value);
                                        }
                                      },
                                      icon: Icon(animationController.isAnimating
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                      label: Text(
                                          animationController.isAnimating
                                              ? "Pause"
                                              : "Start"));
                                }),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
