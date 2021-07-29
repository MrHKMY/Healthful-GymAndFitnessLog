class Activities {
  final int id;
  final String activity;
  final String focus;
  final int setCount;
  final String date;

  Activities({this.id, this.activity, this.focus, this.setCount, this.date});

  Map<String, dynamic> toMap() {
    return{
      "id" : id,
      "Activity" : activity,
      "Focus" : focus,
      "SetCount" : setCount,
      "Date" : date
    };
  }
}