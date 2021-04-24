import 'package:flutter/cupertino.dart';

import 'package:calendar/database_helper.dart';
import 'package:flutter/material.dart';

import 'package:calendar/widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff465466),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Column(children: [
              Expanded(
                  child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.retrieveActivity(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return HistoryWidget(
                              activity: snapshot.data[index].activity,
                              date: snapshot.data[index].date,
                            );
                          },
                        );
                      }))
            ])
          ],
        ),
      ),
    );
  }
}
