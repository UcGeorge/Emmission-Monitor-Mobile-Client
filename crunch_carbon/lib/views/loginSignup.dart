import 'package:flutter/material.dart';
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
                      Image(
                        image: AssetImage(
                          'images/Logo.png',
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Image(
                        image: AssetImage(
                          'images/logo text.png',
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
                  textColor: Colors.white,
                  buttonColor: Colors.black,
                  buttonName: 'Login',
                  pageName: 'sign_in',
                ),
                myTextButton(
                  textColor: Colors.black,
                  buttonColor: Colors.white,
                  buttonName: 'Register',
                  pageName: 'sign_up',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
