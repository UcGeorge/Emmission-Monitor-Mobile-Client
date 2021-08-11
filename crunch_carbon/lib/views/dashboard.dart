import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uche/providers/DashboardProvider.dart';
import 'package:uche/providers/UserProvider.dart';
import 'package:uche/views/profile.dart';
import 'package:uche/widgets/MyTextButton.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                              onTap: () {},
                            ),
                            SizedBox(
                              width: 42,
                            ),
                            HomepageActivity(
                              imageAsset: 'images/My activities Icon.svg',
                              label: 'Activity',
                              onTap: () {},
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

class HomepageDrawer extends StatelessWidget {
  const HomepageDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.688,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                right: BorderSide(
                  color: Colors.white,
                  width: .5,
                ),
              )),
          child: Column(
            children: [
              MenuUser(),
              MenuRoutes(),
              Spacer(),
              LogoutMenuItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutMenuItem extends StatelessWidget {
  const LogoutMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40, left: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 19,
          backgroundImage: AssetImage('images/Log out Icon.png'),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            overflow: TextOverflow.fade,
            fontSize: 16,
            letterSpacing: 1.8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class MenuRoutes extends StatelessWidget {
  const MenuRoutes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 19,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'images/home-run (1).svg',
                height: 20,
                color: Colors.black,
                semanticsLabel: 'home-run (1)',
              ),
            ),
            title: Text(
              'Home',
              style: TextStyle(
                overflow: TextOverflow.fade,
                fontSize: 16,
                letterSpacing: 1.8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: .5,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: ProfileView(),
                ),
              );
            },
            leading: CircleAvatar(
              radius: 19,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 25,
              ),
            ),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                overflow: TextOverflow.fade,
                fontSize: 16,
                letterSpacing: 1.8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: .5,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 19,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'images/steering-wheel.svg',
                height: 22,
                color: Colors.black,
                semanticsLabel: 'steering-wheel',
              ),
            ),
            title: Text(
              'Start a Trip',
              style: TextStyle(
                overflow: TextOverflow.fade,
                fontSize: 16,
                letterSpacing: 1.8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: .5,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 19,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'images/My activities Icon.svg',
                height: 22,
                color: Colors.black,
                semanticsLabel: 'My activities Icon',
              ),
            ),
            title: Text(
              'My Activities',
              style: TextStyle(
                overflow: TextOverflow.fade,
                fontSize: 16,
                letterSpacing: 1.8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuUser extends StatelessWidget {
  const MenuUser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2616133005,
      padding: EdgeInsets.symmetric(vertical: 78.95),
      margin: EdgeInsets.only(top: 32.5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: Colors.white,
          // backgroundImage: AssetImage('images/edit Profile icon.png'),
          child: Icon(
            Icons.person,
            color: Colors.black,
            size: 37,
          ),
        ),
        title: Text(
          context.watch<UserProvider>().nickname?.toUpperCase() ??
              'myname@gmail.com',
          style: TextStyle(
            overflow: TextOverflow.fade,
            fontSize: 19,
            letterSpacing: 1.8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class HomepageActivity extends StatelessWidget {
  final String imageAsset;
  final String label;
  final Function onTap;

  const HomepageActivity({
    Key? key,
    required this.imageAsset,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        color: Colors.black,
        child: Container(
          height: 136,
          width: 136,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  imageAsset,
                  height: 24,
                  color: Colors.black,
                  semanticsLabel: 'steering-wheel',
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StylishDivider extends StatelessWidget {
  const StylishDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 8.5),
      child: SvgPicture.asset(
        'images/Path 9.svg',
        height: 22,
        color: Colors.black,
        semanticsLabel: 'Path 9',
      ),
    );
  }
}

class FuelConsumptionSection extends StatelessWidget {
  const FuelConsumptionSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: SizedBox(
        height: 83,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fuel Consumption',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                RichText(
                  text: TextSpan(
                    text:
                        context.watch<DashboardProvider>().totalC?.toString() ??
                            '0',
                    style: TextStyle(
                        fontSize: 29,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: const <TextSpan>[
                      TextSpan(
                        text: '.k km ',
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
              ],
            ),
            myTextButton(
              context,
              onPressed: () {},
              width: 77,
              height: 34,
              child: Row(
                children: [
                  Spacer(),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
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
                        color: Colors.white,
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
            child: Container(
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
                      text: context
                              .watch<DashboardProvider>()
                              .totalC
                              ?.toString() ??
                          '0',
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
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: SvgPicture.asset(
                'images/Path 2.svg',
                height: 22,
                color: Colors.black,
                semanticsLabel: 'Path 2',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
