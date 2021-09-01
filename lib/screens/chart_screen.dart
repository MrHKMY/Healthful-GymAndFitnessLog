import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
import 'package:calendar/model/progress.dart';
import 'package:calendar/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slimy_card/slimy_card.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<Progress> weight = <Progress>[];
  List<Progress> chest = <Progress>[];
  List<Progress> waist = <Progress>[];
  List<Progress> hips = <Progress>[];
  List<Progress> upperArm = <Progress>[];
  List<Progress> forearm = <Progress>[];
  List<Progress> thigh = <Progress>[];
  List<Progress> calf = <Progress>[];

  List<FlSpot> spotDataWeight = [];
  List<FlSpot> spotDataChest = [];
  List<FlSpot> spotDataWaist = [];
  List<FlSpot> spotDataHips = [];
  List<FlSpot> spotDataUpperArmL = [];
  List<FlSpot> spotDataUpperArmR = [];
  List<FlSpot> spotDataForearmL = [];
  List<FlSpot> spotDataForearmR = [];
  List<FlSpot> spotDataThighL = [];
  List<FlSpot> spotDataThighR = [];
  List<FlSpot> spotDataCalfL = [];
  List<FlSpot> spotDataCalfR = [];

  int x = 1;

  getWeightChart(int a) async {
    weight = await _dbHelper.retrieveWeightForChart("Weight");
    Iterable inReverse = weight.reversed;
    var reversed = inReverse.toList();

    if (a == 1) {
      for (int x = 0; x < reversed.length; x++) {
        spotDataWeight.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversed[x].center.toString())));
        a = 2;
      }
    }
    return weight;
  }

  getChestChart(int b) async {
    chest = await _dbHelper.retrieveWeightForChart("Chest");
    Iterable inReverse = chest.reversed;
    var reversed = inReverse.toList();

    if (b == 1) {
      for (int a = 0; a < reversed.length; a++) {
        spotDataChest.add(FlSpot(double.parse((a + 1).toString()),
            double.parse(reversed[a].center.toString())));
        b = 2;
      }
    }

    return chest;
  }

  getWaistChart(int b) async {
    waist = await _dbHelper.retrieveWeightForChart("Waist");
    //print(activity[0].setCount.toString());
    Iterable inReverse = waist.reversed;
    var reversed = inReverse.toList();

    if (b == 1) {
      for (int a = 0; a < reversed.length; a++) {
        spotDataWaist.add(FlSpot(double.parse((a + 1).toString()),
            double.parse(reversed[a].center.toString())));
        b = 2;
      }
    }

    return waist;
  }

  getHipsChart(int b) async {
    hips = await _dbHelper.retrieveWeightForChart("Hips");
    //print(activity[0].setCount.toString());
    Iterable inReverse = hips.reversed;
    var reversed = inReverse.toList();

    if (b == 1) {
      for (int a = 0; a < reversed.length; a++) {
        spotDataHips.add(FlSpot(double.parse((a + 1).toString()),
            double.parse(reversed[a].center.toString())));
        b = 2;
      }
    }

    return hips;
  }

  getUpperArmChart(int a) async {
    upperArm = await _dbHelper.retrieve2PartsForChart("Upper Arm");
    //upperArmR = await _dbHelper.retrieve2PartsForChart("Upper Arm", "Right");

    Iterable inReverse = upperArm.reversed;
    var reversedL = inReverse.toList();

    if (a == 1) {
      for (int x = 0; x < reversedL.length; x++) {
        spotDataUpperArmL.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversedL[x].left.toString())));

        spotDataUpperArmR.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversedL[x].right.toString())));
        a = 2;
      }
    }
    return upperArm;
  }

  getForearmChart(int a) async {
    forearm = await _dbHelper.retrieve2PartsForChart("Forearm");
    //forearmR = await _dbHelper.retrieve2PartsForChart("Forearm", "Right");

    Iterable inReverse = forearm.reversed;
    var reversedL = inReverse.toList();

    if (a == 1) {
      for (int x = 0; x < reversedL.length; x++) {
        spotDataForearmL.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversedL[x].left.toString())));

        spotDataForearmR.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversedL[x].right.toString())));
        a = 2;
      }
    }
    return forearm;
  }

  getThighChart(int a) async {
    thigh = await _dbHelper.retrieve2PartsForChart("Thigh");
    //forearmR = await _dbHelper.retrieve2PartsForChart("Forearm", "Right");

    Iterable inReverse = thigh.reversed;
    var reversedL = inReverse.toList();

    if (a == 1) {
      for (int x = 0; x < reversedL.length; x++) {
        spotDataThighL.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversedL[x].left.toString())));

        spotDataThighR.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversedL[x].right.toString())));
        a = 2;
      }
    }
    return thigh;
  }

  getCalfChart(int a) async {
    calf = await _dbHelper.retrieve2PartsForChart("Calf");
    //forearmR = await _dbHelper.retrieve2PartsForChart("Forearm", "Right");

    Iterable inReverse = calf.reversed;
    var reversedL = inReverse.toList();

    if (a == 1) {
      for (int x = 0; x < reversedL.length; x++) {
        spotDataCalfL.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversedL[x].left.toString())));

        spotDataCalfR.add(FlSpot(double.parse((x + 1).toString()),
            double.parse(reversedL[x].right.toString())));
        a = 2;
      }
    }
    return calf;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getData();

    List allCharts = [
      weightChart(),
      chestChart(),
      waistChart(),
      hipsChart(),
      upperArmChart(),
      forearmChart(),
      thighChart(),
      calfChart(),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text("All-time Charts"),
          elevation: 10,
          centerTitle: true,
          backgroundColor: Color(0xFF1F3546),
          brightness: Brightness.light,
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: CarouselSlider(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              height: double.infinity,
              //autoPlay: true,
              // autoPlayInterval: Duration(seconds: 3),
              // autoPlayAnimationDuration: Duration(milliseconds: 800),
              // autoPlayCurve: Curves.fastOutSlowIn,
              // pauseAutoPlayOnTouch: true,
            ),
            items: allCharts.map((card) {
              return Builder(builder: (BuildContext context) {
                return Container(
                  height: double.infinity,
                  child: card,
                );
              });
            }).toList(),
          ),
        ));
  }

  // ListView(
  //   shrinkWrap: false,
  //   padding: EdgeInsets.all(10),
  //   children: [
  //     SlimyCard(
  //       color: Color(0xFF1F3546),
  //       width: 400,
  //       topCardHeight: 400,
  //       bottomCardHeight: 100,
  //       borderRadius: 20,
  //       slimeEnabled: false,
  //       topCardWidget: chartOne(),
  //       bottomCardWidget: detailOne()
  //     )
  //   ],
  // ),

  Widget bottomSlime(String focus) {
    return Container(
        decoration: BoxDecoration(
          //color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Expanded(
              child: FutureBuilder(
                  initialData: [],
                  future: _dbHelper.retrieveWeightForChart(focus),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                          return HistoryWidgetChart(
                            date: snapshot.data[index].date,
                            count: snapshot.data[index].center,
                            part: snapshot.data[index].bodyPart,
                          );
                      },
                    );
                  })
          ),
        ])
    );
  }

  Widget bottomSlime2Parts(String focus) {
    return Container(
        decoration: BoxDecoration(
          //color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Expanded(
              child: FutureBuilder(
                  initialData: [],
                  future: _dbHelper.retrieveWeightForChart(focus),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return HistoryWidgetChart2Parts(
                          date: snapshot.data[index].date,
                          left: snapshot.data[index].left,
                          right: snapshot.data[index].right,
                        );
                      },
                    );
                  })
          ),
        ])
    );
  }

  Widget weightChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 200,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: weightOne(),
            bottomCardWidget: bottomSlime("Weight"))
      ],
    );
  }

  Widget weightOne() {
    return Column(
      children: [
        FutureBuilder(
            future: getWeightChart(1),
            builder: (context, snapshot) {
              if (weight.isNotEmpty) {
                switch (snapshot.connectionState) {
                  // Uncompleted State
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    // Completed with error
                    if (snapshot.hasError)
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(
                            left: 0, right: 10, bottom: 5, top: 20),
                        child: LineChart(LineChartData(
                            minY: 0,
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor:
                                    Colors.blueGrey.withOpacity(0.8),
                              ),
                              touchCallback:
                                  (LineTouchResponse touchResponse) {},
                              handleBuiltInTouches: true,
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                margin: 5,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotDataWeight,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
                }
              } else {
                return Container(
                    height: 250,
                    child: Center(
                        child: Text(
                      "Not enough data to plot charts",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )));
              }
            }),
        SizedBox(height: 30),
        Text(
          "Weight",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget chestChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 200,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: chestsOne(),
            bottomCardWidget: bottomSlime("Chest"))
      ],
    );
  }

  Widget chestsOne() {
    return Column(
      children: [
        FutureBuilder(
            future: getChestChart(1),
            builder: (context, snapshot) {
              if (chest.isNotEmpty) {
                switch (snapshot.connectionState) {
                  // Uncompleted State
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    // Completed with error
                    if (snapshot.hasError)
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(
                            left: 0, right: 10, bottom: 5, top: 20),
                        child: LineChart(LineChartData(
                            minY: 0,
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor:
                                    Colors.blueGrey.withOpacity(0.8),
                              ),
                              touchCallback:
                                  (LineTouchResponse touchResponse) {},
                              handleBuiltInTouches: true,
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
                                interval: 5,
                                margin: 5,
                                showTitles: true,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotDataChest,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
                }
              } else {
                return Container(
                    height: 250,
                    child: Center(
                        child: Text(
                      "Not enough data to plot charts",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )));
              }
            }),
        SizedBox(height: 30),
        Text(
          "Chest",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget waistChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 200,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: waistOne(),
            bottomCardWidget: bottomSlime("Waist"))
      ],
    );
  }

  Widget waistOne() {
    return Column(
      children: [
        FutureBuilder(
            future: getWaistChart(1),
            builder: (context, snapshot) {
              if (waist.isNotEmpty) {
                switch (snapshot.connectionState) {
                  // Uncompleted State
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    // Completed with error
                    if (snapshot.hasError)
                      return Container(child: Text(snapshot.error.toString()));

                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(
                            left: 0, right: 10, bottom: 5, top: 20),
                        child: LineChart(LineChartData(
                            minY: 0,
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor:
                                    Colors.blueGrey.withOpacity(0.8),
                              ),
                              touchCallback:
                                  (LineTouchResponse touchResponse) {},
                              handleBuiltInTouches: true,
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                margin: 5,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotDataWaist,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
                }
              } else {
                return Container(
                    height: 250,
                    child: Center(
                        child: Text(
                      "Not enough data to plot charts",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )));
              }
            }),
        SizedBox(height: 30),
        Text(
          "Waist",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget hipsChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 200,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: hipsOne(),
            bottomCardWidget: bottomSlime("Hips"))
      ],
    );
  }

  Widget hipsOne() {
    return Column(
      children: [
        FutureBuilder(
            future: getHipsChart(1),
            builder: (context, snapshot) {
              if (hips.isNotEmpty) {
                switch (snapshot.connectionState) {
                  // Uncompleted State
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    // Completed with error
                    if (snapshot.hasError)
                      return Container(child: Text(snapshot.error.toString()));

                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(
                            left: 0, right: 10, bottom: 5, top: 20),
                        child: LineChart(LineChartData(
                            minY: 0,
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor:
                                    Colors.blueGrey.withOpacity(0.8),
                              ),
                              touchCallback:
                                  (LineTouchResponse touchResponse) {},
                              handleBuiltInTouches: true,
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                margin: 5,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotDataHips,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
                }
              } else {
                return Container(
                    height: 250,
                    child: Center(
                        child: Text(
                      "Not enough data to plot charts",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )));
              }
            }),
        SizedBox(height: 30),
        Text(
          "Hips",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget upperArmChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 200,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: upperArmOne(),
            bottomCardWidget: bottomSlime2Parts("Upper Arm"))
      ],
    );
  }

  Widget upperArmOne() {
    return Column(
      children: [
        FutureBuilder(
            future: getUpperArmChart(1),
            builder: (context, snapshot) {
              if (upperArm.isNotEmpty) {
                switch (snapshot.connectionState) {
                  // Uncompleted State
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    // Completed with error
                    if (snapshot.hasError)
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(
                            left: 0, right: 10, bottom: 5, top: 20),
                        child: LineChart(LineChartData(
                            minY: 0,
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor:
                                    Colors.blueGrey.withOpacity(0.8),
                              ),
                              touchCallback:
                                  (LineTouchResponse touchResponse) {},
                              handleBuiltInTouches: true,
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                margin: 5,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotDataUpperArmL,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                              LineChartBarData(
                                spots: spotDataUpperArmR,
                                isCurved: true,
                                colors: [Colors.blue],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Colors.blue.withOpacity(0.2)
                                ]),
                              )
                            ])));
                }
              } else {
                return Container(
                    height: 250,
                    child: Center(
                        child: Text(
                      "Not enough data to plot charts",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )));
              }
            }),
        SizedBox(height: 30),
        Text(
          "Upper Arm",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget forearmChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 200,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: foreArmOne(),
            bottomCardWidget: bottomSlime2Parts("Forearm"))
      ],
    );
  }

  Widget foreArmOne() {
    return Column(
      children: [
        FutureBuilder(
            future: getForearmChart(1),
            builder: (context, snapshot) {
    if (forearm.isNotEmpty) {
              switch (snapshot.connectionState) {
                // Uncompleted State
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  // Completed with error
                  if (snapshot.hasError)
                    return Container(child: Text(snapshot.error.toString()));
                  return Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.only(
                          left: 0, right: 10, bottom: 5, top: 20),
                      child: LineChart(LineChartData(
                          minY: 0,
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                            ),
                            touchCallback: (LineTouchResponse touchResponse) {},
                            handleBuiltInTouches: true,
                          ),
                          gridData: FlGridData(
                            show: false,
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 22,
                              getTextStyles: (value) => const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              interval: 5,
                              margin: 5,
                              getTextStyles: (value) => const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spotDataForearmL,
                              isCurved: true,
                              colors: [Color(0xff4af699)],
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                  show: true,
                                  colors: [Color(0xff4af699).withOpacity(0.2)]),
                            ),
                            LineChartBarData(
                              spots: spotDataForearmR,
                              isCurved: true,
                              colors: [Colors.blue],
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                  show: true,
                                  colors: [Colors.blue.withOpacity(0.2)]),
                            ),
                          ])));
              }} else {
      return Container(
          height: 250,
          child: Center(
              child: Text(
                "Not enough data to plot charts",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )));
    }
            }),
        SizedBox(height: 30),
        Text(
          "Forearm",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget thighChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 200,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: thighOne(),
            bottomCardWidget: bottomSlime2Parts("Thigh"))
      ],
    );
  }

  Widget thighOne() {
    return Column(
      children: [
        FutureBuilder(
            future: getThighChart(1),
            builder: (context, snapshot) {
              if (thigh.isNotEmpty) {
                switch (snapshot.connectionState) {
                // Uncompleted State
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                  // Completed with error
                    if (snapshot.hasError)
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(
                            left: 0, right: 10, bottom: 5, top: 20),
                        child: LineChart(LineChartData(
                            minY: 0,
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                              ),
                              touchCallback: (LineTouchResponse touchResponse) {},
                              handleBuiltInTouches: true,
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                margin: 5,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotDataThighL,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                    show: true,
                                    colors: [Color(0xff4af699).withOpacity(0.2)]),
                              ),
                              LineChartBarData(
                                spots: spotDataThighR,
                                isCurved: true,
                                colors: [Colors.blue],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                    show: true,
                                    colors: [Colors.blue.withOpacity(0.2)]),
                              ),
                            ])));
                }} else {
                return Container(
                    height: 250,
                    child: Center(
                        child: Text(
                          "Not enough data to plot charts",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        )));
              }
            }),
        SizedBox(height: 30),
        Text(
          "Thigh",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget calfChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 200,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: calfOne(),
            bottomCardWidget: bottomSlime2Parts("Calves"))
      ],
    );
  }

  Widget calfOne() {
    return Column(
      children: [
        FutureBuilder(
            future: getCalfChart(1),
            builder: (context, snapshot) {
              if (calf.isNotEmpty) {
                switch (snapshot.connectionState) {
                // Uncompleted State
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                  // Completed with error
                    if (snapshot.hasError)
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(
                            left: 0, right: 10, bottom: 5, top: 20),
                        child: LineChart(LineChartData(
                            minY: 0,
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                              ),
                              touchCallback: (LineTouchResponse touchResponse) {},
                              handleBuiltInTouches: true,
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                margin: 5,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotDataCalfL,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                    show: true,
                                    colors: [Color(0xff4af699).withOpacity(0.2)]),
                              ),
                              LineChartBarData(
                                spots: spotDataCalfR,
                                isCurved: true,
                                colors: [Colors.blue],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                    show: true,
                                    colors: [Colors.blue.withOpacity(0.2)]),
                              ),
                            ])));
                }} else {
                return Container(
                    height: 250,
                    child: Center(
                        child: Text(
                          "Not enough data to plot charts",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        )));
              }
            }),
        SizedBox(height: 30),
        Text(
          "Calf",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
