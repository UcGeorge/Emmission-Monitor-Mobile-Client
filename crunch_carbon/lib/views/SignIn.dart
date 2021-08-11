import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uche/providers/APIProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uche/providers/PersistentStorage.dart';
import 'package:uche/providers/UserProvider.dart';
import 'package:uche/views/dashboard.dart';
import 'package:uche/widgets/wigets.dart';
import 'SignUp.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? username;
  String? password;
  String? usernameError;
  String? passwordError;
  bool loading = false;
  LoginStatus loginStatus = LoginStatus.LoggedOut;
  Function loginAction = () {};

  void login(BuildContext context) async {
    setState(() {
      usernameError = null;
      passwordError = null;
      loginStatus = LoginStatus.LoggedOut;
      loading = true;
    });
    var loginStatus_temp = await context.read<API>().login(
          username ?? 'undefined',
          password ?? 'undefined',
        );
    setState(() {
      loading = false;
      loginStatus = loginStatus_temp;
    });
    if (loginStatus == LoginStatus.Success) {
      var token = context.read<API>().token;
      context
          .read<StoredData>()
          .storeLodin(username!, password!, context.read<API>().name!, token!);
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
    loginAction = () {
      setState(() {
        usernameError = null;
        passwordError = null;
      });
      if (username?.isEmpty ?? true) {
        setState(() {
          usernameError = "This is a required field";
        });
      } else if (password?.isEmpty ?? true) {
        setState(() {
          passwordError = "This is a required field";
        });
      } else {
        login(context);
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
                        'Sign in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 31,
                        ),
                      ),
                      SizedBox(
                        height: 29.0,
                      ),
                      ReuseableTextField(
                        fieldName: 'Email',
                        onTextChanged: (value) {
                          username = value;
                        },
                        errorMessage: usernameError ??
                            (loginStatus == LoginStatus.Faliure
                                ? "There was an error signing you in."
                                : null),
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
                        onPressed: () => loginAction(),
                        child: Center(
                          child: loading
                              ? const SpinKitFadingCircle(
                                  color: Colors.white,
                                  size: 15.0,
                                )
                              : Text(
                                  'Login',
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
                              'Don\'t have an account ?',
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
                                    child: SignUp(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
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
