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

  getData() async {
    activity = await _dbHelper.retrieveActivity();
  }

  @override
  Widget build(BuildContext context) {
    getData();

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
                    width: 350,
                    height: 250,
                    child: SfCartesianChart(series: <ChartSeries<Activities, num>>[
                          SplineSeries<Activities, num>(
                              xAxisName: "Test",
                              cardinalSplineTension: 20,
                              color: Colors.green,
                              animationDuration: 2,
                              dataSource: activity,
                              xValueMapper: (Activities sales, _) => sales.id,
                              yValueMapper: (Activities sales, _) => sales.setCount,
                              name: 'Workout Chart')
                        ])
                )
            )
        )
    );
  }
}
