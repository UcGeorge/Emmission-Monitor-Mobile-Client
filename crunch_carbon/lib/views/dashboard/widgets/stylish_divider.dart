import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StylishDivider extends StatelessWidget {
  const StylishDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 8.5),
      child: SvgPicture.asset(
        'images/Path 9.svg',
        height: 22,
        color: Colors.black,
        semanticsLabel: 'Path 9',
      ),
    );
  }
}
