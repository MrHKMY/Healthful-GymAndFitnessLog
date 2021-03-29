import 'package:calendar/widgets.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

void main() {
  runApp(MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;

  @override
  void initState() {
    _calendarController = CalendarController();
    super.initState();
    _events = {};
    _selectedEvents = [];
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TableCalendar(
              events: _events,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarController: _calendarController,
              headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  formatButtonTextStyle: TextStyle(color: Colors.white)),
              onDaySelected: (date, events, holidays) {
                setState(() {
                  _selectedEvents = events;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: _showAddDialog
          //ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text("Snackbar")));
          ),
    );
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("New Event"),
              content: TextField(controller: _eventController),
              actions: <Widget>[
                FlatButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventController.text.isEmpty){
                      return;
                    }
                    setState(() {
                      if (_events [_calendarController.selectedDay] != null) {
                        _events [_calendarController.selectedDay].add(_eventController.text);
                      } else {
                        _events [_calendarController.selectedDay] = [_eventController.text];
                      }
                      _eventController.clear();
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }
}
