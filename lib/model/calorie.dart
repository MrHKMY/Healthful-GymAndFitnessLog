class Calorie {
  String food;
  double proteinCount;
  double calorieCount;

  Calorie({this.food, this.calorieCount, this.proteinCount});

  Calorie.fromJson(Map<String, dynamic> json)
      : food = json["food"]["label"],
        calorieCount = json["food"]["nutrients"]["ENERC_KCAL"],
        proteinCount = json["food"]["nutrients"]["PROCNT"]
  ;
}