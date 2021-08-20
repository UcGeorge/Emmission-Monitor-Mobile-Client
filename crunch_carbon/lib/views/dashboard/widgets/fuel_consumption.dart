import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:crunch_carbon/providers/DashboardProvider.dart';
import 'package:crunch_carbon/widgets/wigets.dart';

class FuelConsumptionSection extends StatelessWidget {
  const FuelConsumptionSection({
    Key? key,
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
                  'Fuel Consumption',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                RichText(
                  text: TextSpan(
                    text:
                        context.watch<DashboardProvider>().totalC?.toString() ??
                            '0',
                    style: TextStyle(
                        fontSize: 29,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: const <TextSpan>[
                      TextSpan(
                        text: '.k km ',
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
              width: 77,
              height: 34,
              child: Row(
                children: [
                  Spacer(),
                  Icon(
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
                          '0',
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
