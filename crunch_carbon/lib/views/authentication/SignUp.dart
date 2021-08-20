import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crunch_carbon/providers/APIProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:crunch_carbon/providers/PersistentStorage.dart';
import 'package:crunch_carbon/providers/UserProvider.dart';
import 'package:crunch_carbon/views/dashboard/dashboard.dart';
import 'package:crunch_carbon/widgets/wigets.dart';
import 'SignIn.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name;
  String? username;
  String? password;
  String? nameError;
  String? usernameError;
  String? passwordError;
  bool loading = false;
  SignupStatus loginStatus = SignupStatus.LoggedOut;
  Function signupAction = () {};

  void signup(BuildContext context) async {
    setState(() {
      usernameError = null;
      passwordError = null;
      loginStatus = SignupStatus.LoggedOut;
      loading = true;
    });
    var loginStatus_temp = await context.read<API>().signup(
          name ?? 'undefined',
          username ?? 'undefined',
          password ?? 'undefined',
        );
    setState(() {
      loading = false;
      loginStatus = loginStatus_temp;
    });
    if (loginStatus == SignupStatus.Success) {
      var token = context.read<API>().token;
      context
          .read<StoredData>()
          .storeLodin(username!, password!, name!, token!);
      final prefs = await SharedPreferences.getInstance();
      context.read<UserProvider>().setAttr(
            email: prefs.getString('username')!,
            password: prefs.getString('password')!,
            nickname: prefs.getString('nickname')!,
          );
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: Dashboard(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    signupAction = () {
      setState(() {
        usernameError = null;
        passwordError = null;
        nameError = null;
      });
      if (name?.isEmpty ?? true) {
        setState(() {
          nameError = "This is a required field";
        });
      } else if (password?.isEmpty ?? true) {
        setState(() {
          passwordError = "This is a required field";
        });
      } else if (username?.isEmpty ?? true) {
        setState(() {
          usernameError = "This is a required field";
        });
      } else {
        signup(context);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          LoginSignupTopArt(),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 31,
                        ),
                      ),
                      SizedBox(
                        height: 29.0,
                      ),
                      ReuseableTextField(
                        fieldName: 'Nickname',
                        onTextChanged: (value) {
                          name = value;
                        },
                        errorMessage: nameError ??
                            (loginStatus == SignupStatus.Faliure
                                ? "There was an error signing you in."
                                : null),
                      ),
                      ReuseableTextField(
                        fieldName: 'Email',
                        onTextChanged: (value) {
                          username = value;
                        },
                        errorMessage: usernameError,
                      ),
                      ReuseableTextField(
                        fieldName: 'Password',
                        onTextChanged: (value) {
                          password = value;
                        },
                        errorMessage: passwordError,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextButton(
                        onPressed: () => signupAction(),
                        child: Center(
                          child: loading
                              ? const SpinKitFadingCircle(
                                  color: Colors.white,
                                  size: 15.0,
                                )
                              : Text(
                                  'Signup',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.black,
                          ),
                          overlayColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade900,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(29.0),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(500.0, 45.0),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 0.0),
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
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: SignIn(),
                                  ),
                                );
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
            ),
          ),
        ],
      ),
    );
  }
}
