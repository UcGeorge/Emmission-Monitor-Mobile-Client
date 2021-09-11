import 'dart:ui';

import 'package:crunch_carbon/models/fuel.dart';
import 'package:crunch_carbon/models/location.dart';
import 'package:crunch_carbon/models/session.dart';
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
  double fuelConsumed = 0.0;

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
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      finalDistance = distance;
                      context.read<SessionProvider>().endTrip();
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
                        'Enter Your Fuel Usage (in litres)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        child: TextField(
                          cursorColor: Colors.white,
                          autofocus: true,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          onChanged: (value){
                            fuelConsumed = double.parse(value);
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            focusColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(29),
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(29),
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            final prefs = await SharedPreferences.getInstance();
                            var token = prefs.getString('token');
                            var username = prefs.getString('username');
                            widget.fuel.quantityConsumed = fuelConsumed;
                            var putStatus = await context.read<SessionProvider>().putSession(token ?? 'undefined', username ?? 'undefined', Session(widget.fuel, finalDistance/1000));
                            setState(() {
                              loading = false;
                            });
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
                                'Submit',
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
