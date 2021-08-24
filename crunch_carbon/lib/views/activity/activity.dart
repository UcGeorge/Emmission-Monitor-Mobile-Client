import 'package:crunch_carbon/views/activity/widgets/widgets.dart';
import 'package:crunch_carbon/widgets/wigets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crunch_carbon/providers/DashboardProvider.dart';
import 'package:crunch_carbon/views/dashboard/dashboard.dart';
import 'package:crunch_carbon/widgets/app_drawer.dart';

class ActivityPage extends StatefulWidget {
  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String selectedMode = 'daily';

  Future<bool> onWillPop(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: Dashboard(),
      ),
    );
    return Future.value(true);
  }

  void initData() async {
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
    initData();
  }

  Widget Graph() {
    switch (selectedMode) {
      case 'daily':
        return DailyGraph();
      case 'weekly':
        return WeeklyGraph();
      case 'monthly':
        return MonthlyGraph();
      default:
        return Container();
    }
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
              flex: 272,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Activity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        myTextButton(
                          context,
                          buttonColor: Colors.white,
                          onPressed: () {},
                          width: 77,
                          height: 34,
                          child: Row(
                            children: [
                              Spacer(),
                              Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Colors.black,
                                size: 24,
                              ),
                              Spacer(),
                              RichText(
                                text: TextSpan(
                                  text: context
                                          .watch<DashboardProvider>()
                                          .percentC
                                          ?.toString() ??
                                      '0',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: '%',
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.2),
                    Text(
                      'Carbon Footprint',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 29.5),
                    Container(
                      width: double.infinity,
                      height: 43,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (selectedMode != 'daily') {
                                setState(() {
                                  selectedMode = 'daily';
                                });
                              }
                            },
                            child: Container(
                              height: double.infinity,
                              width: 88,
                              decoration: BoxDecoration(
                                color: selectedMode == 'daily'
                                    ? Colors.black
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  'Daily',
                                  style: TextStyle(
                                    color: selectedMode == 'daily'
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (selectedMode != 'weekly') {
                                setState(() {
                                  selectedMode = 'weekly';
                                });
                              }
                            },
                            child: Container(
                              height: double.infinity,
                              width: 88,
                              decoration: BoxDecoration(
                                color: selectedMode == 'weekly'
                                    ? Colors.black
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  'Weekly',
                                  style: TextStyle(
                                    color: selectedMode == 'weekly'
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (selectedMode != 'monthly') {
                                setState(() {
                                  selectedMode = 'monthly';
                                });
                              }
                            },
                            child: Container(
                              height: double.infinity,
                              width: 88,
                              decoration: BoxDecoration(
                                color: selectedMode == 'monthly'
                                    ? Colors.black
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  'Monthly',
                                  style: TextStyle(
                                    color: selectedMode == 'monthly'
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 540,
              child: Hero(
                tag: 'bottomWhite',
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.only(),
                    child: Graph(),
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
