import 'package:flutter/material.dart';

class myTextButton extends StatelessWidget {
  final Color textColor;
  final Color buttonColor;
  final String buttonName;
  final Function onPressed;
  final double? width;
  final double? height;

  myTextButton(
    BuildContext context, {
    required this.textColor,
    required this.buttonColor,
    required this.buttonName,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45,
      width: width ?? 169,
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          buttonName,
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
            BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
      ),
    );
  }
}
