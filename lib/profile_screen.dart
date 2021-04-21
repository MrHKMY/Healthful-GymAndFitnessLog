import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff465466),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0.0, -0.8),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  maxRadius: 65,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        ExactAssetImage("assets/images/profile_image.png"),
                    maxRadius: 60,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0, -0.45),
              child: Text(
                "John Doe",
                style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF30A9B2),
                    fontFamily: "Times"),
              ),
            ),
            Align(
              alignment: Alignment(0.0, -0.2),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff465466),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF30A9B2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "71.5 Kg",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Weight",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: Color(0xFF30A9B2),
                        indent: 10,
                        endIndent: 10,
                        thickness: 0.5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "1.80 m",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Height",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //todo(4) list age, gender, bmi, goals, settings
            Align(
              alignment: Alignment(0.0, 0.65),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.4,
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Color(0xff465466),
                  //   borderRadius: BorderRadius.circular(20),
                  //   border: Border.all(color: Color(0xFF30A9B2)),
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.deepPurple[800],
                            backgroundImage: ExactAssetImage("assets/images/age_icon.png"),
                          ),
                          SizedBox(width: 15,),
                          Text(
                            "Age",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "25",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green[800],
                              backgroundImage: AssetImage("assets/images/gender_icon.png"),

                          ),
                          SizedBox(width: 15,),
                          Text(
                            "Gender",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "Gender Icon",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.orange[800],
                            backgroundImage: AssetImage("assets/images/bmi_icon.png"),
                          ),
                          SizedBox(width: 15,),
                          Text(
                            "Body Mass Index (BMI)",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "21.2",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.red[800],
                            backgroundImage: AssetImage("assets/images/goals_icon.png"),
                          ),
                          SizedBox(width: 15,),
                          Text(
                            "Fitness Goals",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "Gain Muscle",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: [
                          SizedBox(width: 15,),
                          Text(
                            "Settings",
                            style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                                color: Colors.grey[300]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
