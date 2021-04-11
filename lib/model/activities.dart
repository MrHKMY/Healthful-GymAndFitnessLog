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

class Progress {
  final int id;
  final String bodyPart;
  final double center;
  final double left;
  final double right;
  final String date;

  Progress ({this.id, this.bodyPart, this.center, this.left, this.right, this.date});

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "BodyPart" : bodyPart,
      "Center" : center,
      "Left" : left,
      "Right" : right,
      "Date" : date,
    };
  }
}