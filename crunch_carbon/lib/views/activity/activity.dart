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
              child: Container(),
            ),
            Expanded(
              flex: 540,
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
                  child: Container(),
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
