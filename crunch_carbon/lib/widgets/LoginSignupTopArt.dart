import 'package:flutter/material.dart';

class LoginSignupTopArt extends StatelessWidget {
  final double? top;
  final double? right;
  final double? height;
  const LoginSignupTopArt({
    Key? key,
    this.top,
    this.right,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: MediaQuery.of(context).size.width,
      height: height ?? 254,
      child: Stack(
        children: [
          Positioned(
            top: top ?? -70,
            right: right ?? -140,
            child: Container(
              width: 450,
              height: 340,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Top Right Decoration.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
