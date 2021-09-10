import 'package:crunch_carbon/views/activity/activity.dart';
import 'package:crunch_carbon/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:crunch_carbon/providers/DashboardProvider.dart';
import 'package:crunch_carbon/widgets/wigets.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      height: 178,
      // width: 338,
      margin: EdgeInsets.symmetric(horizontal: 18.5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  myTextButton(
                    context,
                    textColor: Colors.white,
                    buttonColor: Colors.black,
                    buttonName: 'Activity Dashboard',
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: ActivityPage(),
                        ),
                      );
                    },
                    width: 135,
                    height: 38,
                  ),
                  Spacer(),
                  RichText(
                    text: TextSpan(
                      text: context.watch<DashboardProvider>().totalDistance?.toStringAsFixed(2) ?? '-.-',
                      style: TextStyle(
                          fontSize: 29,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      children: const <TextSpan>[
                        TextSpan(
                          text: ' km ',
                        ),
                        TextSpan(
                          text: 'Covered',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
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
                  Spacer(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: SvgPicture.asset(
                'images/Path 2.svg',
                height: 22,
                color: Colors.black,
                semanticsLabel: 'Path 2',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
