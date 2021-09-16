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

class Calorie {
  int id;
  String food;
  double proteinCount;
  double calorieCount;
  double carbCount;
  double fatCount;

  Calorie(
      {this.id, this.food, this.calorieCount, this.proteinCount, this.carbCount, this.fatCount});

  Calorie.fromJson(Map<String, dynamic> json)
      : food = json["food"]["label"],
        calorieCount = json["food"]["nutrients"]["ENERC_KCAL"],
        proteinCount = json["food"]["nutrients"]["PROCNT"],
        carbCount = json["food"]["nutrients"]["CHOCDF"],
        fatCount = json["food"]["nutrients"]["FAT"]
  ;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "FoodName": food,
      "Calorie": calorieCount,
      "Protein": proteinCount,
      "Carb": carbCount,
      "Fat": fatCount,
      //"Date": date
    };
  }
}