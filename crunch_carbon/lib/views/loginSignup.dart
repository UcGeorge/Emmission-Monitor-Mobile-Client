import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uche/views/SignIn.dart';
import 'package:uche/views/SignUp.dart';
import 'package:uche/widgets/wigets.dart';

class LoginSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: "splash",
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 96,
                        child: SvgPicture.asset(
                          'images/Group 3571.svg',
                          height: 96,
                          semanticsLabel: 'Group 3571',
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        width: 257.23,
                        height: 116.56,
                        child: SvgPicture.asset(
                          'images/Path 4694.svg',
                          height: 116.56,
                          semanticsLabel: 'Path 4694',
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'images/Crunch Bg Image.png',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Container(
            // height: 120.0,
            margin: EdgeInsets.symmetric(vertical: 38),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                myTextButton(
                  context,
                  textColor: Colors.white,
                  buttonColor: Colors.black,
                  buttonName: 'Login',
                  onPressed: () {
                    print("Clicked Login");
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: SignIn(),
                      ),
                    );
                  },
                ),
                myTextButton(
                  context,
                  textColor: Colors.black,
                  buttonColor: Colors.white,
                  buttonName: 'Register',
                  onPressed: () {
                    print("Clicked Register");
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: SignUp(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
