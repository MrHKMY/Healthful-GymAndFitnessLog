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

  factory Progress.fromMap(Map<String, dynamic> json) =>new Progress(
    id : json["id"],
    bodyPart : json["BodyPart"],
    center : json["Center"],
    left : json["Left"],
    right : json["Right"],
    date : json["Date"],
  );
}