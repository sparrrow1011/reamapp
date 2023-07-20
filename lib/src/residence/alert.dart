import 'package:flutter/material.dart';
import '../model/alert.dart';
import '../model/response.dart';
import '../model/user.dart';
import '../service/AlertService.dart';
import '../service/authdata.dart';
import '../util/helper.dart';
import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'navigation.dart';
import 'noticeboard.dart';



class alerthold extends StatefulWidget {
  const alerthold({Key? key}) : super(key: key);

  @override
  _alertholdState createState() => _alertholdState();
}

class _alertholdState extends State<alerthold>  with TickerProviderStateMixin{
  int selectedIndex = 0;
  bool loading = false;
  bool pending = true;
  int status  = 0;
  Alert? lastAlert;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User? user;
  final desc = TextEditingController();
  double initAnim = 180.0; //default 180.0
  double initOpasity = 1; //default 0.2


  getUser() async {
    User? getUser = await AuthData.getUser();
    setState(()  {
      user = getUser;
    });
    // print(getUser.attr!['address']);

  }

  late AnimationController   rippleController;
  late AnimationController  scaleController;

  late Animation<double>  rippleAnimation;
  late Animation<double>  scaleAnimation;


  @override
  void initState() {
    super.initState();

    initAnimation();
    getUser();
    getAlert();
  }
  initAnimation(){
    rippleController =
        AnimationController(vsync: this, duration:  const Duration(seconds: 1));

    scaleController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    rippleAnimation =
    Tween<double>(begin: initAnim, end: 210.0).animate(rippleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rippleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          rippleController.forward();
        }
      });
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 40.0).animate(scaleController);

    // rippleController.forward();
  }
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  setAlert() async {
    setState(() {
      loading = true;
    });

    AlertService service = AlertService();
    Response rs = await service.newAlert({
      'status': 1,
      'attr':{'description': desc.text}});
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      dynamic data = rs.data['store']['data'];

      setState(() {
        lastAlert = Alert.fromJson(data);
        status = 1;
        pending = true;
        initOpasity = 0.2;
        initAnim = 180.0;
        rippleController.forward();
      });
      displaySnackbar(_scaffoldKey, "Alert has been sent successfully. Awaiting response from security post!!!", Colors.greenAccent);

    }
  }
  Future<bool> getAlert() async {
    setState(() {
      loading = true;
    });

    AlertService service = AlertService();
    Response rs = await service.getLastAlert();
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      dynamic data = rs.data['store']['data'];
      if(data == "no alert present"){
        setState(() {
          status = 0;
          pending = false;
          rippleController.stop();
        });
      }else{
        lastAlert = Alert.fromJson(data);
        setState(() {
          status = lastAlert?.status??0;
          if(status > 3){
            status = 0;
            pending = false;

            rippleController.stop();
          }else{
            pending = true;
            initOpasity = 0.2;
            initAnim = 180.0;
            rippleController.forward();
            print('initanimation');
          }

        });
      }


    }
    return true;
  }
  @override
  void dispose() {
    // TODO: implement dispose

    rippleController.dispose();
    scaleController.dispose();
    super.dispose();

  }
  updateAlertStatus(Alert alert, int status) async {
    setState(() {
      loading = true;
    });

    AlertService service = AlertService();
    Response rs = await service.updateAlert({
      'status': status,
      'attr':alert.attr
    }, [alert.id]);
    print({
      'status': status,
      'attr':alert.attr
    });
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      // Map data = rs.data['store']['dashboard'];
      setState(() {
        pending = false;
        initOpasity = 1;
        initAnim = 210.0;
        this.status = 0;
        rippleController.stop();
      });
      displaySnackbar(_scaffoldKey, "Issue marked as resolved", Colors.greenAccent);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      body:      RefreshIndicator(
          child:SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child:Container(
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
                                  child: Container(),
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
                                      "Alert",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.sp,
                                      ),
                                    ),
                                    SizedBox(height: 7.h,),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                                      child: Text(
                                        "Click on the button below to make a distress alert to the estate security",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                        ),
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
                               alert(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),


              // navigation Menu
              Container(child: Navigation(selectedIndex: 2, onClicked: onClicked,),)
            ],
          )
      )), onRefresh: getAlert),
    );
  }
  Widget arrow() {
    return
      Container(
          child: FloatingActionButton(
            heroTag: 'arrowHeroTag',
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
  Widget notification() {
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
  Widget alert() {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            Container(
              height: ScreenUtil().screenHeight -480.h,
              child: AnimatedBuilder(
                animation: rippleAnimation,
                builder: (context, child) => Container(
                  width: rippleAnimation.value,
                  height: rippleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: customShadow,
                        color: Colors.red.withOpacity(initOpasity)),
                    child: InkWell(
                      onTap: () {
                        if(status == 0 || status == 3){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title:  (status == 0)?Text('IN DISTRESS', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900),):Text('Issue Resolved', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900),),
                              content: Text('You are about to send an emergency alert', style: TextStyle(fontSize: 12.sp),),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'No'),
                                  child: const Text('No', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900),),
                                ),
                                TextButton(
                                  onPressed: () async {

                                    Navigator.pop(context, 'Yes');
                                    if(status == 0){
                                      await setAlert();
                                    }else{
                                      await updateAlertStatus(lastAlert!, 4);
                                    }

                                  },
                                  child: const Text('Yes', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900),),
                                ),
                              ],
                            ),
                          );
                        }

                      },
                                child: AnimatedBuilder(
                                animation: scaleAnimation,
                                builder: (context, child) => Transform.scale(
                                scale: scaleAnimation.value,
                                child: Container(
                                margin: EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            child: Center(
                              child: (loading)?CircularProgressIndicator():Text(statusText(status), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18.sp)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 20.h,),
                (pending == false)?Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 10.h),
                  child: Container(
                    child: TextField(
                      controller: desc,
                      maxLines: 3,
                      maxLength: 200,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Description (Optional)',
                          labelStyle: TextStyle(
                            color: Colors.black45,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: Colors.black26,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1.0,
                            ),
                          )),
                    ),
                  ),
                ):Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
  String statusText(int status){

    if(status > 0 &&  status < 3){
      return 'Pending';
    }
    if(status == 3 ){
      return 'Mark Resolved';
    }
    return 'Push';
  }
}






