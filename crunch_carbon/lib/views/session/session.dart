import 'package:crunch_carbon/providers/SessionProvider.dart';
import 'package:crunch_carbon/views/session/counter.dart';
import 'package:crunch_carbon/widgets/wigets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SessionPage extends StatefulWidget {
  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  String? fuelOption;
  String? vehicleType;
  String? plateNo;
  String? plateNoError;
  bool loading = false;

  SnackBar snackBar = const SnackBar(
    backgroundColor: Colors.red,
    duration: Duration(seconds: 10),
    content: Text(
      'This app requires access to your location to calculate your carbon footprint. Start trip again to grant permissions.',
      textAlign: TextAlign.center,
      overflow: TextOverflow.visible,
      maxLines: 5,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  bool _checkValid() {
    if (plateNo?.isEmpty ?? true) {
      setState(() {
        plateNoError = "This is a required field";
      });
      return false;
    } else {
      setState(() {
        plateNoError = null;
      });
      return true;
    }
  }

  void _startTrip() async {
    setState(() {
      loading = true;
    });
    if (_checkValid()) {
      context
          .read<SessionProvider>()
          .initialize(fuelOption!, vehicleType!, plateNo!);
      if (await context.read<SessionProvider>().locationService.allIsWell()) {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Counter(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 161,
            child: Center(
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 651,
            child: Hero(
              tag: 'bottomWhite',
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Card(
                  elevation: 0,
                  // color: Colors.blue,
                  margin: EdgeInsets.only(),
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 19.0,
                          ),
                          _buildForm(),
                          SizedBox(
                            height: 34.0,
                          ),
                          TextButton(
                            onPressed: _startTrip,
                            child: Center(
                              child: loading
                                  ? const SpinKitFadingCircle(
                                      color: Colors.white,
                                      size: 15.0,
                                    )
                                  : Text(
                                      'Start Trip',
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
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(29.0),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(500.0, 45.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        ReuseableSelectField(
          fieldName: 'Fuel Option',
          options: ['Petrol', 'Diesel'],
          onSelectChanged: (value) {
            fuelOption = value;
          },
        ),
        ReuseableSelectField(
          fieldName: 'Vehicle Type',
          options: ['Truck', 'Suv', 'Salon'],
          onSelectChanged: (value) {
            vehicleType = value;
          },
        ),
        SizedBox(
          height: 5.5,
        ),
        ReuseableTextField(
          fieldName: 'User Plate No',
          onTextChanged: (value) {
            plateNo = value;
          },
          errorMessage: plateNoError,
        ),
      ],
    );
  }
}
