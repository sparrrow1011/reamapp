import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


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

Widget PrimaryButton2(String btnText) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(13)
    ),
    padding: EdgeInsets.all(13.h),
    child: Center(
      child: Text(
        btnText,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp
        ),
      ),
    ),
  );
}
// primarybuttonred
class PrimaryButtonRed extends StatefulWidget {
  final String btnText;
  PrimaryButtonRed({required this.btnText});

  @override
  _PrimaryButtonRedState createState() => _PrimaryButtonRedState();
}
class _PrimaryButtonRedState extends State<PrimaryButtonRed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
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
              color: mainColor,
              fontSize: 14.sp
          ),
        ),
      ),
    );
  }
}

Widget OutlineBtn2(String btnText) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey,
            width: 2
        ),
        borderRadius: BorderRadius.circular(13)
    ),
    padding: EdgeInsets.all(13.h),
    child: Center(
      child: Text(
        btnText,
        style: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp
        ),
      ),
    ),
  );
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

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String qrString = "Not Scanned";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            qrString,
            style: TextStyle(color: Colors.blue, fontSize: 30),
          ),
          ElevatedButton(
            onPressed: scanQR,
            child: Text("Scan QR Code"),
          ),
          SizedBox(width: ScreenUtil().screenWidth),
        ],
      ),
    );
  }

  Future<void> scanQR() async {
    try {
      FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
          .then((value) {
        setState(() {
          qrString = value;
        });
      });
    } catch (e) {
      setState(() {
        qrString = "unable to read the qr";
      });
    }
  }
}

