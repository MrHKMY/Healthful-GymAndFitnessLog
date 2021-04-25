class UserInfo {
  final int id;
  final String name;
  final int gender;
  final int age;
  final double height;
  final String goals;

  UserInfo({this.id, this.name, this.gender, this.age, this.height, this.goals});

  Map<String, dynamic> toMap() {
    return{
      "id" : id,
      "Name" : name,
      "Gender" : gender,
      "Age" : age,
      "Height" : height,
      "Goals" : goals
    };
  }

}