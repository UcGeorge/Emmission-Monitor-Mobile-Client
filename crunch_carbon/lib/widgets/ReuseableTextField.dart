import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReuseableTextField extends StatefulWidget {
  final String fieldName;
  final String? errorMessage;
  final Function(String)? onTextChanged;
  const ReuseableTextField(
      {required this.fieldName, this.errorMessage, this.onTextChanged});

  @override
  State<ReuseableTextField> createState() => _ReuseableTextFieldState();
}

class _ReuseableTextFieldState extends State<ReuseableTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.5, horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fieldName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          SizedBox(
            height: widget.errorMessage == null ? 45 : 45 + 20,
            child: TextField(
              keyboardType: widget.fieldName.toLowerCase() == 'email'
                  ? TextInputType.emailAddress
                  : null,
              obscureText: widget.fieldName.toLowerCase() == 'password',
              cursorColor: Colors.black,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) => widget.onTextChanged!(value) ?? () {},
              decoration: InputDecoration(
                focusColor: Colors.black,
                errorText: widget.errorMessage,
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(29),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(29),
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
