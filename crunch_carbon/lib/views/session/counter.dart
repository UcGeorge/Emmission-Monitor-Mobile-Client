import 'package:crunch_carbon/providers/SessionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/src/provider.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  bool loading = false;
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

    if (!isInTransit) {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(distance.toString()),
            Text(
                'Last location: (${lastLocation?.latitude ?? 'None'}, ${lastLocation?.longitude ?? 'None'})'),
            Text(
                'Current location: (${currentLocation?.latitude ?? 'None'}, ${currentLocation?.longitude ?? 'None'})'),
            Text(
                'Calculated Distance: ${context.watch<SessionProvider>().calculatedDistance}'),
            Text(
                'Calculated ${context.watch<SessionProvider>().countKeeper} times.'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
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
    );
  }
}
