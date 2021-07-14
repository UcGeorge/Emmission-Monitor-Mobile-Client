import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uche/widgets/wigets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

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
            ),
          ],
        ),
      ),
    );
  }
}
