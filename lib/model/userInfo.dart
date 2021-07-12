class UserInfo {
  final int id;
  final String name;
  final String gender;
  final int age;
  final double height;
  final String goals;
  final int workCount;
  final int waterCount;
  final int suppCount;

  UserInfo({this.id, this.name, this.gender, this.age, this.height, this.goals, this.workCount, this.waterCount, this.suppCount});

  Map<String, dynamic> toMap() {
    return{
      "id" : id,
      "Name" : name,
      "Gender" : gender,
      "Age" : age,
      "Height" : height,
      "Goals" : goals,
      "WorkoutCount" : workCount,
      "WaterCount" : waterCount,
      "SupplementCount" : suppCount
    };
  }

}