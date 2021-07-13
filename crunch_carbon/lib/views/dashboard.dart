import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uche/providers/DashboardProvider.dart';
import 'package:uche/widgets/MyTextButton.dart';

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
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.688,
        child: Drawer(
          child: Container(
            child: Center(
              child: Text('MENU'),
            ),
          ),
        ),
      ),
      body: WillPopScope(
        child: Column(
          children: [
            Expanded(
              flex: 327,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  height: 178,
                  // width: 338,
                  margin: EdgeInsets.symmetric(horizontal: 18.5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ActivityCard(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage(
                                  'images/Vertical Line On Activity Card.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 435,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
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

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          myTextButton(
            context,
            textColor: Colors.white,
            buttonColor: Colors.black,
            buttonName: 'Activity Dashboard',
            onPressed: () {},
            width: 135,
            height: 38,
          ),
          Spacer(),
          RichText(
            text: TextSpan(
              text:
                  context.watch<DashboardProvider>().totalC?.toString() ?? '0',
              style: TextStyle(
                  fontSize: 29,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: const <TextSpan>[
                TextSpan(
                  text: '.k km ',
                ),
                TextSpan(
                  text: 'Covered',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            'This week',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
