import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reamapp/src/model/gatepass.dart';
import 'package:reamapp/src/model/response.dart';
import 'package:reamapp/src/service/GatePassService.dart';
import '/data.dart';
import 'loading.dart';
import 'visitordetails.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';
import 'navigation.dart';
import 'noticeboard.dart';



class gatePasshold extends StatefulWidget {
  const gatePasshold({Key? key}) : super(key: key);

  @override
  _gatePassholdState createState() => _gatePassholdState();
}

class _gatePassholdState extends State<gatePasshold> {
  int selectedIndex = 1;
  bool loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GatePass> gatePassList = [];
  int limit = 2;
  int offset = 0;
  int status = -1;
  int gatePassCount = 0;

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initList();
  }

  Future<bool> initList() async {
    offset = 0;
    setState(() {
      status = -1;
    });

    loading = true;
    List<GatePass> val = await getGatePassList();
    setState(() {
      gatePassList = val;
      loading = false;
    });
    return true;
  }
  statusCheck() async {

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
    Map<String, dynamic> param = { '_filter': ''};
    if(status > -1){
      param['_filter'] = param['_filter'] + 'status:$status,\$order:date_created desc';
    }
    else{
      param['_filter'] = param['_filter'] + 'status:>0,\$order:date_created desc';
    }
    // if (ispaginate == true) {
    //   param['_filter'] = param['_filter'] + ', \$limit:$limit,\$offset:$offset';
    // }
    print(param);


    // status:>0,date_created:>2021-10-01 00:00:00,date_created:<2021-10-31 23:59:59,$order:date_created desc
    print(param);
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      body:(loading)?Loading():
    RefreshIndicator(
        child:
        SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
        child:
        Container(
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
                              SizedBox(height: 50.h ) ,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                    // child: arrow(),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                    child: Container(),
                                  ),
                                ],
                              ),
                              Container(
                                child:  Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "History ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.sp,
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                                        child: Text(
                                          "gate pass",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                          ),
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
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              children:  <Widget>[
                                // PUT CONTENT FUNCTION HERE
                                gatepass(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),


              // navigation Menu
              Container(child: Navigation(selectedIndex: selectedIndex, onClicked: onClicked))
            ],
          )
      ),
    ), onRefresh: initList)
    );
  }


  Widget notification() {
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

  Widget gatepass(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,

      child: SingleChildScrollView(child:NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!loading &&
              scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            moreLists();
          }
          return false;
        },
        child:Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: 20.0.h),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Container(
            //         height: 30.h,
            //         child: ,
            //       ),
            //
            //     ],
            //   ),
            // ),


            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     SizedBox(width: 20.w,),
            //     PrimaryButton(btnText: "hello"),
            //     DropdownButton(items: const [
            //       DropdownMenuItem(
            //         child: SizedBox(
            //           width: double.infinity,
            //           child: Text(
            //             "All",
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //         value: -1,
            //       ),
            //       DropdownMenuItem(
            //         child: SizedBox(
            //           width: double.infinity,
            //           child: Text(
            //             "Active",
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //         value: 0,
            //       ),
            //       DropdownMenuItem(
            //         child: SizedBox(
            //           width: double.infinity,
            //           child: Text(
            //             "Checked in",
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //         value: 1,
            //       ),
            //       DropdownMenuItem(
            //         child: SizedBox(
            //           width: double.infinity,
            //           child: Text(
            //             "Checked out",
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //         value: 2,
            //       ),
            //       // DropdownMenuItem(
            //       //   child: SizedBox(
            //       //     width: double.infinity,
            //       //     child: Text(
            //       //       "Checked in & out",
            //       //       textAlign: TextAlign.center,
            //       //     ),
            //       //   ),
            //       //   value: 3,
            //       // ),
            //       DropdownMenuItem(
            //         child: SizedBox(
            //           width: double.infinity,
            //           child: Text(
            //             "Expired",
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //         value: 4,
            //       )
            //     ],)
            //   ],
            // ),
            Padding(
              padding: EdgeInsets.only(left: 200.0.w),
              child: DropdownButtonHideUnderline(
                child: Container(
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                    child: DropdownButton<dynamic>(
                      icon: Icon(Icons.arrow_drop_down_circle, size: 15.h, color: Colors.white,),
                      dropdownColor: mainColor,
                      borderRadius: BorderRadius.circular(20),
                      style: TextStyle(
                        color: Colors.white, fontSize: 13.sp,  decorationColor: Colors.white
                      ),
                      items: const [
                        DropdownMenuItem(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "All",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w800,),
                            ),
                          ),
                          value: -1,
                        ),
                        DropdownMenuItem(
                          child: SizedBox(
                            width: double.infinity,
                            height: 10,
                            child:  Divider(
                              color: Colors.white38,
                              thickness: 2,
                            ),
                          ),
                        ),
                        // DropdownMenuItem(
                        //   child: Padding(
                        //     padding: EdgeInsets.all(8.0),
                        //     child: Text(
                        //       "Active",
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        //   value: 0,
                        // ),
                        DropdownMenuItem(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Checked in",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Checked out",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          value: 2,
                        ),
                        // DropdownMenuItem(
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     child: Text(
                        //       "Checked in & out",
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        //   value: 3,
                        // ),
                        DropdownMenuItem(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Expired",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          value: 4,
                        )
                      ],
                      value: status,

                      onChanged: (value) {
                        setState(() {
                          status = int.parse(value.toString());
                        });
                        statusCheck();
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: ScreenUtil().screenHeight - 283.h,
              child: DataTable2(
                showCheckboxColumn: false,
                columnSpacing: 4.w,
                horizontalMargin: 10.w,
                minWidth: MediaQuery.of(context).size.width,
                columns: [
                  DataColumn2(
                    label: Text('Date issued', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Visitor name', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Status', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.S,
                  )
                ],
                rows: gatePassList.map((e) {
                  int index = gatePassList.indexOf(e);
                  List status = gatePassStatus(e.status);
                  return DataRow(onSelectChanged: (bool) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            visitorsDetails(gatepass: e,)));
                  },cells: [
                    DataCell(
                        Text(e.date_created!, style: TextStyle(fontSize: 11.sp))),
                    DataCell(Text(e.visitor!,
                        style: TextStyle(fontSize: 11.sp))),
                    DataCell(
                      GestureDetector(
                        // onTap: () {
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        // },
                          child: Container(
                            decoration: BoxDecoration(
                                color: status[1],
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(status[0], style: TextStyle(color: Colors.white, fontSize: 10.sp),),
                            ),
                          )
                      ),
                    )
                  ]);}).toList(),
              ),
            )
          ],
        ),))
    );
  }
}







