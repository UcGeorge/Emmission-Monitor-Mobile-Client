import 'package:flutter/material.dart';

class EditDetailsItem extends StatelessWidget {
  final String label;
  final String value;
  final Function onWillEdit;

  const EditDetailsItem({
    Key? key,
    required this.label,
    required this.value,
    required this.onWillEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.only(left: 22),
          height: 45,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => onWillEdit(),
                child: SizedBox(
                  height: 45,
                  width: 45,
                  child: Container(
                    // color: Colors.blue,
                    child: Icon(Icons.edit),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
