import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// inputwithicon
class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  InputWithIcon({required this.icon, required this.hint});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}
class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFBC7C7C7),
              width: 2
          ),
          borderRadius: BorderRadius.circular(13)
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.icon,
                size: 20,
                color: Color(0xFFBB9B9B9),
              )
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: widget.hint
              ),
            ),
          )
        ],
      ),
    );
  }
}


// primarybutton
class PrimaryButton extends StatefulWidget {
  final String btnText;
  PrimaryButton({required this.btnText});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}
class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF58958A),
          borderRadius: BorderRadius.circular(13)
      ),
      padding: EdgeInsets.all(13.h),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp
          ),
        ),
      ),
    );
  }
}


// signinbutton
class Signin extends StatefulWidget {
  final String btnText;
  Signin({required this.btnText});

  @override
  _SigninState createState() => _SigninState();
}
class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFD7FAF4),
          borderRadius: BorderRadius.circular(13)
      ),
      padding: EdgeInsets.all(15),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
              color: Color(0xFF58958A),
              fontSize: 16
          ),
        ),
      ),
    );
  }
}


// outlinebutton
class OutlineBtn extends StatefulWidget {
  final String btnText;
  OutlineBtn({required this.btnText});

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}
class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFF58958A),
              width: 2
          ),
          borderRadius: BorderRadius.circular(13)
      ),
      padding: EdgeInsets.all(13.h),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 14.sp
          ),
        ),
      ),
    );
  }
}

List<BoxShadow> customShadow = [
  BoxShadow(
      color: Colors.white.withOpacity(0.5), spreadRadius: -5, offset: Offset(-5, -5), blurRadius: 30),
  BoxShadow(
      color: Colors.black.withOpacity(.3),
      spreadRadius: 2,
      offset: Offset(7, 7),
      blurRadius: 20)
];

// colors
const navColor = Color(0xFF58958A);
const unselected = Color(0xFF7FACA4);
const mainColor = Color(0xFF41756A);

class backshape extends StatelessWidget {
  const backshape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(0.5, -0.01),
              end: Alignment(0.4, -0.6),
              colors: [
                Color(0xFF58958A),
                Color(0xFF58958A),
              ]),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),

      child: Stack(
        children: <Widget>[

          Positioned(
              bottom: 20,
              right: 20,
              child: Text('',
                style: TextStyle(color: Colors.white,fontSize: 20),
              )),
        ],
      ),
    );
  }
}

class todaydate extends StatefulWidget {
  const todaydate({Key? key}) : super(key: key);

  @override
  _todaydateState createState() => _todaydateState();
}

class _todaydateState extends State<todaydate> {
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    return Text(
      DateFormat.jm().format(now),
    );
  }
}



