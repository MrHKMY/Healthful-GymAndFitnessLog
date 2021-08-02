import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<Activities> activity = <Activities>[];
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<FlSpot> spotData = [];
  int x = 1;

  getData() async {
    activity = await _dbHelper.retrieveActivity();
    //print(activity[0].setCount.toString());
    Iterable inReverse = activity.reversed;
    var reversed = inReverse.toList();

    if (x == 1) {
      for (int a = 0; a < activity.length; a++) {
        spotData.add(FlSpot(double.parse(activity[a].id.toString()),
            double.parse(activity[a].setCount.toString())));
        x = 2;
      }
    }

    print(spotData.toString());
    // List<FlSpot> spots =
    // activity.asMap().entries.map((e) {
    //   return FlSpot(e.key.toDouble(), e);
    // }).toList(),
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getData();

    return Scaffold(
        appBar: AppBar(
          title: Text("Progress Tracker"),
          elevation: 10,
          centerTitle: true,
          backgroundColor: Color(0xFF1F3546),
          brightness: Brightness.light,
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SafeArea(
            child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      color: Color(0xFF1F3546),
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(
                      left: 10, right: 10, bottom: 5, top: 10),
                  child: Column(
                    children: [
                  // Container(
                  //     width: 350,
                  //     height: 250,
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  //     decoration: BoxDecoration(
                  //         color: Color(0xFF1F3546),
                  //         borderRadius: BorderRadius.circular(20)),
                  //     margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  //     child: SfCartesianChart(
                  //         series: <ChartSeries<Activities, num>>[
                  //           SplineSeries<Activities, num>(
                  //               xAxisName: "Test",
                  //               cardinalSplineTension: 20,
                  //               color: Colors.green,
                  //               animationDuration: 2,
                  //               dataSource: activity,
                  //               xValueMapper: (Activities sales, _) =>
                  //                   sales.id,
                  //               yValueMapper: (Activities sales, _) =>
                  //                   sales.setCount,
                  //               name: 'Workout Chart')
                  //         ])),
                  Text(
                    "Frequency",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  FutureBuilder(
                      future: getData(),
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
                            return Container(
                                width: double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                child: LineChart(LineChartData(
                                  minY: 0,
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        tooltipBgColor:
                                            Colors.blueGrey.withOpacity(0.8),
                                      ),
                                      touchCallback: (LineTouchResponse
                                          touchResponse) {},
                                      handleBuiltInTouches: true,
                                    ),
                                    gridData: FlGridData(
                                      show: false,
                                    ),
                                    titlesData: FlTitlesData(
                                      bottomTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        getTextStyles: (value) =>
                                            const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      leftTitles: SideTitles(
                                        showTitles: true,
                                        getTextStyles: (value) =>
                                            const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                      // border: const Border(
                                      //   bottom: BorderSide(
                                      //     color: Color(0xff4e4965),
                                      //     width: 4,
                                      //   ),
                                      //   left: BorderSide(
                                      //     color: Colors.transparent,
                                      //   ),
                                      //   right: BorderSide(
                                      //     color: Colors.transparent,
                                      //   ),
                                      //   top: BorderSide(
                                      //     color: Colors.transparent,
                                      //   ),
                                      // ),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: spotData,
                                        isCurved: true,
                                        colors: [Color(0xff4af699)],
                                        isStrokeCapRound: true,
                                        belowBarData:
                                            BarAreaData(show: true, colors: [
                                          Color(0xff4af699).withOpacity(0.2)
                                        ]),
                                      ),
                                    ])));
                        }
                      }),
                    ],
                  ),
                ))));
  }
}
