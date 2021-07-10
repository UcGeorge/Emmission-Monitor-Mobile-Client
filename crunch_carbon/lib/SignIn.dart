import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uche/widgets/wigets.dart';
import 'SignUp.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Container(
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
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 31,
                        ),
                      ),
                      SizedBox(
                        height: 29.0,
                      ),
                      ReuseableTextField(
                        fieldName: 'Email',
                      ),
                      ReuseableTextField(
                        fieldName: 'Password',
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextButton(
                        onPressed: () {
                          print('login button was clicked');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.black,
                          ),
                          overlayColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade900,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(29.0),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(500.0, 45.0),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Don\'t have an account ?',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: SignUp()));
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
