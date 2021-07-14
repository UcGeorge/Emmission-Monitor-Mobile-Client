import 'package:flutter/material.dart';

class LoginSignupTopArt extends StatelessWidget {
  final double? top;
  final double? right;
  const LoginSignupTopArt({
    Key? key,
    this.top,
    this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 254,
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
