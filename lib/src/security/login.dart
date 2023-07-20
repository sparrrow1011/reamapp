import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reamapp/src/model/user.dart';
import 'package:reamapp/src/security/loading.dart';
import 'package:reamapp/src/service/auth.dart';
import 'package:reamapp/src/service/authdata.dart';
import 'package:reamapp/src/service/locatorService.dart';
import 'package:reamapp/src/service/navigationService.dart';
import 'package:reamapp/src/util/helper.dart';
import 'package:reamapp/src/util/validator.dart';

import '../model/response.dart' as resp;
import '../../data.dart';
import '../routes.dart';



class securityLoginPage extends StatefulWidget {
  String? estateCode;
   securityLoginPage(this.estateCode, {Key? key}) : super(key: key);

  @override
  _securityLoginPageState createState() => _securityLoginPageState(estateCode);
}

class _securityLoginPageState extends State<securityLoginPage> {

  String? estateCode;
  int selectedIndex = 0;
  bool loading = false;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final email = TextEditingController();
  final password = TextEditingController();
  _securityLoginPageState(this.estateCode);

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      body:  loading ? Loading():Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              // page main content container
              Container(
                  height: ScreenUtil().screenHeight,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        height: 350.h,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: const BoxDecoration(
                            image:  DecorationImage(
                                image: AssetImage("assets/images/bck.png"),
                                fit: BoxFit.cover),
                          ),
                          child: Container(
                            child:  Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 20.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                        child: arrow(context),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(30.0.r),
                                    child: Text(
                                      "Welcome to R.E.A.M security",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  Text(
                                    "Please login with your security credentials",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 250.h,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Column(
                                children:  <Widget>[
                                  // PUT CONTENT FUNCTION HERE
                                  Container(
                                    height: ScreenUtil().screenHeight - 235.h,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              Container(
                                                height: 40.h,
                                                child: TextField(
                                                  controller: email,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                  decoration: InputDecoration(
                                                      labelText: 'Email.',
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
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Container(
                                                height: 40.h,
                                                child: TextField(
                                                  controller: password,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                  obscureText: true,
                                                  decoration: InputDecoration(
                                                      labelText: 'Password',
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
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () async {
                                                  List isEmpty = Validator.isEmpty(email.text);
                                                  List NotEmail = Validator.notEmail(email.text);
                                                  if (isEmpty[0]) {
                                                    displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                                                        Colors.orange);
                                                    return;
                                                  }
                                                  if (NotEmail[0]) {
                                                    displaySnackbar(_scaffoldkey,
                                                        NotEmail[1].toString(), Colors.orange);
                                                    return;
                                                  }
                                                  isEmpty = Validator.isEmpty(password.text);
                                                  if (isEmpty[0]) {
                                                    displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                                                        Colors.orange);
                                                    return;
                                                  }
                                                  setState(() {
                                                    loading = true;
                                                  });

                                                  Map<String, dynamic> formInfo = {
                                                    'email': email.text,
                                                    'password': password.text,
                                                    "is_resident": false,
                                                    "is_mobile": true,
                                                  };
                                                  Auth auth = Auth();
                                                  if(estateCode != null){
                                                    resp.Response rs = await auth.Login(formInfo, [estateCode]);
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    if (rs.status == 200) {
                                                      Map<String, dynamic> data = Map.from(rs.data);
                                                      if(data.containsKey('store')){
                                                        String? token = getCookie(rs.header);
                                                        print('token -- ' + token!);
                                                        displaySnackbar(
                                                            _scaffoldkey, "Login successful.", Colors.greenAccent);

                                                        print(rs.data);
                                                        User user = User.fromJson(rs.data['store']['user']);
                                                        user.is_resident = false;
                                                        print(user.toJson());
                                                        AuthData.setUser(user);
                                                        AuthData.setToken(token);

                                                        startTime(1, ()=>locator<NavigationService>().pushNamedAndRemoveUntil(SECURITYMAINPAGE));
                                                      }else{
                                                        String errMessage = data['errors']['status'];
                                                        displaySnackbar(
                                                            _scaffoldkey, errMessage, Colors.orange);
                                                      }

                                                    }  else {
                                                      password.clear();
                                                      print('err');

                                                      displaySnackbar(
                                                          _scaffoldkey, rs.message, Colors.orange);
                                                    }

                                                  }else{
                                                    displaySnackbar(
                                                        _scaffoldkey, "Enter estate code to proceed", Colors.orange);
                                                  }
                                                  // Navigator.push(context,
                                                  //     MaterialPageRoute(builder: (context) => MainPage()));
                                                },
                                                child: PrimaryButton(
                                                  btnText: "Sign in",
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          )
      ),
    );
  }
}


  // Widget loginSecurity(BuildContext context, _scaffoldkey, TextEditingController email, TextEditingController  password, String? estatecode) {
  //   return Container(
  //     height: ScreenUtil().screenHeight - 235.h,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Column(
  //             children: <Widget>[
  //               SizedBox(
  //                 height: 20.h,
  //               ),
  //               Container(
  //                 height: 40.h,
  //                 child: TextField(
  //                   controller: email,
  //                   style: TextStyle(
  //                     fontSize: 12.sp,
  //                   ),
  //                   decoration: InputDecoration(
  //                       labelText: 'Email.',
  //                       labelStyle: TextStyle(
  //                         color: Colors.black45,
  //                       ),
  //                       floatingLabelBehavior: FloatingLabelBehavior.auto,
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(13),
  //                         borderSide: BorderSide(
  //                           color: Colors.black26,
  //                           width: 1.0,
  //                         ),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(13),
  //                         borderSide: BorderSide(
  //                           color: Colors.black38,
  //                           width: 1.0,
  //                         ),
  //                       )),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10.h,
  //               ),
  //               Container(
  //                 height: 40.h,
  //                 child: TextField(
  //                   controller: password,
  //                   style: TextStyle(
  //                     fontSize: 12.sp,
  //                   ),
  //                   obscureText: true,
  //                   decoration: InputDecoration(
  //                       labelText: 'Password',
  //                       labelStyle: TextStyle(
  //                         color: Colors.black45,
  //                       ),
  //                       floatingLabelBehavior: FloatingLabelBehavior.auto,
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(13),
  //                         borderSide: BorderSide(
  //                           color: Colors.black26,
  //                           width: 1.0,
  //                         ),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(13),
  //                         borderSide: BorderSide(
  //                           color: Colors.black38,
  //                           width: 1.0,
  //                         ),
  //                       )),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 20.h,
  //           ),
  //           Column(
  //             children: <Widget>[
  //               InkWell(
  //                 onTap: () {
  //                   List isEmpty = Validator.isEmpty(email.text);
  //                   List NotEmail = Validator.notEmail(email.text);
  //                   if (isEmpty[0]) {
  //                     displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
  //                         Colors.orange);
  //                     return;
  //                   }
  //                   if (NotEmail[0]) {
  //                     displaySnackbar(_scaffoldkey,
  //                         NotEmail[1].toString(), Colors.orange);
  //                     return;
  //                   }
  //                   isEmpty = Validator.isEmpty(password.text);
  //                   if (isEmpty[0]) {
  //                     displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
  //                         Colors.orange);
  //                     return;
  //                   }
  //                   setState(() {
  //                     loading = true;
  //                   });
  //
  //                   Map<String, dynamic> formInfo = {
  //                     'email': email.text,
  //                     'password': password.text,
  //                     "is_resident": true,
  //                     "is_mobile": true,
  //                   };
  //                   Auth auth = Auth();
  //                   if(get_Estate_Code != null){
  //                     resp.Response rs = await auth.Login(formInfo, [get_Estate_Code]);
  //                     setState(() {
  //                       loading = false;
  //                     });
  //                     if (rs.status == 200) {
  //                       String? token = getCookie(rs.header);
  //                       print('token -- ' + token!);
  //                       displaySnackbar(
  //                           _scaffoldkey, rs.message, Colors.greenAccent);
  //
  //                       print(rs.data);
  //                       User user = User.fromJson(rs.data['store']['user']);
  //                       AuthData.setUser(user);
  //                       AuthData.setToken(token);
  //
  //                       startTime(1, ()=>locator<NavigationService>().pushReplacementNamed(MAINPAGE));
  //                     }  else {
  //                       password.clear();
  //                       print('err');
  //                       displaySnackbar(
  //                           _scaffoldkey, rs.message, Colors.orange);
  //                     }
  //
  //                   }else{
  //                     displaySnackbar(
  //                         _scaffoldkey, "Enter estate code to proceed", Colors.orange);
  //                   }
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (context) => MainPage()));
  //                 },
  //                 child: PrimaryButton(
  //                   btnText: "Sign in",
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }




  Widget arrow(BuildContext context) {
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

