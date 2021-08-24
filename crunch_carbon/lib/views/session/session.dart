import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionPage extends StatefulWidget {
  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 161,
            child: Container(),
          ),
          Expanded(
            flex: 651,
            child: Hero(
              tag: 'bottomWhite',
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                // child: Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(),
                //   child: Graph(),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
