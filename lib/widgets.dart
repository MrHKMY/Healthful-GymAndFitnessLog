import 'package:flutter/material.dart';

class HistoryWidget extends StatelessWidget {
  final String activity;
  final String date;

  HistoryWidget({this.activity, this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      //margin: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        margin: EdgeInsets.only(bottom: 2),
        child: Column(
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
                  color: Colors.black.withOpacity(0.5),
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
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF30A9B2)),
                ),
                child: Text(
                  "L",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                width: 50,
                margin: EdgeInsets.only(left: 5),
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
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF30A9B2)),
                ),
                child: Text(
                  "R",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                width: 50,
                margin: EdgeInsets.only(left: 5),
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
