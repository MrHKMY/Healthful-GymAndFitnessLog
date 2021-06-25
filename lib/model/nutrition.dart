class Water {
  final int id;
  final double litre;
  //final String date;

  Water({this.id, this.litre});

  Map<String, dynamic> toMap() {
    return{
      "id" : id,
      "Litre" : litre,
      //"Date" : date
    };
  }
}

class Calorie {
  final int id;
  final String food;
  final double calorie;
  //final String date;

  Calorie({this.id, this.food, this.calorie});

  Map<String, dynamic> toMap() {
    return{
      "id": id,
      "Food": food,
      "Calorie": calorie,
      //"Date": date
    };
  }
}

class Supplement {
  final int id;
  final String supplement;
  final String type;
  //final String date;

  Supplement({this.id, this.supplement, this.type});


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "Supplement": supplement,
      "PostPre": type,
      //"Date": date
    };
  }
}