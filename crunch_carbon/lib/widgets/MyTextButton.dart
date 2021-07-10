import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';s

class myTextButton extends StatelessWidget {
  myTextButton(
      {required this.textColor,
      required this.buttonColor,
      required this.buttonName,
      required this.pageName});
  final Color textColor;
  final Color buttonColor;
  final String buttonName;
  final String pageName;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 169,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, pageName);
        },
        child: Text(
          buttonName, //the button text name
          style: TextStyle(
            color: textColor,
            fontSize: 13,
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
      ),
    );
  }
}
