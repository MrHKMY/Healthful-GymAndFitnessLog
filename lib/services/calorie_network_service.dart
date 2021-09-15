import 'dart:convert';

import 'package:calendar/model/calorie.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;

//const String oriUrl = "https://api.edamam.com/api/food-database/v2/parser?app_id=be1d6ea7&app_key=f8457dfdb39307a7cfcde91f581fd816&ingr=Chicken%20soup&nutrition-type=cooking";

class CalorieNetworkService {

  //var url = Uri.parse(oriUrl);
  Future <List<Calorie>> fetchCalorie({@required String query}) async {

    final url = "https://api.edamam.com/api/food-database/v2/parser?app_id=be1d6ea7&app_key=f8457dfdb39307a7cfcde91f581fd816&ingr=$query&nutrition-type=cooking";

     http.Response response = await http.get(Uri.parse(url));
     if (response.statusCode == 200){
       print("Success");
       Map theData = jsonDecode(response.body);
       List<dynamic> data = theData["hints"];
       //print(data.map((json) => Calorie.fromJson(json)).toList());
       return data.map((json) => Calorie.fromJson(json)).toList();


     } else {
       throw Exception("Something gone wrong, ${response.statusCode}");
     }
  }

}