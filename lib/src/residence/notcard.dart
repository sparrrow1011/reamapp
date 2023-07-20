import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data.dart';
import 'noticeboard.dart';

class notcard extends StatefulWidget {
  const notcard({Key? key}) : super(key: key);

  @override
  _notcardState createState() => _notcardState();
}

class _notcardState extends State<notcard> {
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
                children: const[
                   Text(
                    '1 \nNotification',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.notification_important_rounded,
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
                  children: [
                    Text('Estate Due', style: TextStyle(color: mainColor),),
                  ],
                ),
              ),
            ),
          )
      )
    ]);
  }
}
