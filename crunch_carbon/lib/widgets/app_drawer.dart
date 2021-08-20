import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:crunch_carbon/providers/UserProvider.dart';
import 'package:crunch_carbon/views/dashboard/dashboard.dart';
import 'package:crunch_carbon/views/profile/profile.dart';

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
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: Dashboard(),
                ),
              );
            },
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
