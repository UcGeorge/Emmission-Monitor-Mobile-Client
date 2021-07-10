import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uche/providers/LoginSignupProvider.dart';
import 'package:uche/providers/PersistentStorage.dart';
import 'package:uche/providers/SessionProvider.dart';
import 'package:uche/views/SignIn.dart';
import 'package:uche/views/SignUp.dart';
import 'package:uche/views/splashScreen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StoredData()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (context) => LoginSignup()),
      ],
      child: MyApp(),
    ),
  );
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
