import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reamapp/src/model/alert.dart';
import 'package:reamapp/src/model/response.dart';
import 'package:reamapp/src/service/AlertService.dart';
import 'alert_adress.dart';
import 'data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expandable/expandable.dart';
// import 'dart:math' as math;
import 'navigation.dart';

class alerthold extends StatefulWidget {
  const alerthold({Key? key}) : super(key: key);

  @override
  _alertholdState createState() => _alertholdState();
}

class _alertholdState extends State<alerthold> with TickerProviderStateMixin {
  int selectedIndex = 2;
  late AnimationController rippleController;
  late AnimationController scaleController;

  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;
  bool loading = false;
  bool buttonLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Alert> alertList = [];
  int limit = 10;
  int offset = 0;
  int status = 0;

  @override
  void initState() {
    super.initState();

    rippleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    scaleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    rippleAnimation =
        Tween<double>(begin: 100.0, end: 110.0).animate(rippleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              rippleController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              rippleController.forward();
            }
          });

    scaleAnimation =
        Tween<double>(begin: 1.0, end: 40.0).animate(scaleController);

    rippleController.forward();
    initList();
  }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<bool> initList() async {
    offset = 0;
    loading = true;
    List<Alert> val = await getAlertList();
    setState(() {
      alertList = val;
      loading = false;
    });
    return true;
  }

  moreLists() {
    print('lastpage ${offset}');

    if (offset > -1) {
      offset = offset + limit;

      getAlertList(ispaginate: true).then((val) {
        if (val.isEmpty) {
          offset = -1;
        }
        setState(() {
          alertList.addAll(val);
          loading = false;
        });
      });
    }
  }

  Future<List<Alert>> getAlertList({bool ispaginate: false}) async {
    Map<String, dynamic> param = {'_filter': ''};
    if (status > 0) {
      param['status'] = status;
    }
    // else {
    //   param['_filter'] =
    //       param['_filter'] + 'status:>0,\$order:date_created desc';
    // }
    if (ispaginate == true) {
      param['_filter'] = param['_filter'] + '\$limit:$limit,\$offset:$offset';
    }
    print(param);
    AlertService service = AlertService();
    Response rs = await service.alertList(param);
    if (rs.status == 200) {
      Map data = rs.data['store'];
      List? dataList = data['list'];
      if (dataList != null) {
        return List.from(dataList).map((elem) {
          return Alert.fromJson(elem);
        }).toList();
      } else {
        return <Alert>[];
      }
    } else {
      return <Alert>[];
    }
  }

  updateAlertStatus(Alert alert, int status) async {
    setState(() {
      buttonLoading = true;
    });

    AlertService service = AlertService();
    Response rs = await service
        .updateAlert({'status': status, 'attr': alert.attr}, [alert.id]);
    setState(() {
      buttonLoading = false;
    });
    if (rs.status == 200) {
      // Map data = rs.data['store']['dashboard'];
      // setState(() {
      //   pending = true;
      // });

    }
  }

  statusCheck() async {
    loading = true;
    List<Alert> val = await getAlertList();
    setState(() {
      alertList = val;
      loading = false;
    });
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    rippleController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // page main content container
                  Container(
                      height: ScreenUtil().screenHeight - 76.h,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    // PUT CONTENT FUNCTION HERE
                                    alert(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),

                  // navigation Menu
                  Container(
                    child: Navigation(
                      selectedIndex: selectedIndex,
                      onClicked: onClicked,
                    ),
                  )
                ],
              ))),
          onRefresh: initList),
    );
  }

  Widget alert() {
    return Column(
      children: [
        Container(
          height: 100.h,
          child: AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) => Container(
              width: rippleAnimation.value,
              height: rippleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: customShadow,
                    color: Colors.white.withOpacity(0.9)),
                child: AnimatedBuilder(
                  animation: scaleAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: scaleAnimation.value,
                    child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Center(
                          child: Icon(
                            Icons.warning_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 200.0.w),
          child: DropdownButtonHideUnderline(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                child: DropdownButton(
                  icon: Icon(Icons.arrow_drop_down_circle, size: 15.h, color: Colors.red,),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  style: TextStyle(
                      color: Colors.red, fontSize: 13.sp,  decorationColor: Colors.white
                  ),
                  items: const [
                    DropdownMenuItem(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "All",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "New",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Received",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Treated",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Closed",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      value: 4,
                    ),
                  ],
                  value: status,
                  onChanged: (value) {
                    setState(() {
                      status = int.parse(value.toString());
                    });
                    statusCheck();
                  },
                  isExpanded: true,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h,),
        Container(
          height: ScreenUtil().screenHeight - 284.h,
          child: SingleChildScrollView(
            child: Column(
                children: alertList.map((e) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.0.w, top: 10.h),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.name ?? "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w900)),
                                Text(e.Address ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                    ))
                              ]),
                        ),
                      ),
                      (buttonLoading)
                          ? CircularProgressIndicator()
                          : alertButton(context, e),
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ],
              );
            }).toList()),
          ),
        )
      ],
    );
  }

  Widget alertButton(BuildContext context, Alert alert) {
    switch (alert.status) {
      case 1:
        return GestureDetector(
            onTap: () async {
              await updateAlertStatus(alert, 2);
              setState(() {
                alert.status = 2;
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Acknowledge',
                  style: TextStyle(color: Colors.red, fontSize: 10.sp),
                ),
              ),
            ));
      case 2:
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => alert_addresshold(alert: alert)));
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Address',
                  style: TextStyle(color: Colors.red, fontSize: 10.sp),
                ),
              ),
            ));
      case 3:
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => alert_addresshold(
                            alert: alert,
                            edit: false,
                          )));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Addressed',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ));
      case 4:
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => alert_addresshold(
                            alert: alert,
                            edit: false,
                          )));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Addressed',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ));

      default:
        return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Acknowledge',
                  style: TextStyle(color: Colors.red, fontSize: 10.sp),
                ),
              ),
            ));
    }
  }
}
