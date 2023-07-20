import 'package:flutter/material.dart';
import 'package:reamapp/data.dart';
import 'package:reamapp/src/model/gatepass.dart';
import 'package:reamapp/src/model/response.dart';
import 'package:reamapp/src/security/loading.dart';
import 'package:reamapp/src/service/GatePassService.dart';
import 'package:reamapp/src/util/helper.dart';

import 'navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class visitorsDetails extends StatefulWidget {
  GatePass gatepass;
   visitorsDetails({Key? key, required this.gatepass}) : super(key: key);

  @override
  _visitorsDetailsState createState() => _visitorsDetailsState();
}

class _visitorsDetailsState extends State<visitorsDetails> {
  int selectedIndex = 0;
  List history = [];

  bool loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  postGatePass(int status) async {
    setState(() {
      loading = true;
    });
    Map gt = widget.gatepass.toJson();
    gt['type'] = 3;
    gt['status'] = status;
    print(gt);
    GatePassService service = GatePassService();
    Response rs = await service.getGatePassStatus(gt, [widget.gatepass.id]);
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      // Map data = rs.data['store'];
      // GatePass gatePassdetail = GatePass.fromJson(data['record']);
      setState(() {
        widget.gatepass.status = status;
      });
      displaySnackbar(_scaffoldKey, "Status updated successfully.", Colors.greenAccent);
    } else {
      displaySnackbar(_scaffoldKey, "Record not found", Colors.redAccent);
      // locator<NavigationService>().pop();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    history = (widget.gatepass.attr!['history'] == null)?[]:widget.gatepass.attr!['history'];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: (loading)? Loading():Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: ScreenUtil().screenHeight,
                child: Container(
                  color: Colors.white,
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
                          child: Container(child: Padding(
                            padding: EdgeInsets.all(20.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                      child: arrow(context),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Center(
                                  child: Text(
                                    "Visitors Details ",
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),

                                // start

                              ],
                            ),
                          )),
                        ),
                      ),
                      Positioned(
                          top: 140.h,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: ScreenUtil().screenHeight - 350.h,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.0.w, right: 25.w),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Visitor's name: ",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          (widget.gatepass.visitor != null &&  widget.gatepass.visitor != "")?widget.gatepass.visitor:((widget.gatepass.attr!['visitor'] != null)?widget.gatepass.attr!['visitor']:""),
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Resident's name: ",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          widget.gatepass.resident??"",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Car plate number: ",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          widget.gatepass.plate_number??"",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Date of arrival: ",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          widget.gatepass.date_created??"",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      children: [
                                        // Container(
                                        //   child: Flexible(
                                        //     child: Padding(
                                        //       padding: EdgeInsets.only(left: 25.w, right: 25.w),
                                        //       child: TextFormField(
                                        //         textCapitalization: TextCapitalization.characters,
                                        //         style: TextStyle(
                                        //             fontSize: 12.sp, color: Colors.white
                                        //         ),
                                        //         decoration: InputDecoration(
                                        //             contentPadding: new EdgeInsets.symmetric(
                                        //                 horizontal: 13, vertical: 10),
                                        //             labelText: 'Check in time',
                                        //             labelStyle: TextStyle(
                                        //               color: Colors.black45,
                                        //             ),
                                        //             floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        //             enabledBorder: OutlineInputBorder(
                                        //               borderRadius: BorderRadius.circular(13),
                                        //               borderSide: BorderSide(
                                        //                 color: Colors.black38,
                                        //                 width: 1.0,
                                        //               ),
                                        //             ),
                                        //             focusedBorder: OutlineInputBorder(
                                        //               borderRadius: BorderRadius.circular(13),
                                        //               borderSide: BorderSide(
                                        //                 color: Colors.black38,
                                        //                 width: 1.0,
                                        //               ),
                                        //             )),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        Container(
                                          child: Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 0.w, right: 0.w),
                                              child: TextFormField(
                                                initialValue: widget.gatepass.token??"",
                                                enabled: false,
                                                textCapitalization: TextCapitalization.characters,
                                                style: TextStyle(
                                                    fontSize: 17.sp, color: Colors.black
                                                ),
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(
                                                        horizontal: 13, vertical: 10),
                                                    labelText: 'Gate Pass Token',
                                                    labelStyle: TextStyle(
                                                      color: Colors.black45,
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(13),
                                                      borderSide: BorderSide(
                                                        color: Colors.black38,
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
                                      height: 30.h,
                                    ),
                                    Row(
                                      children: history.map((e){
                                        return Container(
                                          child: Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                              child: TextFormField(
                                                initialValue:  e['time'],
                                                enabled: false,
                                                textCapitalization: TextCapitalization.characters,
                                                style: TextStyle(
                                                    fontSize: 12.sp, color: Colors.black
                                                ),
                                                decoration: InputDecoration(
                                                    contentPadding: new EdgeInsets.symmetric(
                                                        horizontal: 13, vertical: 10),
                                                    labelText: e['status'],
                                                    labelStyle: TextStyle(
                                                      color: Colors.black45,
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(13),
                                                      borderSide: BorderSide(
                                                        color: Colors.black38,
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
                                        );
                                      }).toList()
                                     //  [
                                     //    Container(
                                     //      child: Flexible(
                                     //        child: Padding(
                                     //          padding: EdgeInsets.only(left: 25.w, right: 25.w),
                                     //          child: TextFormField(
                                     //            textCapitalization: TextCapitalization.characters,
                                     //            style: TextStyle(
                                     //                fontSize: 12.sp, color: Colors.white
                                     //            ),
                                     //            decoration: InputDecoration(
                                     //                contentPadding: new EdgeInsets.symmetric(
                                     //                    horizontal: 13, vertical: 10),
                                     //                labelText: 'Check in time',
                                     //                labelStyle: TextStyle(
                                     //                  color: Colors.black45,
                                     //                ),
                                     //                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                     //                enabledBorder: OutlineInputBorder(
                                     //                  borderRadius: BorderRadius.circular(13),
                                     //                  borderSide: BorderSide(
                                     //                    color: Colors.black38,
                                     //                    width: 1.0,
                                     //                  ),
                                     //                ),
                                     //                focusedBorder: OutlineInputBorder(
                                     //                  borderRadius: BorderRadius.circular(13),
                                     //                  borderSide: BorderSide(
                                     //                    color: Colors.black38,
                                     //                    width: 1.0,
                                     //                  ),
                                     //                )),
                                     //          ),
                                     //        ),
                                     //      ),
                                     //    ),
                                     // Container(
                                     //      child: Flexible(
                                     //        child: Padding(
                                     //          padding: EdgeInsets.only(left: 25.w, right: 25.w),
                                     //          child: TextFormField(
                                     //            textCapitalization: TextCapitalization.characters,
                                     //            style: TextStyle(
                                     //                fontSize: 12.sp, color: Colors.white
                                     //            ),
                                     //            decoration: InputDecoration(
                                     //                contentPadding: new EdgeInsets.symmetric(
                                     //                    horizontal: 13, vertical: 10),
                                     //                labelText: 'Check in time',
                                     //                labelStyle: TextStyle(
                                     //                  color: Colors.black45,
                                     //                ),
                                     //                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                     //                enabledBorder: OutlineInputBorder(
                                     //                  borderRadius: BorderRadius.circular(13),
                                     //                  borderSide: BorderSide(
                                     //                    color: Colors.black38,
                                     //                    width: 1.0,
                                     //                  ),
                                     //                ),
                                     //                focusedBorder: OutlineInputBorder(
                                     //                  borderRadius: BorderRadius.circular(13),
                                     //                  borderSide: BorderSide(
                                     //                    color: Colors.black38,
                                     //                    width: 1.0,
                                     //                  ),
                                     //                )),
                                     //          ),
                                     //        ),
                                     //      ),
                                     //    ),
                                     //
                                     //  ],
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                          child: Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 20.0.w),
                                              child: InkWell(
                                                onTap: () {
                                                  if(widget.gatepass.status != null && widget.gatepass.status == 0){
                                                      postGatePass(1);
                                                  }
                                                },
                                                child: (widget.gatepass.status != null && widget.gatepass.status == 0)?OutlineBtn(
                                                  btnText: "Check in",
                                                ):OutlineBtn2("Check in"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 20.0.w),
                                              child: InkWell(
                                                onTap: () {
                                                  if(widget.gatepass.status != null && widget.gatepass.status! < 2 && widget.gatepass.status! > 0){
                                                    postGatePass(3);
                                                  }
                                                },
                                                child: (widget.gatepass.status != null && widget.gatepass.status! < 2)?PrimaryButtonRed(
                                                  btnText: "Check out",
                                                ):PrimaryButton2("Check out"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
              // navigation
            ],
          )
      ),
    );
  }
  Widget arrow(BuildContext context) {
    return Container(
        child: FloatingActionButton(
          heroTag: 'arrowHeroTag',
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
}
