import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:uche/providers/APIProvider.dart';
import 'package:uche/providers/UserProvider.dart';
import 'package:uche/views/singleEditScreen.dart';
import 'package:uche/widgets/wigets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = context.watch<UserProvider>();
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
            Expanded(
              flex: 350,
              child: Container(
                // color: Colors.blue,
                child: Column(
                  children: [
                    LoginSignupTopArt(
                      top: -175,
                      right: -140,
                      height: 125,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 29,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(12),
                            // width: 135,
                            // height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'images/My activities Icon.svg',
                                  height: 17.46,
                                  color: Colors.black,
                                  semanticsLabel: 'My activities Icon',
                                ),
                                SizedBox(width: 20.5),
                                Text(
                                  'My Activities',
                                  style: TextStyle(
                                    overflow: TextOverflow.fade,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 45.75,
                          backgroundColor: Colors.white,
                          // backgroundImage: AssetImage('images/edit Profile icon.png'),
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 55,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          currentUser.nickname?.toUpperCase() ?? 'myname',
                          style: TextStyle(
                            overflow: TextOverflow.fade,
                            fontSize: 19,
                            letterSpacing: 1.8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Hero(
                tag: 'bottomWhite',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 57),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 0,
                    child: Column(
                      children: [
                        EditDetailsItem(
                          label: 'Nickname',
                          value: currentUser.nickname ?? 'myname',
                          onWillEdit: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: EditDetails(
                                  label: 'Nickname',
                                  updateAction: (value) {
                                    return context.read<API>().update(
                                          value,
                                          context.read<UserProvider>().email!,
                                          context
                                              .read<UserProvider>()
                                              .password!,
                                        );
                                  },
                                  originalValue:
                                      currentUser.nickname ?? 'myname',
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 40),
                        EditDetailsItem(
                          label: 'Email',
                          value: currentUser.email ?? 'myname@email.com',
                          onWillEdit: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: EditDetails(
                                  label: 'Email',
                                  updateAction: (value) {
                                    return context.read<API>().update(
                                          context
                                              .read<UserProvider>()
                                              .nickname!,
                                          value,
                                          context
                                              .read<UserProvider>()
                                              .password!,
                                        );
                                  },
                                  originalValue:
                                      currentUser.email ?? 'myname@email.com',
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 40),
                        myTextButton(
                          context,
                          onPressed: () {},
                          buttonColor: Colors.white,
                          height: 45,
                          width: double.infinity,
                          buttonName: 'Change password',
                          textColor: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              flex: 462,
            )
          ],
        ),
      ),
    );
  }
}

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
