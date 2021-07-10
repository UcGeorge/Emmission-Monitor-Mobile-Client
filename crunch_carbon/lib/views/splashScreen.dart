import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uche/views/loginSignup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: LoginSignup(),
          ),
        );
      },
    );
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
