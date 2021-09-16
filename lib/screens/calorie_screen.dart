import 'package:calendar/model/calorie.dart';
import 'package:calendar/model/nutrition.dart';
import 'package:calendar/route_animation.dart';
import 'package:calendar/screens/nutrition_screen.dart';
import 'package:calendar/services/calorie_network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CalorieScreen extends StatefulWidget {

  @override
  _CalorieScreenState createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  CalorieNetworkService networkService = CalorieNetworkService();
  List data;
  TextEditingController inputController;
  String theInput;
  bool _isVisible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10
                ),
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: TextFormField(
                  textInputAction: TextInputAction.search,
                  controller: inputController,
                  focusNode: FocusNode(),
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                      contentPadding:
                      EdgeInsets.all(20),
                      hintText: "Search food"),
                  onFieldSubmitted: (inputController) {
                    print("The input was : $inputController");
                    //Navigator.pop(context, this._textController.text);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(onPressed: () {
                Navigator.of(context).push(
                    new ScaleRoute(page: new NutritionSearch()));
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget searchResults(){
    inputController.text.isNotEmpty ?
     new FutureBuilder(
      future: networkService.fetchCalorie(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Calorie>> snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Card(
                    color: Colors.grey.withOpacity(0.5),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder:
                            (BuildContext context, int index) {
                          var currentFood = snapshot.data[index];
                          return ListTile(
                            title: Text(currentFood.food),
                            subtitle: Text(
                                "Calorie: ${currentFood.calorieCount} + Protein: ${currentFood.proteinCount}"),
                          );
                        }),
                  ),
                ),
              ),
            ],
          );
        }

        if (snapshot.hasError) {
          return Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 80.0,
              ));
        }

        return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20.0,
                ),
                Text("Loading at the moment, please hold on.")
              ],
            ));
      },
    ) : new Container(
      child: Text("Empty"),
    );
  }

  getJSONData() async {
    var url = Uri.parse(
        'https://api.edamam.com/api/food-database/v2/parser?app_id=be1d6ea7&app_key=f8457dfdb39307a7cfcde91f581fd816&ingr=chicken%20rice&nutrition-type=logging');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      data = jsonResponse["parsed"];

      print('jsonResponse: $data');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
