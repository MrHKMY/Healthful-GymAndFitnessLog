class Activities {
  final int id;
  final String activity;
  final String time;
  Activities({this.id, this.activity, this.time});

  Map<String, dynamic> toMap() {
    return{
      "id" : id,
      "Activity" : activity,
      "Date" : time
    };
  }
}