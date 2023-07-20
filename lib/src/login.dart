import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reamapp/src/service/auth.dart';
import 'package:reamapp/src/util/helper.dart';
import '../data.dart';
import 'model/response.dart' as resp;
import 'model/user.dart';
import 'util/validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _pageState = 1;

  // var _backgroundColor = Colors.white;
  var _headingColor = Colors.white;

  double _headingTop = 100;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _keyboardVisible = false;
  bool is_resident = true;
  bool loading = false;

  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final estate_code = TextEditingController();

  @override
  void initState() {
    super.initState();

    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     setState(() {
    //       _keyboardVisible = visible;
    //       print("Keyboard State Changed : $visible");
    //     });
    //   },
    // );
  }
  String? getCookie(Headers headers) {
    String? rawCookie = headers.value("set-cookie");
    String resultCookie = "";
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      resultCookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      // index = resultCookie.indexOf('=');
      // resultCookie = (index == -1) ? rawCookie : rawCookie.substring(index+1, resultCookie.length);
      return resultCookie;
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    switch (_pageState) {
      case 1:
        _headingColor = Colors.white;

        _headingTop = 90.h;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 270;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 2:
        _headingColor = Colors.white;

        _headingTop = 80.h;

        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _loginYOffset = _keyboardVisible ? 30 : 240;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

        _loginXOffset = 20;
        _registerYOffset = _keyboardVisible ? 55 : 270;
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
    }

    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
            child: Stack(
          children: <Widget>[
            AnimatedContainer(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(milliseconds: 1000),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/header.png"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 0;
                        });
                      },
                      child: Center(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              AnimatedContainer(
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration: Duration(milliseconds: 1000),
                                margin: EdgeInsets.only(
                                  top: _headingTop,
                                ),
                                child: Text(
                                  "Welcome to",
                                  style: TextStyle(
                                      color: _headingColor, fontSize: 28),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  "R.E.A.M",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: _headingColor, fontSize: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            AnimatedContainer(
              padding: EdgeInsets.all(32),
              width: _loginWidth,
              height: ScreenUtil().screenHeight - 450.h,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              transform:
                  Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_loginOpacity),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextField(
                        controller: estate_code,
                        decoration: InputDecoration(
                            labelText: 'Estate Code',
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
                      SizedBox(
                        height: 10,
                      ),
                      Divider(color: Colors.black38),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageState = 2;
                            is_resident = true;
                          });
                        },
                        child: Signin(
                          btnText: "Sign in as Residence",
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageState = 2;
                            is_resident = false;
                          });
                        },
                        child: Text(
                          "Sign in as Security",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: Text(
                          "By signing up you agree to our Privacy Policy and Terms. ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              height: ScreenUtil().screenHeight - 250.h,
              padding: const EdgeInsets.all(32),
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              transform: Matrix4.translationValues(0, _registerYOffset, 1),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h),
                        child: Text(
                          "Sign into your account",
                          style: TextStyle(fontSize: 16.h),
                        ),
                      ),
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                            labelText: 'Email',
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
                       SizedBox(
                        height: 10.h,
                      ),
                      TextField(
                        controller: password,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Colors.black45,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                color: Colors.black26,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                color: Colors.black38,
                                width: 1.0,
                              ),
                            )),
                      ),
                    ],
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
                            "is_resident": is_resident
                          };
                          Auth auth = new Auth();
                          resp.Response rs = await auth.Login(formInfo, []);
                          setState(() {
                            loading = false;
                          });
                          if (rs.status == 200) {
                            String? token = getCookie(rs.header);
                            print('token -- ' + token!);
                            displaySnackbar(
                                _scaffoldkey, rs.message, Colors.greenAccent);

                            print(rs.data);
                            // User user = User.fromJson(rs.data['user']);
                            // String token = rs.data['token'];
                            // AuthData.setUser(user);
                            // AuthData.setToken(token);
                            // String devtoken = rs.data['devicetoken'];
                            // AuthData.setDeviceToken(devtoken);

                            // startTime(1, ()=>locator<NavigationService>().pushReplacementNamed(MAINPAGE));
                            //   Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) => MainPage()));
                          }  else {
                            print('err');
                            displaySnackbar(
                                _scaffoldkey, rs.message, Colors.orange);
                          }

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => MainPage()));
                        },
                        child: PrimaryButton(
                          btnText: "Sign in",
                        ),
                      ),
                       SizedBox(
                        height: 10.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageState = 1;
                          });
                        },
                        child: OutlineBtn(
                          btnText: "Back To Home",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
