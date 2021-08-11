import 'package:flutter/material.dart';

class myTextButton extends StatelessWidget {
  final Color? textColor;
  final Color? buttonColor;
  final String? buttonName;
  final Function onPressed;
  final double? width;
  final double? height;
  final Widget? child;

  myTextButton(
    BuildContext context, {
    this.textColor,
    this.buttonColor,
    this.buttonName,
    required this.onPressed,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45,
      width: width ?? 169,
      child: TextButton(
        onPressed: () => onPressed(),
        child: child ??
            Text(
              buttonName!,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            ),
        style: ButtonStyle(
          overlayColor:
              MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1)),
          backgroundColor: MaterialStateProperty.all<Color>(
            buttonColor ?? Colors.black,
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
