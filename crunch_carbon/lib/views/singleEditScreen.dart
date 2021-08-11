import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/src/provider.dart';
import 'package:uche/providers/APIProvider.dart';
import 'package:uche/providers/UserProvider.dart';
import 'package:uche/widgets/wigets.dart';

class EditDetails extends StatefulWidget {
  final String originalValue;
  final String label;
  final Future<UpdateStatus> Function(String newValue) updateAction;

  const EditDetails({
    Key? key,
    required this.originalValue,
    required this.label,
    required this.updateAction,
  }) : super(key: key);

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  String? errorText;
  String? newValue;
  bool loading = false;

  update() async {
    setState(() {
      loading = true;
    });
    UpdateStatus updateStatus = await widget.updateAction(newValue!);
    if (updateStatus == UpdateStatus.Faliure) {
      setState(() {
        errorText = 'There was an error while updating your profile.';
        loading = false;
      });
    } else {
      switch (widget.label) {
        case 'Nickname':
          context.read<UserProvider>().editAttr(nickname: newValue);
          break;
        case 'Email':
          context.read<UserProvider>().editAttr(email: newValue);
          break;
        default:
      }
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            splashColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Container(
        child: Column(
          children: [
            LoginSignupTopArt(
              top: -175,
              right: -140,
              height: 125,
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.5),
              child: Center(
                child: SizedBox(
                  height: 210,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.label,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.5),
                          ),
                          SizedBox(
                            height: 11.0,
                          ),
                          SizedBox(
                            height: errorText == null ? 45 : 45 + 20,
                            child: TextField(
                              keyboardType: TextInputType.name,
                              autofocus: true,
                              obscureText: false,
                              cursorColor: Colors.white,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) {
                                newValue = value;
                              },
                              onSubmitted: (value) {
                                newValue = value;
                                update();
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: widget.originalValue,
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                                focusColor: Colors.white,
                                errorText: errorText,
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              errorText = null;
                            });
                            if (newValue == null) {
                              setState(() {
                                errorText = 'This is a required field';
                              });
                            } else {
                              update();
                            }
                          },
                          child: loading
                              ? const SpinKitFadingCircle(
                                  color: Colors.black,
                                  size: 15.0,
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Color(0xff353A54),
                                    letterSpacing: 1.5,
                                    fontSize: 16,
                                  ),
                                ),
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(0.1)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.white, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
