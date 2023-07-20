import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reamapp/src/security/login.dart';
import 'package:reamapp/src/service/authdata.dart';
import 'data.dart';
import 'src/model/site.dart';
import 'src/model/user.dart';
import 'src/residence/loading.dart';
import 'src/residence/mainpage.dart';
import 'src/routes.dart';
import 'src/service/auth.dart';
import 'src/service/locatorService.dart';
import 'src/service/navigationService.dart';
import 'src/util/helper.dart';
import 'src/util/validator.dart';
import 'src/model/response.dart' as resp;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _pageState = 0;

  var _backgroundColor = Colors.white;
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

  bool loading = false;
  String? get_Estate_Code = null;
  Site? site = null;


  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final estate_code = TextEditingController();

  final regTitle = TextEditingController();
  final regEmail = TextEditingController();
  final regFirstName = TextEditingController();
  final regLastName = TextEditingController();
  final regAddress = TextEditingController();
  final regPhone = TextEditingController();
  final regPassword = TextEditingController();

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
  Future<String?> getEstateCode(String estateCode) async {
    setState(() {
      loading = true;
    });
    List urlParam = [estateCode];
    Auth auth = new Auth();
    resp.Response rs = await auth.EstateCode(urlParam);
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      site = Site.fromJson(rs.data['store']['record']);
      if(site != null){
        AuthData.setSite(site);
      }
      return site?.subdomain;

    }  else {
      displaySnackbar(
          _scaffoldkey, rs.message, Colors.orange);
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    switch (_pageState) {
      case 0:
        _backgroundColor = Colors.green;
        _headingColor = Colors.white;

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 1:
        _headingColor = Colors.white;

        _headingTop = 90.h;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 200.h;
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
        _registerYOffset = _keyboardVisible ? 55 : 200.h;
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
    }

    return Scaffold(key: _scaffoldkey,
      body: loading ? Loading() :Stack(
        children: <Widget>[
          AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bck.png"),
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
                              "Welcome to R.E.A.M",
                              style:
                              TextStyle(color: _headingColor, fontSize: 28),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              "The first real estate management application",
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(color: _headingColor, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  controller: estate_code,
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      labelText: 'Estate Code',
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(color: Colors.white),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 8.0.w),
                                        child: GestureDetector(
                                          onTap: () async {
                                            List isEmpty = Validator.isEmpty(estate_code.text);
                                            if (isEmpty[0]) {
                                              displaySnackbar(_scaffoldkey, 'Please enter a valid estate code to proceed!!',
                                                  Colors.orange);
                                              return;
                                            }
                                            get_Estate_Code = await getEstateCode(estate_code.text);
                                            if(get_Estate_Code == null){
                                              return;
                                            }
                                            setState(() {
                                              _pageState = 1;
                                            });
                                          },
                                          child: Signin(
                                            btnText: "Sign up",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.0.w),
                                        child: GestureDetector(
                                          onTap: () async {
                                            List isEmpty = Validator.isEmpty(estate_code.text);
                                            if (isEmpty[0]) {
                                              displaySnackbar(_scaffoldkey, 'Please enter a valid estate code to proceed!!',
                                                  Colors.orange);
                                              return;
                                            }
                                            get_Estate_Code = await getEstateCode(estate_code.text);
                                            if(get_Estate_Code == null){
                                              return;
                                            }
                                            setState(() {
                                              _pageState = 2;
                                            });
                                          },
                                          child: PrimaryButton(
                                            btnText: "Sign in",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  Container(
                    child:
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: ()  async {
                            List isEmpty = Validator.isEmpty(estate_code.text);
                            if (isEmpty[0]) {
                              displaySnackbar(_scaffoldkey, 'Please enter a valid estate code.',
                                  Colors.orange);
                              return;
                            }
                            get_Estate_Code = await getEstateCode(estate_code.text);
                            if(get_Estate_Code == null){
                              return;
                            }
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>  securityLoginPage(get_Estate_Code)));
                          },
                          child: const Text(
                            "Sign in as Security",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20, top: 10),
                          child: const Text(
                            "By signing up you agree to our Privacy Policy and Terms. ",
                            textAlign: TextAlign.center,
                            style:
                            TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              )),
          AnimatedContainer(
            padding: EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 10),
            width: _loginWidth,
            height: ScreenUtil().screenHeight - 200.h,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_loginOpacity),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25), topRight: Radius.circular(25))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                      height: 40.h,
                      child: TextField(
                        controller: regTitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                        decoration: InputDecoration(
                            labelText: 'Title',
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
                        height: 15,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding:  EdgeInsets.only(right: 5.0.w),
                              child: Container(
                                height: 40.h,
                                child: TextField(
                                  controller: regFirstName,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                  ),
                                  decoration: InputDecoration(
                                      labelText: 'First name',
                                      labelStyle: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12.sp
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
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding:  EdgeInsets.only(left: 5.0.w),
                              child: Container(
                                height: 40.h,
                                child: TextField(
                                  controller: regLastName,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                  decoration: InputDecoration(
                                      labelText: 'Last name',
                                      labelStyle: TextStyle(
                                        color: Colors.black45,
                                        height: 35.h,
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
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 40.h,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: regEmail,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
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
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: TextField(
                          controller: regAddress,
                          maxLines: 2,
                          maxLength: 500,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                          decoration: InputDecoration(
                              labelText: 'Address',
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
                        height: 15,
                      ),
                      Container(
                        height: 40.h,
                        child: TextField(
                          keyboardType:TextInputType.number,
                          controller: regPhone,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                          decoration: InputDecoration(
                              labelText: 'Phone',
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
                        height: 15,
                      ),
                      // Container(
                      //   height: 40.h,
                      //   child: TextField(
                      //     controller: regPassword,
                      //     style: TextStyle(
                      //       fontSize: 12.sp,
                      //     ),
                      //     obscureText: true,
                      //     decoration: InputDecoration(
                      //         labelText: 'Create Password',
                      //         labelStyle: TextStyle(
                      //           color: Colors.black45,
                      //         ),
                      //         floatingLabelBehavior: FloatingLabelBehavior.auto,
                      //         enabledBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(13),
                      //           borderSide: BorderSide(
                      //             color: Colors.black26,
                      //             width: 1.0,
                      //           ),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(13),
                      //           borderSide: BorderSide(
                      //             color: Colors.black38,
                      //             width: 1.0,
                      //           ),
                      //         )),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      Divider(color: Colors.black38),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {

                          List isEmpty = Validator.isEmpty(regEmail.text);
                          List NotEmail = Validator.notEmail(regEmail.text);
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


                          isEmpty = Validator.isEmpty(regAddress.text);
                          if (isEmpty[0]) {
                            displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                                Colors.orange);
                            return;
                          }
                          isEmpty = Validator.isEmpty(regPhone.text);
                          if (isEmpty[0]) {
                            displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                                Colors.orange);
                            return;
                          }
                          List notNumber = Validator.notNumber(regPhone.text);
                          if (notNumber[0]) {
                            displaySnackbar(_scaffoldkey, notNumber[1].toString(),
                                Colors.orange);
                            return;
                          }
                          // isEmpty = Validator.isEmpty(regPassword.text);
                          // if (isEmpty[0]) {
                          //   displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                          //       Colors.orange);
                          //   return;
                          // }
                          setState(() {
                            loading = true;
                          });
                          Map<String, dynamic> attr = {'title': regTitle.text};
                              Map<String, dynamic> formInfo = {
                            'email': regEmail.text,
                            'first_name': regFirstName.text,
                            'last_name': regLastName.text,
                            'address': regAddress.text,
                            'phone': regPhone.text,
                            'password': regPassword.text,
                            "is_resident": true,
                            "is_mobile": true,
                                'attr':attr
                          };
                          Auth auth = Auth();
                          if(get_Estate_Code != null){
                            formInfo['site_id'] = site?.id;
                            print(formInfo);
                            resp.Response rs = await auth.Register(formInfo);
                            setState(() {
                              loading = false;
                            });
                            if (rs.status == 200)  {
                              displaySnackbar(
                                  _scaffoldkey, "Sign up successful. Administrator will contact you with login details.", Colors.greenAccent);
                              setState(() {
                                _pageState = 2;
                              });
                            }  else {
                              password.clear();
                              print('err');
                              regTitle.clear();
                              regEmail.clear();
                              regFirstName.clear();
                              regLastName.clear();
                              regPhone.clear();
                              regAddress.clear();
                              displaySnackbar(
                                  _scaffoldkey, rs.message, Colors.orange);

                            }

                          }else{
                            displaySnackbar(
                                _scaffoldkey, "Enter estate code to proceed", Colors.orange);
                          }
                        },
                        child: PrimaryButton(
                          btnText: "Sign up",
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h, top: 10.h),
                        child: Text(
                          "By signing up you agree to our Privacy Policy and Terms. ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black45, fontSize: 12.sp),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.sp),),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageState = 2;
                              });
                            },
                            child: Text(
                              "Sign in",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mainColor,
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            height: ScreenUtil().screenHeight - 200.h,
            padding: const EdgeInsets.all(32),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(0, _registerYOffset, 1),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25), topRight: Radius.circular(25))),
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
                    Container(
                      height: 40.h,
                      child: TextField(
                        controller: email,
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
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
                          "is_resident": true,
                          "is_mobile": true,
                        };
                        Auth auth = Auth();
                        if(get_Estate_Code != null){
                          resp.Response rs = await auth.Login(formInfo, [get_Estate_Code]);
                          setState(() {
                            loading = false;
                          });
                          if (rs.status == 200) {
                            String? token = getCookie(rs.header);
                            if(token ==null){
                              displaySnackbar(
                                  _scaffoldkey, "Invalid email or password.", Colors.orangeAccent);
                              return;
                            }
                            print('token -- ' + token);
                            displaySnackbar(
                                _scaffoldkey, "Login successful.", Colors.greenAccent);
                            User user = User.fromJson(rs.data['store']['user']);
                            print(user.Address);
                            user.is_resident = true;
                            AuthData.setUser(user);
                            AuthData.setToken(token);

                            startTime(1, ()=>locator<NavigationService>().pushReplacementNamed(MAINPAGE));
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
                          _pageState = 0;
                        });
                      },
                      child: OutlineBtn(
                        btnText: "Back to welcome page",
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
