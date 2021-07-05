import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'SignIn.dart';

class SignUp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: ListView(
            children: [
              Stack(
                children: [
                  Positioned(
                    top: -140,
                    right: -140,
                    child: Container(
                      width: 450,
                      height: 340,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'images/Top Right Decoration.png'),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0, top: 220.0 , right: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 33,
                          ),
                        ),
                        SizedBox(height: 27.0,),
                        ReuseableTextField(
                          fieldName: 'Email',
                        ),
                        ReuseableTextField(
                          fieldName: 'Password',
                        ),
                        SizedBox(height: 25.0,),
                        TextButton(
                          onPressed: () {
                            print('login button was clicked');
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white,),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ),
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade900,
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29.0),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                              Size(500.0, 62.0),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Have an account already ?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SignIn()));
                                },
                                child: Text(
                                  'Sign In',
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
                clipBehavior: Clip.hardEdge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableTextField extends StatelessWidget {
  ReuseableTextField({required this.fieldName});

  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 15.0,),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(29),
                borderSide: BorderSide(color: Colors.black, width: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
