import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:reamapp/src/model/gatepass.dart';
import 'package:reamapp/src/model/response.dart';
import 'package:reamapp/src/model/site.dart';
import 'package:reamapp/src/model/user.dart';
import 'package:reamapp/src/service/AlertService.dart';
import 'package:reamapp/src/service/GatePassService.dart';
import 'package:reamapp/src/service/auth.dart';
import 'package:reamapp/src/service/authdata.dart';
import 'package:reamapp/src/util/helper.dart';



import 'visitordetails.dart';
import 'alert.dart';
import 'data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';

import 'loading.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  User? user;
  Site? site;

  bool loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GatePass> gatePassList = [];
  int limit = 10;
  int offset = 0;
  int gatePassCount = 0;
  int alertCount = 0;

  final token = TextEditingController();

  @override
  void initState() {
    getUser();
    getSite();
    getAlert();
  }

  getUser() async {
    User? getUser = await AuthData.getUser();
    setState(()  {
      user = getUser;
    });
    // print(getUser.attr!['address']);

  }
  getSite() async {
    Site? getSite = await AuthData.getSite();
    setState(()  {
      site = getSite;
      print(site);
    });
    initList();
    // print(getUser.attr!['address']);

  }

  Future<bool> initList() async {
    offset = 0;
    loading = true;
    List<GatePass> val = await getGatePassList();
    setState(() {
      gatePassList = val;
      loading = false;
    });
    return true;
  }

  moreLists() {
    print('lastpage ${offset}');

    if (offset > -1) {
      offset = offset + limit;

      getGatePassList(ispaginate: true).then((val) {
        if (val.isEmpty) {
          offset = -1;
        }
        setState(() {
          gatePassList.addAll(val);
          loading = false;
        });
      });
    }
  }

  Future<List<GatePass>> getGatePassList({bool ispaginate: false}) async {
    DateTime ds = DateTime.now().subtract(Duration(days: 1));
    String dateString = ds.toString().split('.')[0];
    Map<String, dynamic> param = { '_filter': ''};
    // if (ispaginate == true) {
      param['_filter'] = param['_filter'] + 'status:>0,date_created:>{$dateString},\$order:date_created desc';
    // }
    
    // date_created:>2021-10-13 23:59:59,status:>0,$order:date_created desc
    GatePassService service = GatePassService();
    Response rs = await service.gatePassList(param);
    if (rs.status == 200) {
      Map data = rs.data['store'];
      gatePassCount = data['count'];
      List? dataList = data['list'];
      if (dataList != null) {
        return List.from(dataList).map((elem) {
          return GatePass.fromJson(elem);
        }).toList();
      } else {
        return <GatePass>[];
      }
    } else {
      return <GatePass>[];
    }
  }



  List gatePassStatus(int? status){
    List statusList =[];
    switch(status){
      case 0:
        statusList = ['Unused', Colors.greenAccent];
        break;

      case 1:
        statusList = ['Checked in', Colors.grey];
        break;

      case 2:
        statusList = ['Checked out', Colors.blueAccent];
        break;

      case 3:
        statusList = ['Checked in & out', Colors.orangeAccent];
        break;

      case 4:
        statusList = ['Expired', Colors.redAccent];
        break;
      default:
        statusList = ['Unused', Colors.greenAccent];
        break;

    }
    return statusList;
  }
  getGatePass(token) async {
    setState(() {
      loading = true;
    });

    GatePassService service = GatePassService();
    Response rs = await service.getGatePassToken([token]);
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      GatePass gatePassdetail = GatePass.fromJson(data['record']);

      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              visitorsDetails(gatepass: gatePassdetail)));

    } else {
      displaySnackbar(_scaffoldKey, "Record not found", Colors.redAccent);
      // locator<NavigationService>().pop();
    }
  }

  Future<void> scanQR() async {
    try {
      FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
          .then((value) {
        List<String> splitVal = value.split(';');
        Map gatepassDetails = {};
        for(String val in splitVal){
          if(val.length > 1){
            List<String?> splitVal2 = val.split('|');
            // print(splitVal2);
            gatepassDetails[splitVal2[0]?.trim()] = splitVal2[1]?.trim()??"";

          }

        }
        getGatePass(gatepassDetails['Token']);
      });
    } catch (e) {
      displaySnackbar(_scaffoldKey, "An error occurred while reading record.", Colors.redAccent);
    }
  }
  Future<bool> getAlert() async {
    setState(() {
      loading = true;
    });

    AlertService service = AlertService();
    Response rs = await service.alertList({'status':1});
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      List? dataList = data['list'];
      setState(() {
        alertCount = dataList!.length;
      });

      }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return (loading)?Loading():
    Scaffold(key:_scaffoldKey, body: Container(
      color: Colors.green,
      child: Stack(
        children: <Widget>[
          Positioned(
            height: ScreenUtil().screenHeight - 300.h,
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
                          child: Padding(
                            padding:  EdgeInsets.all(11.0.h),
                            child: GestureDetector(
                                onTap: () async {
                                  Auth auth = Auth();
                                  await auth.Logout();
                                  AuthData.Logout();
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.logout_rounded, color: Colors.white, size: 20.sp,),
                                    Text("Logout", style: TextStyle(color: Colors.white),)
                                  ],
                                )),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(11.0.h),
                          child: notification(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child:  GestureDetector(
                          onTap: () async {
                            Auth auth = Auth();
                            await auth.Logout();
                            AuthData.Logout();
                          },
                          child: Text(
                            ((user !=null)? user!.first_name! + " "+  user!.last_name! : ''),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                            ),
                          )),
                    ),
                    Center(
                      child: Text(
                        ((site !=null)?site!.name??"":""),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Flexible(
                            child: Padding(
                              padding:  EdgeInsets.only(right: 10.0.w),
                              child: Container(
                                height: 40.h,
                                child: TextFormField(
                                  controller: token,
                                  textCapitalization: TextCapitalization.characters,
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.white
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 10),
                                      labelText: 'Gate pass token',
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
                                  if(token.text.length > 6){
                                    getGatePass(token.text);
                                  }else{
                                    displaySnackbar(_scaffoldKey, "Token length is invalid!!!", Colors.redAccent);
                                  }
                                },
                                child: PrimaryButton(
                                  btnText: "Search",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InkWell(
                      onTap: () {
                        scanQR();
                      },
                      child: PrimaryButton(
                        btnText: "QR Scanner",
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
          Positioned(
              top: 300.h,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: ScreenUtil().screenHeight - 376.h,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView( child:Padding(
                  padding: EdgeInsets.all(10.h),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().screenHeight - 283.h,
                        child: DataTable2(
                          showCheckboxColumn: false,
                          columnSpacing: 4.w,
                          horizontalMargin: 10.w,
                          minWidth: MediaQuery.of(context).size.width,
                          columns: [
                            DataColumn2(
                              label: Text('Date of Arrival', style: TextStyle(fontSize: 12.sp),),
                              size: ColumnSize.S,
                            ),
                            DataColumn2(
                              label: Text('Visitor name', style: TextStyle(fontSize: 12.sp),),
                              size: ColumnSize.M,
                            ),
                            DataColumn2(
                              label: Text('Status', style: TextStyle(fontSize: 12.sp),),
                              size: ColumnSize.S,
                            ),
                          ],
                          rows:gatePassList.map((e) {
                            int index = gatePassList.indexOf(e);
                            List status = gatePassStatus(e.status);
                            return
                              DataRow(
                                  onSelectChanged: (bool) {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            visitorsDetails(gatepass: e,)));
                                  },
                                  cells: [
                                    DataCell(
                                        Text(e.date_created!, style: TextStyle(
                                            fontSize: 11.sp))),
                                    DataCell(Text(e.visitor!,
                                        style: TextStyle(fontSize: 11.sp))),
                                    DataCell(Text(status[0],
                                        style: TextStyle(color: status[1],
                                            fontSize: 11.sp))),
                                  ]);

                          }).toList(),
                        ),
                      )
                    ],
                  ),
                )),

              )
          ),
          // Positioned(
          //   top: 210.h,
          //   left: 40.w,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Container(
          //         width: 280.w,
          //         decoration: BoxDecoration(
          //           color: Color(0xFF41756A),
          //           borderRadius: BorderRadius.circular(25.r),
          //           boxShadow: const [
          //             BoxShadow(
          //                 color: Colors.white30,
          //                 spreadRadius: 0.1,
          //                 blurRadius: 15),
          //           ],
          //         ),
          //         child: Padding(
          //           padding:  EdgeInsets.symmetric(
          //               horizontal: 20.0.h, vertical: 15.w),
          //           child: Column(
          //             children:  <Widget>[
          //               Text(
          //                 'No 22, Adanna Nkwocha street, Drive 2, 1st avenue',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(color: Colors.white, fontSize: 12.sp),
          //               ),
          //               SizedBox(
          //                 height: 8.h,
          //               ),
          //               Text(
          //                 '09025257559, 08109048411',
          //                 style: TextStyle(color: Colors.white, fontSize: 12.sp),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    ),);
  }
  Widget notification() {
    return
      Container(
        width: 40.w,
          height: 40.h,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => alerthold()));
            },
            mini: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: new Stack(
                children: <Widget>[
                  new Icon(Icons.warning_rounded, color: Colors.white, size: 35.sp,),
                  new Positioned(  // draw a red marble
                    top: 0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(13)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(alertCount.toString(), style: TextStyle(fontSize: 10.sp),),
                      ),
                    )
                  )
                ]
            ),
          )
      );
  }
}
