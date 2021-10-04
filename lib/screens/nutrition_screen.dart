import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar/database_helper.dart';
import 'package:calendar/model/nutrition.dart';
import 'package:calendar/services/calorie_network_service.dart';
import 'package:calendar/widgets.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class NutritionSearch extends StatefulWidget {
  @override
  _NutritionSearchState createState() => _NutritionSearchState();
}

class _NutritionSearchState extends State<NutritionSearch>
    with TickerProviderStateMixin {
  DatabaseHelper _dbHelper = DatabaseHelper();
  Animation<double> _animation;
  AnimationController _animationController;
  TabController _controller;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _controller = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Calorie Screen"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          color: Colors.white,
          //height: 500,
          height: double.infinity,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? 0.0
                : kBottomNavigationBarHeight,
          ),
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.teal, width: 8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[700],
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    height: 120,
                    child: SfRadialGauge(
                        enableLoadingAnimation: true,
                        animationDuration: 2500,
                        title: GaugeTitle(
                            text: "Calorie",
                            textStyle: TextStyle(fontSize: 18)),
                        axes: <RadialAxis>[
                          RadialAxis(
                              startAngle: 270,
                              endAngle: 270,
                              minimum: 0,
                              maximum: 100,
                              showLabels: false,
                              showTicks: false,
                              radiusFactor: 1,
                              canScaleToFit: true,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.15,
                                cornerStyle: CornerStyle.startCurve,
                                color: Colors.grey[300],
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                    enableAnimation: true,
                                    animationDuration: 2500,
                                    animationType: AnimationType.easeOutBack,
                                    //TODO get today calorie
                                    //TODO get preference calorie target
                                    value: 80,
                                    width: 0.15,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    cornerStyle: CornerStyle.endCurve,
                                    gradient: SweepGradient(colors: <Color>[
                                      Colors.yellow[200],
                                      Colors.yellow[600],
                                    ], stops: <double>[
                                      0.25,
                                      0.75
                                    ])),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    positionFactor: 0.1,
                                    angle: 90,
                                    widget: Text.rich(TextSpan(
                                        text: "75",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                        children: [
                                          TextSpan(
                                            text: "/250",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        ])))
                              ])
                        ]),
                  ),
                  VerticalDivider(
                    color: Colors.teal,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FutureBuilder(
                          future: _dbHelper.retrieveProtein(),
                          builder: (context, snapshot) {
                            return Text.rich(TextSpan(
                                text: "Protein : ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                children: [
                                  TextSpan(
                                    text: snapshot.data.toString() != "null"
                                        ? snapshot.data.toString()
                                        : "0",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ]));
                          },
                        ),
                        FutureBuilder(
                          future: _dbHelper.retrieveCarb(),
                          builder: (context, snapshot) {
                            return RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: "Carb : ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data.toString() != "null"
                                            ? snapshot.data.toString()
                                            : "0",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ]));
                          },
                        ),
                        FutureBuilder(
                          future: _dbHelper.retrieveFat(),
                          builder: (context, snapshot) {
                            return RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: "Fat : ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data.toString() != "null"
                                            ? snapshot.data.toString()
                                            : "0",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ]));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: new TabBar(
                indicatorColor: Colors.yellow,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                unselectedLabelColor: Colors.black,
                controller: _controller,
                tabs: [
                  new Tab(
                    text: "Breakfast",
                  ),
                  new Tab(
                    text: "Lunch",
                  ),
                  new Tab(
                    text: "Dinner",
                  ),
                  new Tab(
                    text: "Other",
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  child: TabBarView(
                controller: _controller,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.retrieveNutrition("Breakfast"),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              //TODO return empty state if list is empty
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
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.retrieveNutrition("Lunch"),
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
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.retrieveNutrition("Dinner"),
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
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.retrieveNutrition("Other"),
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
              )),
            ),
          ]),
        ),
      ),
      floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? 0.0
                  : kBottomNavigationBarHeight),
          child: FloatingActionBubble(
            iconColor: Colors.white,
            iconData: Icons.add,
            backGroundColor: Colors.teal,
            animation: _animation,
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),
            items: <Bubble>[
              Bubble(
                title: "Breakfast",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                //icon:Icons.settings,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  showSearch(
                      context: context,
                      delegate:
                          FoodSearch(mealTime: new MealTime("Breakfast")));
                  _animationController.reverse();
                },
              ),
              Bubble(
                title: "Lunch",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                //icon:Icons.people,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  showSearch(
                      context: context,
                      delegate: FoodSearch(mealTime: new MealTime("Lunch")));
                  _animationController.reverse();
                },
              ),
              Bubble(
                title: "Dinner",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                //icon:Icons.home,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  showSearch(
                      context: context,
                      delegate: FoodSearch(mealTime: new MealTime("Dinner")));
                  _animationController.reverse();
                },
              ),
              Bubble(
                title: "Other",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                //icon:Icons.home,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  showSearch(
                      context: context,
                      delegate: FoodSearch(mealTime: new MealTime("Other")));
                  _animationController.reverse();
                },
              ),
            ],
          )),
    );
  }
}

class FoodSearch extends SearchDelegate<String> {
  final MealTime mealTime;

  FoodSearch({this.mealTime});

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
      'Enter keyword for suggestions',
      style: TextStyle(fontSize: 18, color: Colors.grey),
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
                    Image.asset("assets/images/wave.gif"),
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

              print("The selected button: ${mealTime.name}");
              // 2. Close Search & Return Result
              Calorie _newCalorie = Calorie(
                  food: suggestion.food,
                  foodTime: mealTime.name,
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
