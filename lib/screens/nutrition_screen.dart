import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar/database_helper.dart';
import 'package:calendar/model/nutrition.dart';
import 'package:calendar/services/calorie_network_service.dart';
import 'package:calendar/widgets.dart';
import 'package:flutter/material.dart';

class NutritionSearch extends StatelessWidget {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Calorie Screen"),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  final results =
                      showSearch(context: context, delegate: FoodSearch());
                })
          ],
        ),
        body: SafeArea(
          child: Stack(children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              color: Colors.teal[100],
              //height: 500,
              height: double.infinity,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? 0.0
                    : kBottomNavigationBarHeight,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.retrieveNutrition(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                var currentFood = snapshot.data[index];
                                if (currentFood.imageLink == null) {
                                  currentFood.imageLink = "null";
                                }
                                return NutritionCardList(
                                  foodName: currentFood.food,
                                  calorie: currentFood.calorieCount,
                                  protein: currentFood.proteinCount,
                                  carb: currentFood.carbCount,
                                  fat: currentFood.fatCount,
                                  imageLink: currentFood.imageLink,
                                );
                              });
                        }),
                  ),
                ],
              ),
            ),
            Positioned(
              right: width * 0.1,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? 0.0
                  : kBottomNavigationBarHeight + 20,
              child: FloatingActionButton(
                  backgroundColor: Colors.teal[300],
                  child: Image.asset(
                    "assets/images/cutlery.png",
                    scale: 15,
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: FoodSearch());
                  }),
            ),
          ]),
        ));
  }
}

class FoodSearch extends SearchDelegate<String> {
  String get searchFieldLabel => "Search meals";
  CalorieNetworkService networkService = CalorieNetworkService();
  DatabaseHelper _dbHelper = DatabaseHelper();
  int calorieID = 0;

  final food = [
    "Chicken",
    "Fish",
    "Meat",
    "Lamb",
    "Beef",
  ];

  final recentFood = [
    "Lamb",
    "Chicken",
    "Beef",
  ];

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = "";
                showSuggestions(context);
              }
            })
      ];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: networkService.fetchCalorie(query: query),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(
                  'Something went wrong!',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              );
            } else {
              print(snapshot.data);
              return Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Card(
                        color: Colors.grey.withOpacity(0.5),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
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
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final suggestions = query.isEmpty
    //     ? recentFood
    //     : food.where((foods) {
    //         final foodLower = foods.toLowerCase();
    //         final queryLower = query.toLowerCase();
    //         return foodLower.startsWith(queryLower);
    //       }).toList();
    //
    // return buildSuggestionsSuccess(suggestions);

    return FutureBuilder<List<Calorie>>(
        future: networkService.fetchCalorie(query: query),
        builder: (context, snapshot) {
          if (query.isEmpty) return buildNoSuggestions();

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError || snapshot.data.isEmpty) {
                return buildNoSuggestions();
              } else {
                return buildSuggestionsSuccess(snapshot.data);
              }
          }
        });
  }

  Widget buildNoSuggestions() => Center(
        child: Text(
          'No suggestions!',
          style: TextStyle(fontSize: 28, color: Colors.black),
        ),
      );

  Widget buildSuggestionsSuccess(List<Calorie> suggestions) {
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          // final queryText = suggestion.food.substring(0, query.length);
          // final remainingText = suggestion.food.substring(query.length);

          return ListTile(
            leading: ClipOval(
              child: CachedNetworkImage(
                placeholder: (context, url) =>
                    Image.asset ("assets/images/wave.gif"),
                imageUrl: suggestion.imageLink,
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/launcher_icon.png"),
              ),
            ),
            title: Text(suggestion.food),
            isThreeLine: true,
            subtitle: Text(
                "Calorie: ${suggestion.calorieCount}\t\t  Carb: ${suggestion.carbCount}\n"
                    "Protein: ${suggestion.proteinCount}\t\t Fat: ${suggestion.fatCount} "),
            onTap: () async {
              //query = suggestion.food;

              // 1. Show Results
              //showResults(context);

              // 2. Close Search & Return Result
              Calorie _newCalorie = Calorie(
                  food: suggestion.food,
                  imageLink: suggestion.imageLink,
                  calorieCount:
                      double.parse(suggestion.calorieCount.toStringAsFixed(2)),
                  proteinCount:
                      double.parse(suggestion.proteinCount.toStringAsFixed(2)),
                  carbCount:
                      double.parse(suggestion.carbCount.toStringAsFixed(2)),
                  fatCount:
                      double.parse(suggestion.fatCount.toStringAsFixed(2)));
              //date: a.substring(0, 10));
              calorieID = await _dbHelper.insertNutrition(_newCalorie);
              close(context, suggestion.food);

              // 3. Navigate to Result Page
              //  Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => CalorieScreen(suggestion),
              //   ),
              // );
            },
          );
        });
  }

  Widget buildResultSuccess(Calorie calorie) {
    return ListTile(
      title: Text(calorie.food),
      subtitle: Text(
          "Calorie: ${calorie.calorieCount} + Protein: ${calorie.proteinCount}"),
    );
  }
}
