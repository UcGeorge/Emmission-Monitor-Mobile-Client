import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uche/providers/PersistentStorage.dart';
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
  }

  void checkLogin() async {
    await Future.delayed(Duration(seconds: 2), () {});
    // await clearPreferences();
    bool hasToken = await context.read<StoredData>().checkLogin();

    if (hasToken) {
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
                Image(
                  image: AssetImage(
                    'images/Logo.png',
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Image(
                  image: AssetImage(
                    'images/logo text.png',
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
