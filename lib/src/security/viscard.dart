import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'data.dart';

class viscard extends StatefulWidget {
  const viscard({Key? key}) : super(key: key);

  @override
  _viscardState createState() => _viscardState();
}

class _viscardState extends State<viscard> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: Container(
          width: 131.w,
          height: 120.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: mainColor),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    '6 \nVisitors',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.supervised_user_circle_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
          top: 9.h,
          left: 9.2.w,
          child: Container(
            width: 111.w,
            height: 46.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Segun', style: TextStyle(color: mainColor),),
                    Text('Ope', style: TextStyle(color: mainColor),),
                    Text('Emeka', style: TextStyle(color: mainColor),),
                    Text('Matt', style: TextStyle(color: mainColor),)
                  ],
                ),
              ),
            ),
          )
      )
    ]);
  }
}
