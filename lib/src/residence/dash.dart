import 'package:flutter/material.dart';
import '../../data.dart';
import 'info.dart';
import 'navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '/data.dart';
import '../model/response.dart';
import '../model/user.dart';
import '../service/auth.dart';
import '../service/authdata.dart';
import 'gpcard.dart';
import 'notcard.dart';
import 'noticeboard.dart';
import 'viscard.dart';
import 'statuscard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dash.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
final superH = (String hero){
  print("hero"+hero);
};
  // @override
  // void initState() {
  //   print(superH("hero1"));
  //   // TODO: implement initState
  //   super.initState();
  // }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          child:
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child:Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                 height: ScreenUtil().screenHeight -76.h,
                child:  Info(),
              ),
              // navigation
              Container(child: Navigation(selectedIndex: 0, onClicked: onClicked,),)
            ],
          )
          ),), onRefresh: getDashboard)
    );
  }
  User? user;
  bool loading = false;

  // final GlobalKey<_InfoState> _infoState = GlobalKey();

  @override
  void initState() {
    getUser();
    getDashboard();
  }

  @override
  void setState(fn) {
    if(this.mounted){
      super.setState(fn);
    }
  }

  getUser() async {
    User? getUser = await AuthData.getUser();
    setState(() {
      user = getUser;
    });
    // print(getUser.attr!['address']);

  }
  List residentDues = [];
  int residentDuesCount = 0;
  List  gatePassList = [];
  int  gatePassListCount = 0;
  List  subResidents = [];
  int  subResidentsCount = 0;
  List  notify = [];
  int  notifyCount = 0;
  bool inDebt = false;
  String accountBalance = "0";

  Future<bool> getDashboard() async {
    setState(() {
      loading = true;
    });

    Auth service = Auth();
    Response rs = await service.getDashboard();
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data['store']['dashboard'];
      setState(() {
        residentDues = data['resident_dues']['list']??[];
        residentDuesCount = data['resident_dues']['count']??0;
        gatePassList = data['gate_pass_list']['list']??[];
        gatePassListCount = data['gate_pass_list']['count']??0;
        subResidents = data['sub_residents']['list']??[];
        print(subResidents);
        subResidentsCount = data['sub_residents']['count']??0;
        notify = data['notification']['list']??[];
        notifyCount = data['notification']['count']??0;
        inDebt = data['in_debt'];
        accountBalance = data['account_balance'];
      });

    }

    return true;
  }
  @override
  Widget Info() {
    return Container(
      color: Colors.green,
      child: Stack(
        children: <Widget>[
          Positioned(
            height: ScreenUtil().screenHeight - 400.h,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bck.png"),
                    fit: BoxFit.cover),
              ),
              child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(20.0.w),
                    child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top:10.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: GestureDetector(
                                    onTap: () async {
                                      Auth auth = new Auth();
                                      await auth.Logout();
                                      AuthData.Logout();
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.logout_rounded,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Logout", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                        ),
                                        )
                                      ],
                                    )),
                              ),
                              Column(
                                children: [
                                  notification(context),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  Auth auth = new Auth();
                                  await auth.Logout();
                                  AuthData.Logout();
                                },
                                child: Text(
                                  "Hello \n" +
                                      ((user != null)
                                          ? user!.first_name! +
                                          " " +
                                          user!.last_name!
                                          : ''),
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.sp,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ),
          Positioned(
              top: 250.h,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: ScreenUtil().screenHeight - 320.h,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            statuscard(context),
                            notcard(context),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            gatepasscard(context),
                            viscard(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
            top: 210.h,
            left: 40.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 280.w,
                  decoration: BoxDecoration(
                    color: Color(0xFF41756A),
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.white30,
                          spreadRadius: 0.1,
                          blurRadius: 15),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0.h, vertical: 15.w),
                    child: Column(
                      children: <Widget>[
                        Text(
                          (user != null)
                              ? ((user?.Address != null)
                              ? user!.Address!
                              : '')
                              : '',
                          // '',
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          (user != null) ? user!.phone! : '',
                          style:
                          TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget statuscard(BuildContext context) {
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
                    (inDebt)?'Indebt':'Paid',
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
                    children: residentDues.map((e){
                      return Text((e['due'].toString().length> 15)?e['due'].toString().substring(0,15)+'...':e['due'], style: TextStyle(color: Colors.red),);
                    }).toList()
                ),
              ),
            ),
          )
      )
    ]);
  }

  Widget gatepasscard(BuildContext context) {
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
                    gatePassList.length.toString() +' \nGate pass',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.analytics,
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
                    children: gatePassList.map((e){
                      return Text((e['attr']['visitor'].toString().length > 13)?e['attr']['visitor'].toString().substring(0,13)+'...':e['attr']['visitor'].toString(), style: TextStyle(color: mainColor),);
                    }).toList()
                ),
              ),
            ),
          )
      )
    ]);
  }

  Widget viscard(BuildContext context) {
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
                children:  [
                  Text(
                    subResidentsCount.toString() +' \nResidents',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(
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
                    children: subResidents.map((e) => Text(e['first_name'] + e['last_name'], style: TextStyle(color: mainColor),)).toList()
                ),
              ),
            ),
          )
      )
    ]);
  }
  Widget notcard(BuildContext context) {
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
                    notifyCount.toString()+' \nNotification',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white),
                  ),
                  const Icon(
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
                  children: notify.map((e) => Text((e['title'].toString().length > 13)?e['title'].toString().substring(0,13)+'...':e['title'], style: const TextStyle(color: mainColor),)).toList(),
                ),
              ),
            ),
          )
      )
    ]);
  }
  Widget notification(BuildContext context) {
  return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Notificationhold()));
        },
        mini: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        heroTag: 'notificationHeroTag',
        child: Icon(
          Icons.notification_important_rounded,
          color: Colors.white,
          size: 30,
        ),
      ));
}
}
