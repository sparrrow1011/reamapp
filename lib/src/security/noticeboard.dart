import 'package:flutter/material.dart';
import 'package:reamapp/src/residence/noticeboardsingle.dart';
import 'data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';

import 'mainpage.dart';
import 'navigation.dart';



class Notificationhold extends StatefulWidget {
  const Notificationhold({Key? key}) : super(key: key);

  @override
  _NotificationholdState createState() => _NotificationholdState();
}

class _NotificationholdState extends State<Notificationhold> {
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
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        height: 200.h,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: const BoxDecoration(
                            image:  DecorationImage(
                                image: AssetImage("assets/images/bck.png"),
                                fit: BoxFit.cover),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                    child: arrow(),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                    child: notification(),
                                  ),
                                ],
                              ),
                              Container(
                                child:  Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Notice Board",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.sp,
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
                                    ],
                                  ),
                                ),
                              ),
                              // Icon(Icons.home),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150.h,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              children:  <Widget>[
                                // PUT CONTENT FUNCTION HERE
                                notificationlist(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),


              // navigation Menu
              Container(child: Navigation(selectedIndex: selectedIndex, onClicked: onClicked,),)
            ],
          )
      ),
    );
  }
}

// arrow
class arrow extends StatelessWidget {
  const arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            mini: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30,),
          )
      );
  }
}

// notification
class notification extends StatelessWidget {
  const notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notificationhold()));
            },
            mini: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(Icons.notification_important_rounded, color: Colors.white, size: 30,),
          )
      );
  }
}



// content function


class notificationlist extends StatefulWidget {
  const notificationlist({Key? key}) : super(key: key);

  @override
  _notificationlistState createState() => _notificationlistState();
}

class _notificationlistState extends State<notificationlist> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: ScreenUtil().screenHeight - 283.h,
              child: DataTable2(
                columnSpacing: 4.w,
                horizontalMargin: 10.w,
                minWidth: MediaQuery.of(context).size.width,
                columns: [
                  DataColumn2(
                    label: Text('Date', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Subject', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Read', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.S,
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                        Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                    DataCell(Text ('The issue of water in the estate as been a major concern for the past two weeks',
                        maxLines: 1,style: TextStyle(fontSize: 11.sp))),
                    DataCell(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 8.r,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => NotificationSinglehold("row.id")));
                            },
                            child: Icon(Icons.remove_red_eye_sharp,
                              color: Colors.green,
                              size: 14.0.sp,
                              semanticLabel: 'Read',
                            ),
                          ),
                          SizedBox(width: 8.r,),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


