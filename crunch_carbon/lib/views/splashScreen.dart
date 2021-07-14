import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uche/providers/PersistentStorage.dart';
import 'package:uche/providers/UserProvider.dart';
import 'package:uche/views/dashboard.dart';
import 'package:uche/views/loginSignup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('password');
    prefs.remove('username');
    prefs.remove('nickname');
  }

  void checkLogin() async {
    await Future.delayed(Duration(seconds: 2), () {});
    // await clearPreferences();
    bool hasToken = await context.read<StoredData>().checkLogin();

    if (hasToken) {
      final prefs = await SharedPreferences.getInstance();
      context.read<UserProvider>().setAttr(
            email: prefs.getString('username')!,
            password: prefs.getString('password')!,
            nickname: prefs.getString('nickname')!,
          );
      print(
          "email: ${prefs.getString('username')},\npassword: ${prefs.getString('password')},\nnickname: ${prefs.getString('nickname')},");
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: Dashboard(),
        ),
      );
    } else {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: LoginSignup(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: "splash",
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 96,
                  child: SvgPicture.asset(
                    'images/Group 3571.svg',
                    height: 96,
                    semanticsLabel: 'Group 3571',
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: 257.23,
                  height: 116.56,
                  child: SvgPicture.asset(
                    'images/Path 4694.svg',
                    height: 116.56,
                    semanticsLabel: 'Path 4694',
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/Crunch Bg Image.png',
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
