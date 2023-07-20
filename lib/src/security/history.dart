import 'package:flutter/material.dart';
import 'historytab.dart';
import 'navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'noticeboard.dart';

class historyhold extends StatefulWidget {
  const historyhold({Key? key}) : super(key: key);

  @override
  _historyholdState createState() => _historyholdState();
}

class _historyholdState extends State<historyhold> {
  int selectedIndex = 0;

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // page main content container
          Container(
            height: ScreenUtil().screenHeight - 76.h,
            child: history(),
          ),

          // navigation Menu
          Container(
            child: Navigation(selectedIndex: selectedIndex, onClicked: onClicked,),
          )
        ],
      )),
    );
  }
}

// page content
class history extends StatefulWidget {
  const history({Key? key}) : super(key: key);

  @override
  _historyState createState() => _historyState();
}

class _historyState extends State<history> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          height: 200.h,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bck.png"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 54.h,),
                Container(
                  child: Center(
                    child: Text(
                      "History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 110.h,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  historyTab(),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// arrow
class arrow extends StatelessWidget {
  const arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
      },
      mini: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 30,
      ),
    ));
  }
}

// notification
class notification extends StatelessWidget {
  const notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Notificationhold()));
      },
      mini: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Icon(
        Icons.notification_important_rounded,
        color: Colors.white,
        size: 30,
      ),
    ));
  }
}
