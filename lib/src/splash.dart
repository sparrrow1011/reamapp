import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:reamapp/src/routes.dart';
import 'service/authdata.dart';

class Splash extends StatefulWidget {

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();


    Timer(const Duration(milliseconds: 2000), () {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => MainPage()));
      navigationPage();
    });
  }
  void navigationPage() async {
    String? token  = await AuthData.getToken();
    // String token  = null;
    if(token == null){
      Navigator.of(context).pushReplacementNamed(LOGINPAGE);
    }else{
      AuthData.getUser().then((value){
        print(value.toJson());
        if(value.is_resident == true) {
          Navigator.of(context).pushReplacementNamed(MAINPAGE);
        } else {
          Navigator.of(context).pushReplacementNamed(SECURITYMAINPAGE);
        }
      });

    }

  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bck.png"), fit: BoxFit.cover),
            ),
        child: Center(
          child: Text('R.E.A.M', style: TextStyle( color: Colors.white,
            fontSize: 50.0,),

          ),
        ),
      ),
    );
  }
}