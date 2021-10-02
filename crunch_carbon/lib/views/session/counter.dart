import 'dart:ui';

import 'package:crunch_carbon/models/fuel.dart';
import 'package:crunch_carbon/models/location.dart';
import 'package:crunch_carbon/models/session.dart';
import 'package:crunch_carbon/models/vehicle.dart';
import 'package:crunch_carbon/providers/SessionProvider.dart';
import 'package:crunch_carbon/views/dashboard/dashboard.dart';
import 'package:crunch_carbon/views/dashboard/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter extends StatefulWidget {
  final Fuel fuel;
  const Counter({Key? key, required this.fuel}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  bool loading = false;
  double finalDistance = 0.0;
  late Session session;

  @override
  void initState() {
    super.initState();
    context.read<SessionProvider>().startTrip();
  }

  @override
  Widget build(BuildContext context) {
    double distance = context.watch<SessionProvider>().distanceTravelled;
    bool isInTransit = context.watch<SessionProvider>().isInTransit;
    UserLocation? lastLocation = context.watch<SessionProvider>().lastLocation;
    UserLocation? currentLocation =
        context.watch<SessionProvider>().currentLocation;
    bool hasBeenEnded = false;

    if (!isInTransit) {
      setState(() {
        loading = false;
        hasBeenEnded = true;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Distance Travelled',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                RichText(
                  text: TextSpan(
                    text: (distance/1000).toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 59.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: ' KM',
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StylishDivider(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      finalDistance = distance;
                      context.read<SessionProvider>().endTrip();

                      session = Session(
                        widget.fuel,
                        finalDistance/1000,
                        context.read<SessionProvider>().vehicle,
                      );

                      final prefs = await SharedPreferences.getInstance();
                      var token = prefs.getString('token');
                      var username = prefs.getString('username');
                      var putStatus = await context.read<SessionProvider>().putSession(
                        token ?? 'undefined',
                        username ?? 'undefined',
                        session,
                      );
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Center(
                      child: loading
                          ? const SpinKitFadingCircle(
                              color: Colors.white,
                              size: 15.0,
                            )
                          : Text(
                              'End Trip',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                        Colors.grey.shade900,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29.0),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(500.0, 45.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          hasBeenEnded
          ? BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 350,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Carbon emission',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        session.emissionQuantity.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: Dashboard(),
                              ),
                            );
                          },
                          child: loading
                              ? const SpinKitFadingCircle(
                            color: Colors.black,
                            size: 15.0,
                          )
                              : Text(
                                'Okay',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                          style: ButtonStyle(
                            overlayColor:
                            MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29.0),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                              Size(150.0, 55.0),
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.white, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          : SizedBox.shrink(),
        ],
      ),
    );
  }
}
