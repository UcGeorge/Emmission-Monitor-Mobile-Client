import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:crunch_carbon/providers/DashboardProvider.dart';
import 'package:crunch_carbon/providers/APIProvider.dart';
import 'package:crunch_carbon/providers/PersistentStorage.dart';
import 'package:crunch_carbon/providers/SessionProvider.dart';
import 'package:crunch_carbon/providers/UserProvider.dart';
import 'package:crunch_carbon/views/authentication/SignIn.dart';
import 'package:crunch_carbon/views/authentication/SignUp.dart';
import 'package:crunch_carbon/views/splashScreen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StoredData()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (context) => API()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.black),
  );
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
