import 'package:calendar/database_helper.dart';
import 'package:calendar/model/activities.dart';
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

    List allCharts = [weightChart(), chestChart(), bicepsChart(), foreArmChart(), waistChart()];

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
        backgroundColor: Colors.black,
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
              items: allCharts.map((card){
                return Builder(
                    builder:(BuildContext context){
                      return Container(
                        height: double.infinity,
                        child: Card(
                          color: Colors.black,
                          child: card,
                        ),
                      );
                    }
                );
              }).toList(),
            ),
        )
    );
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

  Widget weightChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 100,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: weightOne(),
            bottomCardWidget: weightTwo()
        )
      ],
    );
  }

  Widget weightOne() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xFF1F3546), borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
      child: Column(
        children: [
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
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                                showTitles: true,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
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
                                spots: spotData,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
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
      ),
    );
  }

  Widget weightTwo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Latest : ",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "Highest : ",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "Lowest : ",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget bicepsChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 100,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: bicepsOne(),
            bottomCardWidget: weightTwo()
        )
      ],
    );
  }

  Widget bicepsOne() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xFF1F3546), borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
      child: Column(
        children: [
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
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                                showTitles: true,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
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
                                spots: spotData,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
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
      ),
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
            bottomCardHeight: 100,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: chestsOne(),
            bottomCardWidget: weightTwo()
        )
      ],
    );
  }

  Widget chestsOne() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xFF1F3546), borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
      child: Column(
        children: [
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
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                                showTitles: true,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
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
                                spots: spotData,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
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
      ),
    );
  }

  Widget foreArmChart() {
    return ListView(
      shrinkWrap: false,
      padding: EdgeInsets.all(10),
      children: [
        SlimyCard(
            color: Color(0xFF1F3546),
            width: 400,
            topCardHeight: 400,
            bottomCardHeight: 100,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: foreArmOne(),
            bottomCardWidget: weightTwo()
        )
      ],
    );
  }

  Widget foreArmOne() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xFF1F3546), borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
      child: Column(
        children: [
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
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                                showTitles: true,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
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
                                spots: spotData,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
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
      ),
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
            bottomCardHeight: 100,
            borderRadius: 20,
            slimeEnabled: false,
            topCardWidget: waistOne(),
            bottomCardWidget: weightTwo()
        )
      ],
    );
  }

  Widget waistOne() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xFF1F3546), borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
      child: Column(
        children: [
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
                      return Container(child: Text(snapshot.error.toString()));
                    return Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                                showTitles: true,
                                reservedSize: 22,
                                getTextStyles: (value) => const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              leftTitles: SideTitles(
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
                                spots: spotData,
                                isCurved: true,
                                colors: [Color(0xff4af699)],
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: true, colors: [
                                  Color(0xff4af699).withOpacity(0.2)
                                ]),
                              ),
                            ])));
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
      ),
    );
  }

}
