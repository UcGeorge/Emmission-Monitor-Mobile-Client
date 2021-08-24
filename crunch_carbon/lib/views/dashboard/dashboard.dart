import 'package:crunch_carbon/views/activity/activity.dart';
import 'package:crunch_carbon/views/dashboard/widgets/widgets.dart';
import 'package:crunch_carbon/views/session/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crunch_carbon/providers/DashboardProvider.dart';
import 'package:crunch_carbon/widgets/app_drawer.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime? currentBackPressTime;

  SnackBar snackBar = const SnackBar(
    backgroundColor: Colors.black,
    duration: Duration(seconds: 2),
    content: Text(
      'Go back again to leave',
      textAlign: TextAlign.center,
    ),
  );

  Future<bool> onWillPop(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  void initDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var username = prefs.getString('username');
    context
        .read<DashboardProvider>()
        .getSessions(token ?? 'undefined', username ?? 'undefined');
  }

  @override
  void initState() {
    super.initState();
    initDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Image(
              image: AssetImage('images/Menu Icon.png'),
            ),
          ),
        ),
      ),
      drawer: HomepageDrawer(),
      body: WillPopScope(
        child: Column(
          children: [
            Expanded(
              flex: 327,
              child: Center(
                child: ActivityCard(),
              ),
            ),
            Expanded(
              flex: 435,
              child: Hero(
                tag: 'bottomWhite',
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: FuelConsumptionSection(),
                      ),
                      StylishDivider(),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 34.9, horizontal: 30.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HomepageActivity(
                              imageAsset: 'images/steering-wheel.svg',
                              label: 'Start a Trip',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: SessionPage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 42,
                            ),
                            HomepageActivity(
                              imageAsset: 'images/My activities Icon.svg',
                              label: 'Activity',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ActivityPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        onWillPop: () => onWillPop(context),
      ),
    );
  }
}
