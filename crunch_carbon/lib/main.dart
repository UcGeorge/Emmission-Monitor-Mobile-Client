import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SignUp.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'sign_in':(context) => SignIn(),
        'sign_up': (context) => SignUp(),
      },
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
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
                        SizedBox(height: 50.0,),
                        Image(
                          image: AssetImage(
                            'images/logo text.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(image: DecorationImage(
                    image: AssetImage(
                      'images/Crunch Bg Image.png',
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                  ),
                ),
              ),
              Container(
                height: 120.0,
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
        ),
      ),
    );
  }
}

class myTextButton extends StatelessWidget {
  myTextButton({required this.textColor, required this.buttonColor, required this.buttonName, required this.pageName});
  final Color textColor;
  final Color buttonColor;
  final String buttonName;
  final String pageName;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(
            context,pageName);
        },
        child: Text(
          buttonName, //the button text name
          style: TextStyle(
            color: textColor,//the login or sign up  button color property
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            buttonColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.0),
            ),
          ),
          fixedSize: MaterialStateProperty.all<Size>(
            Size(150.0, 55.0),
          ),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(color: Colors.black, width: 2.0),
          ),
      ),
    );
  }
}