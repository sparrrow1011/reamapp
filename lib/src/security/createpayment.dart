import 'package:flutter/material.dart';
import 'package:reamapp/src/model/paymentOptions.dart';
import 'data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'navigation.dart';
import 'noticeboard.dart';



class createPaymenthold extends StatefulWidget {
  const createPaymenthold({Key? key}) : super(key: key);

  @override
  _createPaymentholdState createState() => _createPaymentholdState();
}

class _createPaymentholdState extends State<createPaymenthold> {
  int selectedIndex = 0;

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

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
                                      "Accounts",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.sp,
                                      ),
                                    ),
                                    SizedBox(height: 7.h,),
                                    Text(
                                      "Create Payment",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
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
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: const <Widget>[
                              // PUT CONTENT FUNCTION HERE
                              createPayment(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),


              // navigation Menu
              Container(child: Navigation(selectedIndex: selectedIndex, onClicked: onClicked,),)
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
// create payment

class createPayment extends StatefulWidget {
  const createPayment({Key? key}) : super(key: key);

  @override
  _createPaymentState createState() => _createPaymentState();
}

class _createPaymentState extends State<createPayment> {
  paymentOptions _option = paymentOptions.Bank;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                // ACCUMULATED AMOUNT
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 28.w, vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Flexible(
                          child: Padding(
                            padding:  EdgeInsets.only(right: 20.0.w),
                            child: Container(
                              height: 40.h,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                                initialValue: '22/82/2021',
                                decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 10),
                                    labelText: 'Date',
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
                            padding: EdgeInsets.only(left: 20.0.w),
                            child: Container(
                              height: 40.h,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                                initialValue: '₦500,000',
                                decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 10),
                                    labelText: 'Amount paid',
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

                Divider(color: Colors.black38),

                // DUES TO PAY
                Container(
                  height: 100.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        // DUES TO BE PAID START
                        Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: 20.0.w, vertical: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text('Service Charge', style: TextStyle(fontSize: 11.sp),),
                                    Text(
                                      ' (₦500,000)',
                                      style: TextStyle(color: Colors.red, fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding:  EdgeInsets.only(left: 20.0.w),
                                  child: Container(
                                    height: 30.h,
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: new EdgeInsets.symmetric(
                                              horizontal: 13.w, vertical: 2.h),
                                          prefixText: '₦ ',
                                          labelText: 'Amount Paid',
                                          labelStyle: TextStyle(
                                            color: Colors.black45,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                            borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
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
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: 20.0.w, vertical: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text('Service Charge', style: TextStyle(fontSize: 11.sp),),
                                    Text(
                                      ' (₦500,000)',
                                      style: TextStyle(color: Colors.red, fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding:  EdgeInsets.only(left: 20.0.w),
                                  child: Container(
                                    height: 30.h,
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: new EdgeInsets.symmetric(
                                              horizontal: 13.w, vertical: 2.h),
                                          prefixText: '₦ ',
                                          labelText: 'Amount Paid',
                                          labelStyle: TextStyle(
                                            color: Colors.black45,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                            borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
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
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: 20.0.w, vertical: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text('Service Charge', style: TextStyle(fontSize: 11.sp),),
                                    Text(
                                      ' (₦500,000)',
                                      style: TextStyle(color: Colors.red, fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding:  EdgeInsets.only(left: 20.0.w),
                                  child: Container(
                                    height: 30.h,
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: new EdgeInsets.symmetric(
                                              horizontal: 13.w, vertical: 2.h),
                                          prefixText: '₦ ',
                                          labelText: 'Amount Paid',
                                          labelStyle: TextStyle(
                                            color: Colors.black45,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                            borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
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
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: 20.0.w, vertical: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text('Service Charge', style: TextStyle(fontSize: 11.sp),),
                                    Text(
                                      ' (₦500,000)',
                                      style: TextStyle(color: Colors.red, fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding:  EdgeInsets.only(left: 20.0.w),
                                  child: Container(
                                    height: 30.h,
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: new EdgeInsets.symmetric(
                                              horizontal: 13.w, vertical: 2.h),
                                          prefixText: '₦ ',
                                          labelText: 'Amount Paid',
                                          labelStyle: TextStyle(
                                            color: Colors.black45,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                            borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
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
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: 20.0.w, vertical: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text('Service Charge', style: TextStyle(fontSize: 11.sp),),
                                    Text(
                                      ' (₦500,000)',
                                      style: TextStyle(color: Colors.red, fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding:  EdgeInsets.only(left: 20.0.w),
                                  child: Container(
                                    height: 30.h,
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: new EdgeInsets.symmetric(
                                              horizontal: 13.w, vertical: 2.h),
                                          prefixText: '₦ ',
                                          labelText: 'Amount Paid',
                                          labelStyle: TextStyle(
                                            color: Colors.black45,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                            borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
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
                        ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(color: Colors.black38),

                // PAYMENT OPTION
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0, top: 10),
                          child: Text(
                            'Payment option',
                            style:
                            TextStyle(color: Colors.black54, fontSize: 20.sp),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                                activeColor: mainColor,
                                value: paymentOptions.Bank,
                                groupValue: _option,
                                onChanged: (paymentOptions? value) {
                                  setState(() {
                                    _option = (value == null)? paymentOptions.Bank: value;
                                  });
                                }),
                            Text(
                              'Bank Transaction',
                              style: TextStyle(
                                fontSize: 10.0.sp,
                              ),
                            ),
                            Radio(
                                activeColor: mainColor,
                                value: paymentOptions.Paystack,
                                groupValue: _option,
                                onChanged: (paymentOptions? value) {
                                  setState(() {
                                    _option = (value == null)? paymentOptions.Bank: value;
                                  });
                                }),
                            Text(
                              'Paystack',
                              style: new TextStyle(
                                fontSize: 10.0.sp,
                              ),
                            ),
                            Radio(
                                activeColor: mainColor,
                                value: paymentOptions.Flutterwave,
                                groupValue: _option,
                                onChanged: (paymentOptions? value) {
                                  setState(() {
                                    _option = (value == null)? paymentOptions.Bank: value;
                                  });
                                }),
                            Text(
                              'Flutterwave',
                              style: new TextStyle(
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 20.0.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding:  EdgeInsets.only(right: 5.0.w),
                              child: Container(
                                height: 35.h,
                                child: TextFormField(
                                  style: TextStyle(fontSize: 12.sp),
                                  decoration: InputDecoration(
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 13.w, vertical: 10.h),
                                      labelText: 'Date',
                                      labelStyle: TextStyle(
                                        color: Colors.black45,
                                      ),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11.r),
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11.r),
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
                              padding:  EdgeInsets.only(right: 5.0.w, left: 5.0.w, ),
                              child: Container(
                                height: 35.h,
                                child: TextFormField(
                                  style: TextStyle(fontSize: 12.sp),
                                  decoration: InputDecoration(
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 13.w, vertical: 10.h),
                                      labelText: 'Bank name',
                                      labelStyle: TextStyle(
                                        color: Colors.black45,
                                      ),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11.r),
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11.r),
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
                                height: 35.h,
                                child: TextFormField(
                                  style: TextStyle(fontSize: 12.sp),
                                  decoration: InputDecoration(
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 13.w, vertical: 10.h),
                                      labelText: 'Teller number',
                                      labelStyle: TextStyle(
                                        color: Colors.black45,
                                      ),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11.r),
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11.r),
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
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                // ACTION BUTTON
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.0.w),
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  ;
                                });
                              },
                              child: OutlineBtn(
                                btnText: "Cancel",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0.w),
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  ;
                                });
                              },
                              child: PrimaryButton(
                                btnText: "Pay",
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


