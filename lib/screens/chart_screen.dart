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
                child: Column(
                  children: [
                    Container(
                        width: 350,
                        height: 250,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color(0xFF1F3546),
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: SfCartesianChart(
                            series: <ChartSeries<Activities, num>>[
                              SplineSeries<Activities, num>(
                                  xAxisName: "Test",
                                  cardinalSplineTension: 20,
                                  color: Colors.green,
                                  animationDuration: 2,
                                  dataSource: activity,
                                  xValueMapper: (Activities sales, _) =>
                                      sales.id,
                                  yValueMapper: (Activities sales, _) =>
                                      sales.setCount,
                                  name: 'Workout Chart')
                            ])),
                    SizedBox(
                      height: 20,
                    ),
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
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Color(0xFF1F3546),
                                      borderRadius: BorderRadius.circular(20)),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 5),
                                  child: LineChart(
                                      LineChartData(
                                          lineBarsData: [
                                              LineChartBarData(
                                                spots: spotData,
                                                colors: [Colors.green],
                                    )
                                  ])));
                          }
                        }),
                  ],
                ))));
  }
}
