import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../residence/gatepass.dart';
import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barcode_widget/barcode_widget.dart';

import 'navigation.dart';
import 'noticeboard.dart';




class editgatepassDetailshold extends StatelessWidget {
  String firstname,lastname,vehicleplate;

  editgatepassDetailshold({Key? key,required this.firstname,required this.lastname,required this.vehicleplate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                                    child: arrow(),
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
                                        "Gate Pass",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.sp,
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
                                      Text(
                                        "Regenerate gate pass",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150.h,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                // PUT CONTENT FUNCTION HERE
                                Container(
                                  height: ScreenUtil().screenHeight - 235.h,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            // ACCUMULATED AMOUNT
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18.w, vertical: 8.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Flexible(
                                                      child: Padding(
                                                        padding:  EdgeInsets.only(right: 10.0.w),
                                                        child: Container(
                                                          height: 40.h,
                                                          child: TextFormField(
                                                            readOnly: true,
                                                            initialValue: '$firstname',
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                            ),
                                                            decoration: InputDecoration(
                                                                contentPadding: new EdgeInsets.symmetric(
                                                                    horizontal: 13, vertical: 10),
                                                                labelText: 'First name',
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
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Flexible(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 10.0.w),
                                                        child: Container(
                                                          height: 40.h,
                                                          child: TextFormField(
                                                            readOnly: true,
                                                            initialValue: '$lastname',
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                            ),
                                                            decoration: InputDecoration(
                                                                contentPadding: new EdgeInsets.symmetric(
                                                                    horizontal: 13, vertical: 10),
                                                                labelText: 'Last name',
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
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18.w, vertical: 8.h),
                                              child: TextFormField(
                                                readOnly: true,
                                                textCapitalization: TextCapitalization.characters,
                                                initialValue: '$vehicleplate',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                                decoration: InputDecoration(
                                                    contentPadding: new EdgeInsets.symmetric(
                                                        horizontal: 13, vertical: 10),
                                                    labelText: 'Vehicle plate',
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
                                            BarcodeWidget(
                                              color: mainColor,
                                              data:  ' Name- ' + '$firstname' +' ' + '$lastname' +'\n Vehicle Plate- ' + '$vehicleplate',
                                              height: 190.h,
                                              width: 190.w,
                                              barcode: Barcode.qrCode(),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18.w, vertical: 8.h),
                                              child: TextFormField(
                                                initialValue: 'BHLD-6545-X5EL',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                                decoration: InputDecoration(
                                                    contentPadding: new EdgeInsets.symmetric(
                                                        horizontal: 13, vertical: 10),
                                                    suffixIcon: Icon(Icons.copy_rounded, color: mainColor, semanticLabel: 'Copied',) ,
                                                    labelText: 'Gate pass token',
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
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18.w, vertical: 8.h),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) => gatePasshold()));
                                                },
                                                child: PrimaryButton(
                                                  btnText: "Regenerate Gate Pass",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),


              // // navigation Menu
              // Container(child: Navigation(),)
            ],
          )
      ),
    );
  }
}


// arrow
class arrow extends StatelessWidget {
  const arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

// notification
class notification extends StatelessWidget {
  const notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}



// content function



