import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/notice.dart';
import '../model/response.dart';
import '../residence/loading.dart';
import '../service/NoticeService.dart';
import '../service/locatorService.dart';
import '../service/navigationService.dart';
import '../util/helper.dart';

import 'navigation.dart';



class NotificationSinglehold extends StatefulWidget {
  String? noticeId;
   NotificationSinglehold(this.noticeId,{Key? key}) : super(key: key);

  @override
  _NotificationSingleholdState createState() => _NotificationSingleholdState();
}

class _NotificationSingleholdState extends State<NotificationSinglehold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  Notice? notice;
  bool loading = false;
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNotice();

  }
  getNotice() async {
    setState(() {
      loading = true;
    });

    NoticeService service = NoticeService();
    Map<String, dynamic> formInfo = {
      'can_login': true,
    };
    Response rs = await service.noticeBoard([widget.noticeId]);
    setState(() {
      loading = false
      ;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      notice = Notice.fromJson(data['record']);
    }else{
      displaySnackbar(_scaffoldKey, "Record not found", Colors.redAccent);
      locator<NavigationService>().pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      body: (loading)?Loading():Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              // page main content container
              Container(
                  height: ScreenUtil().screenHeight,
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
                                        (notice?.title is String)? notice!.title! : '',
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
                                notificationsingle(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),


              // navigation Menu
              // Container(child: Navigation(),)
            ],
          )
      ),
    );
  }
  Widget arrow() {
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

  Widget notificationsingle(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10.w, top: 30.h),
                  child: Text('Created: \n'+ ((notice?.date_created is String)? notice!.date_created! : '')),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.w, top: 30.h),
                  child: Text('Expires: \n'+ ((notice?.date_expiry is String)? notice!.date_expiry! : '')),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Container(
                height: ScreenUtil().screenHeight - 283.h,

                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.h),
                  child: Text((notice?.message is String)? notice!.message! : ''),
                )
            )
          ],
        ),
      ),
    );
  }
}





