import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
// import 'package:flutterwave/core/flutterwave.dart';
// import 'package:flutterwave/models/responses/charge_response.dart';
// import 'package:flutterwave/utils/flutterwave_constants.dart';
// import 'package:flutterwave/utils/flutterwave_currency.dart';
import '../model/dues.dart';
import '../model/paymentOptions.dart';
import '../model/response.dart';
import '../model/user.dart';
import '../residence/loading.dart';
import '../routes.dart';
import '../security/createpayment.dart';
import '../service/AccountService.dart';
import '../service/authdata.dart';
import '../service/locatorService.dart';
import '../service/navigationService.dart';
import '../util/helper.dart';
import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'noticeboard.dart';

class selectPaymenthold extends StatefulWidget {
  Map<String, dynamic> payInfo;
  paymentOptions _option;
  selectPaymenthold(this.payInfo, this._option, {Key? key}) : super(key: key);

  @override
  _selectPaymentholdState createState() => _selectPaymentholdState();
}

class _selectPaymentholdState extends State<selectPaymenthold> {
  int selectedIndex = 0;
  bool loading = false;
  User? user;
  final date = TextEditingController();
  final bankName = TextEditingController();
  final tellerNumber = TextEditingController();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  List<Dues> dues = [];

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  String publicKey = '';
  String encryptionKey = '';
  final paystackPlugin = PaystackPlugin();
  String txref = "Flutterwave_";
  String amount = '0';
  // final String currency = FlutterwaveCurrency.NGN;

  @override
  void initState() {
    amount = widget.payInfo['amount'];
    getUser().then((savedUser) {
      setState(() {
        user = savedUser;
      });
      getDues();
    });
    initPayment();
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

  getUser() {
    return AuthData.getUser();
  }

  getPaystackKey() async {
    setState(() {
      loading = true;
    });

    AccountService service = AccountService();
    Response rs = await service.paystackKey();
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      publicKey = data['public_key'];
      // publicKey = "pk_test_4f379241e6b21392538e63bc6888ddd96945aa3e";
      paystackPlugin.initialize(publicKey: publicKey);
    } else {
      displaySnackbar(_scaffoldkey,
          "An error occurred while initiating payment.", Colors.redAccent);
    }
  }

  getflutterwaveKey() async {
    setState(() {
      loading = true;
    });

    AccountService service = AccountService();
    Response rs = await service.flutterwaveKey();
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      publicKey = data['public_key'];
      encryptionKey = data['encryption_key'];
    } else {
      displaySnackbar(_scaffoldkey,
          "An error occurred while initiating payment.", Colors.redAccent);
    }
  }

  initPayment() {
    if (widget._option == paymentOptions.Flutterwave) {
      getflutterwaveKey();
      txref += getRandomString(10);
      print('flutterwave');
    } else if (widget._option == paymentOptions.Paystack) {
      getPaystackKey();
      print('paystack');
    } else {
      date.text = DateTime.now().toString();
      print('bank transfer');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: (loading)
          ? Loading()
          : SingleChildScrollView(
              child: Container(
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
                              image: DecorationImage(
                                  image: AssetImage("assets/images/bck.png"),
                                  fit: BoxFit.cover),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 10.w, top: 30.h),
                                      child: arrow(),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 10.w, top: 30.h),
                                      child: notification(),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Accounts",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          payStatus(widget._option)[1],
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
                                children: <Widget>[
                                  // PUT CONTENT FUNCTION HERE
                                  selectPayment(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),

                // navigation Menu
                // Container(child: Navigation(),)
              ],
            ))),
    );
  }

  Widget arrow() {
    return Container(
        child: FloatingActionButton(
      heroTag: 'arrowTag',
      onPressed: () {
        Navigator.pop(context);
      },
      mini: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 30,
      ),
    ));
  }

  Widget notification() {
    return Container(
        child: FloatingActionButton(
      heroTag: 'notificationTag',
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Notificationhold()));
      },
      mini: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Icon(
        Icons.notification_important_rounded,
        color: Colors.white,
        size: 30,
      ),
    ));
  }

  Widget selectPayment(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0.w),
                            child: Container(
                              height: 40.h,
                              child: TextFormField(
                                readOnly: true,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                                initialValue: widget.payInfo['date_trx'] ??
                                    DateTime.now().toString(),
                                decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 10),
                                    labelText: 'Date',
                                    labelStyle: TextStyle(
                                      color: Colors.black45,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
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
                                readOnly: true,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                                initialValue: '₦' + widget.payInfo['amount'],
                                decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 10),
                                    labelText: 'Amount paid',
                                    labelStyle: TextStyle(
                                      color: Colors.black45,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
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

                // PAYMENT OPTION

                (widget._option == paymentOptions.Bank)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0.w, vertical: 10.h),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 5.0.w),
                                        child: Container(
                                          height: 35.h,
                                          child: TextFormField(
                                            readOnly: true,
                                            style: TextStyle(fontSize: 12.sp),
                                            controller: date,
                                            onTap: () {
                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  onChanged: (date) {
                                                print('change $date');
                                              }, onConfirm: (date) {
                                                print('confirm $date');
                                                this.date.text =
                                                    date.toLocal().toString();
                                              },
                                                  currentTime:
                                                      DateTime.parse(date.text),
                                                  locale: LocaleType.en);
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    new EdgeInsets.symmetric(
                                                        horizontal: 13.w,
                                                        vertical: 10.h),
                                                labelText: 'Date',
                                                labelStyle: TextStyle(
                                                  color: Colors.black45,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11.r),
                                                  borderSide: BorderSide(
                                                    color: Colors.black26,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11.r),
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
                                        padding: EdgeInsets.only(
                                          left: 5.0.w,
                                        ),
                                        child: Container(
                                          height: 35.h,
                                          child: TextFormField(
                                            controller: bankName,
                                            style: TextStyle(fontSize: 12.sp),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    new EdgeInsets.symmetric(
                                                        horizontal: 13.w,
                                                        vertical: 10.h),
                                                labelText: 'Bank name',
                                                labelStyle: TextStyle(
                                                  color: Colors.black45,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11.r),
                                                  borderSide: BorderSide(
                                                    color: Colors.black26,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11.r),
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
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0.h),
                                  child: Container(
                                    height: 50,
                                    child: Container(
                                      height: 35.h,
                                      child: TextFormField(
                                        controller: tellerNumber,
                                        style: TextStyle(fontSize: 12.sp),
                                        decoration: InputDecoration(
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    horizontal: 13.w,
                                                    vertical: 10.h),
                                            labelText: 'Teller number',
                                            labelStyle: TextStyle(
                                              color: Colors.black45,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11.r),
                                              borderSide: BorderSide(
                                                color: Colors.black26,
                                                width: 1.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11.r),
                                              borderSide: BorderSide(
                                                color: Colors.black38,
                                                width: 1.0,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: () async {
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
                                      "amount":widget.payInfo['amount'],
                                      "pay_mode":0,
                                      "dues":getDues,
                                      "attr":{
                                        "bank_name":bankName.text,
                                        "teller_number":tellerNumber.text,
                                        "date":date.text,
                                      },
                                      'provider':{},
                                      'res_id': (user?.id??""),
                                      'email': (user?.email??""),
                                      'name': (user?.first_name??"") + " " + (user?.last_name??""),
                                      "date_created":"",
                                      "_model": "PaymentForm",
                                      "_list": "AccountHistory-\$limit:10,\$offset:0,\$order:date_trx desc"
                                    };
                                    if(tellerNumber.text !="" && bankName.text !="" && date.text !="" ) {
                                      setState(() {
                                        loading = true;
                                      });
                                      print(payInfo);

                                      AccountService accountService = AccountService();
                                      Response rs;
                                      rs = await accountService.PaymentFormSubmit(payInfo);
                                      
                                      setState(() {
                                        loading = false;
                                      });
                                      if (rs.status == 200) {
                                        displaySnackbar(
                                            _scaffoldkey, "Payment successful.",
                                            Colors.greenAccent);
                                        Navigator.pop(context, true);
                                      } else {
                                        displaySnackbar(_scaffoldkey,
                                            "An Error Occured",
                                            Colors.orangeAccent);
                                      }
                                    }else {
                                      displaySnackbar(_scaffoldkey,
                                          "Teller number and Bankname cannot be empty.",
                                          Colors.orangeAccent);
                                    }
                                  },
                                  child: PrimaryButton(
                                    btnText: "Submit",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),

                SizedBox(
                  height: 10,
                ),
              ],
            ),
            // ACCUMULATED AMOUNT

            // ACTION BUTTON
            // Column(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 18.0.w),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Flexible(
            //             child: Padding(
            //               padding: EdgeInsets.only(right: 10.0.w),
            //               child: Container(
            //                 child: GestureDetector(
            //                   onTap: () {
            //                     Navigator.pop(context);
            //                   },
            //                   child: OutlineBtn(
            //                     btnText: "Cancel",
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Flexible(
            //             child: Padding(
            //               padding: EdgeInsets.only(left: 10.0.w),
            //               child: Container(
            //                 child: GestureDetector(
            //                   onTap: () async {
            //                     switch (widget._option) {
            //                       case paymentOptions.Bank:
            //                         if(tellerNumber.text =="" || bankName.text == ""){
            //                           displaySnackbar(_scaffoldkey, "Fill bank fields to proceed.", Colors.orangeAccent);
            //                           return;
            //                         }
            //                         Map attr = {
            //                           "teller_no": tellerNumber.text,
            //                           "bank_name": bankName.text,
            //                           "date": date.text,
            //                         };
            //                         Map provider = {
            //                           "value": 2,
            //                           "name": "Bank Transaction",
            //                         };
            //
            //                         Map<String, dynamic> payInfo =
            //                             widget.payInfo;
            //                         payInfo['pay_mode'] = 2;
            //                         payInfo['attr'] = attr;
            //                         payInfo['provider'] = provider;
            //                         print(payInfo);
            //                         sendPayment(payInfo);
            //
            //                         break;
            //
            //                       case paymentOptions.Flutterwave:
            //                         ChargeResponse? response = await beginPayment(context, user);
            //
            //                         if (response == null) {
            //                           // user didn't complete the transaction.
            //
            //                           print("User did not complete transaction");
            //                           displaySnackbar(_scaffoldkey, "User did not complete transaction.", Colors.orangeAccent);
            //                         } else {
            //                           final isSuccessful = checkPaymentIsSuccessful(response);
            //                           if (isSuccessful) {
            //                             // provide value to customer
            //                             print("payment comolete");
            //                             Map attr = {
            //                               "provider_id": 3,
            //                               "transaction_id": response.data?.id,
            //                               "reference_id": response.data?.txRef,
            //                             };
            //                             Map provider = {
            //                               "value": 3,
            //                               "name": "Flutterwave",
            //                             };
            //
            //                             Map<String, dynamic> payInfo = widget.payInfo;
            //                             payInfo['attr'] = attr;
            //                             payInfo['provider'] = provider;
            //                             payInfo['pay_mode'] = 3;
            //                             print(payInfo);
            //                             sendPayment(payInfo);
            //                           } else {
            //                             // check message
            //                             print(response.message);
            //                             displaySnackbar(_scaffoldkey, response.message, Colors.orangeAccent);
            //                             // check status
            //                             print(response.status);
            //
            //                             // check processor error
            //                             print(response.data!.processorResponse);
            //                           }
            //                         }
            //
            //                         break;
            //
            //                       case paymentOptions.Paystack:
            //                         dynamic response = await paystackPayment(
            //                             context, amount, user!.email);
            //                         if (response != null) {
            //                           print(response);
            //                           CheckoutResponse resp = response;
            //                           print(resp);
            //                           if (resp.status) {
            //                             var reference = resp.reference;
            //                             print(reference);
            //                             print('transaction complete');
            //                             Map attr = {
            //                               "provider_id": 1,
            //                               "transaction_id": "",
            //                               "reference_id": reference,
            //                             };
            //                             Map provider = {
            //                               "value": 1,
            //                               "name": "Paystack",
            //                             };
            //                             Map<String, dynamic> payInfo = widget.payInfo;
            //                             payInfo['attr'] = attr;
            //                             payInfo['provider'] = provider;
            //                             payInfo['pay_mode'] = 1;
            //                             // callCompleteDialog(context, 'Failed!',
            //                             //     subtext: rs.message, onClose: () {
            //                             //       Navigator.pop(context);
            //                             //     });
            //                             sendPayment(payInfo);
            //                           } else {
            //                             displaySnackbar(_scaffoldkey,
            //                                 response.message, Colors.orange);
            //                           }
            //                         }
            //                         break;
            //                     }
            //                   },
            //                   child: PrimaryButton(
            //                     btnText: "Pay",
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
  sendPayment(Map<String, dynamic> payInfo) async {
    setState(() {
      loading = true;
    });
    AccountService service = AccountService();
    Response rs =
        await service.makePayment(payInfo);
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data;
      print(data);
      callCompleteDialog(context, 'Success!',
          subtext: payStatus(widget._option)[1]+" has been recorded successfully.", onClose: () {

            startTime(1, ()=>locator<NavigationService>().pushNamedAndRemoveUntil(ACCOUNTPAGE));
          });
    }else{
      displaySnackbar(_scaffoldkey, "An error occurred when making payment.", Colors.orangeAccent);
    }
  }

  List payStatus(paymentOptions option) {
    switch (option) {
      case paymentOptions.Paystack:
        return [1, 'Paystack Payment'];
      case paymentOptions.Flutterwave:
        return [3, 'Flutterwave Payment'];
      case paymentOptions.Bank:
        return [3, 'Bank Payment'];
    }
  }

  paystackPayment(context, amount, email) async {
    // int amount = (amount + vat.toInt()) * 100 ;
    setState(() {
      loading = true;
    });
    Map<String, dynamic> initDetails = {'amount': amount, 'email': email};
    AccountService service = AccountService();
    Response rs = await service.initPaystack(initDetails);
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data;
      var accessCode = data['store']['access_code'];
      var reference = data['store']['reference'];
//      print(data);
      Charge charge = Charge()
        ..amount = int.parse(amount) * 100
        ..reference = reference
        ..accessCode = accessCode
        ..email = email;
      CheckoutResponse response = await paystackPlugin.checkout(
        context,
        method:
            CheckoutMethod.selectable, // Defaults to CheckoutMethod.selectable
        charge: charge,
      );
      return response;
    } else if (rs.status == 401) {
      displaySnackbar(_scaffoldkey, rs.data[0], Colors.orange);
      return null;
    } else {
      displaySnackbar(_scaffoldkey, rs.message, Colors.orange);
      return null;
    }
  }

  // Future<ChargeResponse?> beginPayment(BuildContext context, User? user) async {
  //   final Flutterwave flutterwave = Flutterwave.forUIPayment(
  //       context: this.context,
  //       // encryptionKey: "FLWSECK_TEST1cb69897c831",
  //       encryptionKey: encryptionKey,
  //       // publicKey: 'FLWPUBK_TEST-71ba22b53b92d5ca28127ca637c3975c-X',
  //       publicKey: publicKey,
  //       // publicKey: publicKey,
  //       currency: currency,
  //       amount: amount,
  //       email: user!.email!,
  //       fullName: user.first_name! + " " + user.last_name!,
  //       txRef: txref,
  //       isDebugMode: true,
  //       phoneNumber: user.phone!,
  //       acceptCardPayment: true,
  //       acceptUSSDPayment: true,
  //       acceptAccountPayment: true,
  //       acceptFrancophoneMobileMoney: false,
  //       acceptGhanaPayment: false,
  //       acceptMpesaPayment: false,
  //       acceptRwandaMoneyPayment: true,
  //       acceptUgandaPayment: false,
  //       acceptZambiaPayment: false);
  //
  //   try {
  //     final ChargeResponse response =
  //         await flutterwave.initializeForUiPayments();
  //     return response;
  //
  //   } catch (error, stacktrace) {
  //     // handleError(error);
  //
  //     print("An error occurred");
  //     return null;
  //   }
  // }
  //
  // bool checkPaymentIsSuccessful(final ChargeResponse response) {
  //   return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
  //       response.data!.currency == currency &&
  //       response.data!.amount == amount &&
  //       response.data!.txRef == txref;
  // }
}
