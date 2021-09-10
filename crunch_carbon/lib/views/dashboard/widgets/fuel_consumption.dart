import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/src/provider.dart';
import 'package:crunch_carbon/providers/DashboardProvider.dart';
import 'package:crunch_carbon/widgets/wigets.dart';

class FuelConsumptionSection extends StatelessWidget {
  final double percent;
  final bool isUp;
  final bool loading;
  const FuelConsumptionSection({
    Key? key, required this.percent, required this.isUp, required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: SizedBox(
        height: 83,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carbon Emission',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                RichText(
                  text: TextSpan(
                    text: context.watch<DashboardProvider>().totalC?.toStringAsFixed(2) ?? '-.-',
                    style: TextStyle(
                        fontSize: 29,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: const <TextSpan>[
                      TextSpan(
                        text: ' km ',
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  'This week',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            myTextButton(
              context,
              onPressed: () {},
              width: loading ? 34 : 85,
              height: 34,
              buttonColor: isUp ? Colors.red : Colors.green,
              borderColor: Colors.transparent,
              child: loading
                  ? const SpinKitFadingCircle(
                color: Colors.white,
                size: 15.0,
              )
                  : Row(
                children: [
                  Spacer(),
                  isUp
                      ? Icon(
                    Icons.arrow_drop_up_sharp,
                    color: Colors.white,
                    size: 24,
                  )
                      : Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
                    size: 24,
                  ),
                  Spacer(),
                  RichText(
                    text: TextSpan(
                      text: context
                          .watch<DashboardProvider>()
                          .percentC
                          ?.toString() ??
                          percent.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: '%',
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
