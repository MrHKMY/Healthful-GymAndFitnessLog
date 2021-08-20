import 'package:flutter/cupertino.dart';

import 'package:calendar/database_helper.dart';
import 'package:flutter/material.dart';

import 'package:calendar/widgets.dart';
import 'package:flutter/services.dart';

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
      appBar: AppBar(
        title: Text("Workout History"),
        elevation: 10,
        centerTitle: true,
        backgroundColor: Color(0xFF1F3546),
        brightness: Brightness.light,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
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
                              activity: snapshot.data[index].weight,
                              date: snapshot.data[index].date,
                              setCount: snapshot.data[index].setCount,
                              focus: snapshot.data[index].focus,
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
