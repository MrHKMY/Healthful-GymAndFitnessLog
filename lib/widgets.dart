import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryWidget extends StatelessWidget {
  final String activity;
  final String date;

  HistoryWidget({this.activity, this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
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
                style:
                TextStyle(fontSize: 12, color: Colors.grey[500], height:1.5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
