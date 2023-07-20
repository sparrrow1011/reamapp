import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'data.dart';

class statuscard extends StatefulWidget {
  const statuscard({Key? key}) : super(key: key);

  @override
  _statuscardState createState() => _statuscardState();
}

class _statuscardState extends State<statuscard> {
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
                children: [
                  Text(
                    'Indebt',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.account_balance_wallet,
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
                    Text('Ikeja assoc', style: TextStyle(color: Colors.red),),
                    Text('Power bill', style: TextStyle(color: Colors.red),),
                    Text('Water assoc', style: TextStyle(color: Colors.red),),
                    Text('Power bill', style: TextStyle(color: Colors.red),),
                  ],
                ),
              ),
            ),
          )
      )
    ]);
  }
}
