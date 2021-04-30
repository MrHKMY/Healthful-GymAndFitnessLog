import 'package:after_layout/after_layout.dart';
import 'package:calendar/model/progress.dart';
import 'package:calendar/screens/profile_screen.dart';
import 'package:calendar/screens/calendar.dart';
import 'package:calendar/screens/history.dart';
import 'package:calendar/screens/progress.dart';
import 'package:calendar/screens/startup_screen.dart';
import 'package:calendar/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

void main() {
  runApp(MyApp());
}

BuildContext testContext;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CalendarTest",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Splash(),
      initialRoute: "/",
      routes: {
        '/first': (context) => HistoryScreen(),
        '/second': (context) => ProgressScreen()
      },
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash> {

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new ProvidedStylesExample()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new StartUpScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
    throw UnimplementedError();
  }
}


// ----------------------------------------- Provided Style ----------------------------------------- //
class ProvidedStylesExample extends StatefulWidget {
  final BuildContext menuScreenContext;

  ProvidedStylesExample({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _ProvidedStylesExampleState createState() => _ProvidedStylesExampleState();
}

class _ProvidedStylesExampleState extends State<ProvidedStylesExample> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      CalendarScreen(
        menuScreenContext: widget.menuScreenContext,
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
      CountDownTimer(),
      ProgressScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.calendar_today),
          title: "Home",
          activeColorPrimary: Colors.blue[700],
          inactiveColorPrimary: Colors.white,
          activeColorSecondary: Colors.white),

      PersistentBottomNavBarItem(
        icon: Icon(Icons.timer),
        title: ("Timer"),
        activeColorPrimary: Colors.green[700],
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => HistoryScreen(),
            '/second': (context) => ProgressScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.gauge),
        title: ("Progress"),
        activeColorPrimary: Colors.deepOrange[700],
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => HistoryScreen(),
            '/second': (context) => ProgressScreen(),
          },
        ),
      ),

      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: Colors.red[700],
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => HistoryScreen(),
            '/second': (context) => ProgressScreen(),
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color(0xFF1F3546),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.all(0.0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        // onWillPop: (context) async {
        //   await showDialog(
        //     context: context,
        //     useSafeArea: true,
        //     builder: (context) => Container(
        //       height: 50.0,
        //       width: 50.0,
        //       color: Colors.white,
        //       child: ElevatedButton(
        //         child: Text("Close"),
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //       ),
        //     ),
        //   );
        //   return false;
        // },
        selectedTabScreenContext: (context) {
          testContext = context;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
            //colorBehindNavBar: Colors.indigo,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                topLeft: Radius.circular(25.0))),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style7, // Choose the nav bar style with this property
      ),
    );
  }
}
