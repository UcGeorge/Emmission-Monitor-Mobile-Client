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

class ReuseableSelectField extends StatefulWidget {
  final String fieldName;
  final String? errorMessage;
  final Function(String) onSelectChanged;
  final List<String> options;
  final int defaultIndex;

  ReuseableSelectField({
    required this.fieldName,
    this.errorMessage,
    required this.onSelectChanged,
    required this.options,
    this.defaultIndex = 0,
  }) {
    onSelectChanged(options[defaultIndex]);
  }

  @override
  State<ReuseableSelectField> createState() => _ReuseableSelectFieldState();
}

class _ReuseableSelectFieldState extends State<ReuseableSelectField> {
  bool _displayDefault = true;
  String? selected = null;

  void _showOptions() {
    setState(() {
      _displayDefault = !_displayDefault;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 17, horizontal: 0.0),
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_displayDefault ? 29 : 7),
              border: Border.all(color: Colors.black, width: .5),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: _displayDefault
                  ? GestureDetector(
                      onTap: _showOptions,
                      child: Container(
                        height: 45,
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selected ?? widget.options[widget.defaultIndex],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            IconButton(
                              // padding: EdgeInsets.only(),
                              onPressed: _showOptions,
                              icon: Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Colors.black,
                                size: 24,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.options
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected = e;
                                    });
                                    widget.onSelectChanged(e);
                                    _showOptions();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20.5),
                                        Text(
                                          e,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        SizedBox(height: 20.5),
                                        widget.options.last != e
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color: Colors.black,
                                                        width: .3),
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
