class Activities {
  final int id;
  final String activity;
  final String date;
  Activities({this.id, this.activity, this.date});

  Map<String, dynamic> toMap() {
    return{
      "id" : id,
      "Activity" : activity,
      "Date" : date
    };
  }
}