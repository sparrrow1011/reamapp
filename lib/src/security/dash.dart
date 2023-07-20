import 'package:flutter/material.dart';
import 'data.dart';
import 'info.dart';
import 'navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                 height: ScreenUtil().screenHeight -76.h,
                child: Info(),
              ),
              // navigation
              Container(child: Navigation(selectedIndex: selectedIndex, onClicked: onClicked,),)
            ],
          )
          ),
    );
  }
}
