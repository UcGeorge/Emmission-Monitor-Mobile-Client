import 'package:flutter/material.dart';

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
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          SizedBox(
            height: 45,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(29),
                  borderSide: BorderSide(color: Colors.black, width: 10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
