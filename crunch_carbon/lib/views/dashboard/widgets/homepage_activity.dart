import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomepageActivity extends StatelessWidget {
  final String imageAsset;
  final String label;
  final Function onTap;

  const HomepageActivity({
    Key? key,
    required this.imageAsset,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        color: Colors.black,
        child: Container(
          height: 136,
          width: 136,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  imageAsset,
                  height: 24,
                  color: Colors.black,
                  semanticsLabel: 'steering-wheel',
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
