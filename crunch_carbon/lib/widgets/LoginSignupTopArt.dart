import 'package:flutter/material.dart';

class LoginSignupTopArt extends StatelessWidget {
  const LoginSignupTopArt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 254,
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -140,
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
