import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uche/views/splashScreen.dart';
import 'SignIn.dart';
import 'SignUp.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'sign_in': (context) => SignIn(),
        'sign_up': (context) => SignUp(),
      },
      home: SplashScreen(),
    );
  }
}
