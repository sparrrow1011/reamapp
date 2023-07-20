import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'navigation.dart';



class NotificationSinglehold extends StatefulWidget {
  const NotificationSinglehold({Key? key}) : super(key: key);

  @override
  _NotificationSingleholdState createState() => _NotificationSingleholdState();
}

class _NotificationSingleholdState extends State<NotificationSinglehold> {
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
                                      Text(
                                        "The issues of water",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                        ),
                                      ),
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
                                notificationsingle(),
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
                  MaterialPageRoute(builder: (context) => NotificationSinglehold()));
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


class notificationsingle extends StatefulWidget {
  const notificationsingle({Key? key}) : super(key: key);

  @override
  _notificationsingleState createState() => _notificationsingleState();
}

class _notificationsingleState extends State<notificationsingle> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: ScreenUtil().screenHeight - 283.h,

              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.h),
                child: Text('It’s quite a list and the topic might be somewhat complex, but if you do have any questions, just reach out to me.Please do not touch the “rules” of the connections, as that will in some cases break the connection if you’re not very familiar with what you are doing. Something you could try and set up in this training environment that will show a lot of common functionalities of Exalate:'),
              )
            )
          ],
        ),
      ),
    );
  }
}


