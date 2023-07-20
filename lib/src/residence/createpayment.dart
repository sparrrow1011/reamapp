import 'package:flutter/material.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:reamapp/data.dart';
import 'package:reamapp/src/model/dues.dart';
import 'package:reamapp/src/model/paymentOptions.dart';
import 'package:reamapp/src/model/response.dart';
import 'package:reamapp/src/model/status.dart';
import 'package:reamapp/src/model/user.dart';
import 'package:reamapp/src/residence/loading.dart';
import 'package:reamapp/src/residence/selectpayment.dart';
import 'package:reamapp/src/service/AccountService.dart';
import 'package:reamapp/src/service/authdata.dart';
import 'package:reamapp/src/service/locatorService.dart';
import 'package:reamapp/src/service/navigationService.dart';
import 'package:reamapp/src/util/helper.dart';
import 'noticeboard.dart';




class createPaymenthold extends StatefulWidget {
  Status residentStatus;
   createPaymenthold(this.residentStatus, {Key? key}) : super(key: key);

  @override
  _createPaymentholdState createState() => _createPaymentholdState();
}



class _createPaymentholdState extends State<createPaymenthold> {
  paymentOptions _option = paymentOptions.Bank;
  int selectedIndex = 0;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final date = TextEditingController();
  final amount = TextEditingController();
  bool loading = false;
  User? user;
  List<Dues> dues = [];
  Map <String, TextEditingController> duesController = {};
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date.text = DateTime.now().toString();
    getUser().then((savedUser) {
      setState(() {
        user = savedUser;
      });
      getDues();
    });
  }
  getUser() {
    return AuthData.getUser();
  }

  getDues() async {
    setState(() {
      loading = true;
    });

    AccountService service = AccountService();
    Response rs = await service.getDues([user?.id]);
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      List? dataList = data['list'];
      if (dataList != null) {
         dues =  List.from(dataList).map((elem) {
          return Dues.fromJson(elem);
        }).toList();
      }
    } else {
      displaySnackbar(_scaffoldkey, "An error occurred while retrieving dues.", Colors.redAccent);
      locator<NavigationService>().pop();
    }
  }
  sumAll(){
    int sum = 0;
    for(Dues d in dues){

      sum += (d.controller.text.isEmpty)? 0 : int.parse(d.controller.text);
    }
    setState(() {
      amount.text = sum.toString();
    });

  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldkey,
      body: (loading)?Loading():SingleChildScrollView(child:
      Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              // page main content container
              Container(
                  height: ScreenUtil().screenHeight,
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
                            children:  <Widget>[
                              // PUT CONTENT FUNCTION HERE
                              createPayment(context),
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
      )),
    );
  }
  Widget arrow() {
    return
      Container(
          child: FloatingActionButton( heroTag: "arrowHeroTag",
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
  Widget notification() {
    return
      Container(
          child: FloatingActionButton( heroTag: 'notificationHeroTag',
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
  Widget createPayment(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 180.h,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
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
                              readOnly: true,
                              controller: date,
                              onTap: (){
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      print('confirm $date');
                                      this.date.text = date.toLocal().toString();
                                    }, currentTime: DateTime.parse(this.date.text), locale: LocaleType.en);
                              },
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
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
                              keyboardType: TextInputType.number,
                              controller: amount,
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                              // initialValue: '₦500,000',
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 10),
                                  labelText: 'Amount paid',
                                  labelStyle: TextStyle(
                                    color: Colors.black45,
                                  ),prefixText: '₦ ',
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
              ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 5.0.h,
                  maxHeight: 265.0.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // DUES TO BE PAID START
                    for(Dues d in dues)Padding(
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
                                  ' (₦ '+ (d.amount ??'0.00')+')',
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
                                  controller: d.controller,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                  ),
                                  onChanged: (val){
                                    sumAll();
                                  },
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



              // PAYMENT OPTION

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Row(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(left: 28.0, top: 10),
              //           child: Text(
              //             'Payment option',
              //             style:
              //             TextStyle(color: Colors.black54, fontSize: 20.sp),
              //           ),
              //         ),
              //       ],
              //     ),
              //     Padding(
              //       padding: EdgeInsets.all(8.0.w),
              //       child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: <Widget>[
              //             Radio(
              //                 activeColor: mainColor,
              //                 value: paymentOptions.Bank,
              //                 groupValue: _option,
              //                 onChanged: (paymentOptions? value) {
              //                   setState(() {
              //                     _option = value;
              //                   });
              //                 }),
              //             Text(
              //               'Bank Transaction',
              //               style: TextStyle(
              //                 fontSize: 10.0.sp,
              //               ),
              //             ),
              //             Radio(
              //                 activeColor: mainColor,
              //                 value: paymentOptions.Paystack,
              //                 groupValue: _option,
              //                 onChanged: (paymentOptions? value) {
              //                   setState(() {
              //                     _option = value;
              //                   });
              //                 }),
              //             Text(
              //               'Paystack',
              //               style: new TextStyle(
              //                 fontSize: 10.0.sp,
              //               ),
              //             ),
              //             Radio(
              //                 activeColor: mainColor,
              //                 value: paymentOptions.Flutterwave,
              //                 groupValue: _option,
              //                 onChanged: (paymentOptions? value) {
              //                   setState(() {
              //                     _option = value;
              //                   });
              //                 }),
              //             Text(
              //               'Flutterwave',
              //               style: new TextStyle(
              //                 fontSize: 10.0.sp,
              //               ),
              //             ),
              //           ]),
              //     ),


              //     // Padding(
              //     //   padding:  EdgeInsets.symmetric(
              //     //       horizontal: 20.0.w, vertical: 10.h),
              //     //   child: Row(
              //     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     //     children: <Widget>[
              //     //       Flexible(
              //     //         child: Padding(
              //     //           padding:  EdgeInsets.only(right: 5.0.w),
              //     //           child: Container(
              //     //             height: 35.h,
              //     //             child: TextFormField(
              //     //               style: TextStyle(fontSize: 12.sp),
              //     //               decoration: InputDecoration(
              //     //                   contentPadding: new EdgeInsets.symmetric(
              //     //                       horizontal: 13.w, vertical: 10.h),
              //     //                   labelText: 'Date',
              //     //                   labelStyle: TextStyle(
              //     //                     color: Colors.black45,
              //     //                   ),
              //     //                   floatingLabelBehavior:
              //     //                   FloatingLabelBehavior.auto,
              //     //                   enabledBorder: OutlineInputBorder(
              //     //                     borderRadius: BorderRadius.circular(11.r),
              //     //                     borderSide: BorderSide(
              //     //                       color: Colors.black26,
              //     //                       width: 1.0,
              //     //                     ),
              //     //                   ),
              //     //                   focusedBorder: OutlineInputBorder(
              //     //                     borderRadius: BorderRadius.circular(11.r),
              //     //                     borderSide: BorderSide(
              //     //                       color: Colors.black38,
              //     //                       width: 1.0,
              //     //                     ),
              //     //                   )),
              //     //             ),
              //     //           ),
              //     //         ),
              //     //       ),
              //     //       Flexible(
              //     //         child: Padding(
              //     //           padding:  EdgeInsets.only(right: 5.0.w, left: 5.0.w, ),
              //     //           child: Container(
              //     //             height: 35.h,
              //     //             child: TextFormField(
              //     //               style: TextStyle(fontSize: 12.sp),
              //     //               decoration: InputDecoration(
              //     //                   contentPadding: new EdgeInsets.symmetric(
              //     //                       horizontal: 13.w, vertical: 10.h),
              //     //                   labelText: 'Bank name',
              //     //                   labelStyle: TextStyle(
              //     //                     color: Colors.black45,
              //     //                   ),
              //     //                   floatingLabelBehavior:
              //     //                   FloatingLabelBehavior.auto,
              //     //                   enabledBorder: OutlineInputBorder(
              //     //                     borderRadius: BorderRadius.circular(11.r),
              //     //                     borderSide: BorderSide(
              //     //                       color: Colors.black26,
              //     //                       width: 1.0,
              //     //                     ),
              //     //                   ),
              //     //                   focusedBorder: OutlineInputBorder(
              //     //                     borderRadius: BorderRadius.circular(11.r),
              //     //                     borderSide: BorderSide(
              //     //                       color: Colors.black38,
              //     //                       width: 1.0,
              //     //                     ),
              //     //                   )),
              //     //             ),
              //     //           ),
              //     //         ),
              //     //       ),
              //     //       Flexible(
              //     //         child: Padding(
              //     //           padding:  EdgeInsets.only(left: 5.0.w),
              //     //           child: Container(
              //     //             height: 35.h,
              //     //             child: TextFormField(
              //     //               style: TextStyle(fontSize: 12.sp),
              //     //               decoration: InputDecoration(
              //     //                   contentPadding: new EdgeInsets.symmetric(
              //     //                       horizontal: 13.w, vertical: 10.h),
              //     //                   labelText: 'Teller number',
              //     //                   labelStyle: TextStyle(
              //     //                     color: Colors.black45,
              //     //                   ),
              //     //                   floatingLabelBehavior:
              //     //                   FloatingLabelBehavior.auto,
              //     //                   enabledBorder: OutlineInputBorder(
              //     //                     borderRadius: BorderRadius.circular(11.r),
              //     //                     borderSide: BorderSide(
              //     //                       color: Colors.black26,
              //     //                       width: 1.0,
              //     //                     ),
              //     //                   ),
              //     //                   focusedBorder: OutlineInputBorder(
              //     //                     borderRadius: BorderRadius.circular(11.r),
              //     //                     borderSide: BorderSide(
              //     //                       color: Colors.black38,
              //     //                       width: 1.0,
              //     //                     ),
              //     //                   )),
              //     //             ),
              //     //           ),
              //     //         ),
              //     //       ),
              //     //     ],
              //     //   ),
              //     // ),
              //   ],
              // ),


            ],
          ),
          // ACCUMULATED AMOUNT


          // ACTION BUTTON
          Column(
            children: [
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
                    child: Wrap(
                      children: <Widget>[
                        Row(
                          children: [
                            Radio(
                              activeColor: mainColor,
                              value: paymentOptions.Bank,
                              groupValue: _option,
                              onChanged: (paymentOptions? value) async {
                                setState(() {
                                  _option = (value == null) ? paymentOptions.Bank : value;
                                });
                              },
                            ),
                            Text(
                              'Bank Transaction',
                              style: TextStyle(
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: mainColor,
                              value: paymentOptions.Paystack,
                              groupValue: _option,
                              onChanged: null, // Disable the radio button
                            ),
                            Text(
                              'Paystack',
                              style: TextStyle(
                                fontSize: 10.0.sp,
                                color: Colors.grey, // Grayed out text color
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: mainColor,
                              value: paymentOptions.Flutterwave,
                              groupValue: _option,
                              onChanged: null, // Disable the radio button
                            ),
                            Text(
                              'Flutterwave',
                              style: TextStyle(
                                fontSize: 10.0.sp,
                                color: Colors.grey, // Grayed out text color
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                              List getDues =[];
                              for(Dues d in dues){
                                getDues.add({
                                  'due_id':d.due_id,
                                  'name':d.due,
                                  'amount':d.controller.text,
                                });
                              }
                              Map<String, dynamic> payInfo = {
                                'id':"",
                                'resident_id':(user?.id??""),
                                "date_trx": date.text,
                                "description":"",
                                "amount":amount.text,
                                "pay_mode":0,
                                "dues":getDues,
                                "attr":{},
                                'provider':{},
                                'res_id': (user?.id??""),
                                'email': (user?.email??""),
                                'name': (user?.first_name??"") + " " + (user?.last_name??""),
                                "date_created":"",
                                "_model": "PaymentForm",
                                "_list": "AccountHistory-\$limit:10,\$offset:0,\$order:date_trx desc"




                              };
                              if(amount.text !=""){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => selectPaymenthold(payInfo, _option)));
                              }else{
                                displaySnackbar(_scaffoldkey, "Amount cannot be empty.", Colors.orangeAccent);
                              }

                            },
                            child: PrimaryButton(
                              btnText: "Next",
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}





// content function
// create payment



