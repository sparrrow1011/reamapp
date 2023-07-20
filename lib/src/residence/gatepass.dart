import 'package:flutter/material.dart';
import '../model/gatepass.dart';
import '../model/response.dart';
import '../residence/creategatepass.dart';
import '../residence/gatepassdetails.dart';
import '../residence/loading.dart';
import '../service/GatePassService.dart';
import '../util/helper.dart';
import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';

import 'mainpage.dart';
import 'navigation.dart';
import 'noticeboard.dart';



class gatePasshold extends StatefulWidget {
  const gatePasshold({Key? key}) : super(key: key);

  @override
  _gatePassholdState createState() => _gatePassholdState();
}

class _gatePassholdState extends State<gatePasshold> {
  int selectedIndex = 0;
  bool loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GatePass> gatePassList = [];
  int limit = 10;
  int offset = 0;
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
    if (ispaginate == true) {
      param['_filter'] = param['_filter'] + '\$limit:$limit,\$offset:$offset';
    }
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                    // child: arrow(),
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
              Container(child: Navigation(selectedIndex: 3,onClicked: onClicked))
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
            Padding(
              padding: EdgeInsets.only(top: 20.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30.h,
                    child: FloatingActionButton.extended( heroTag: "createGatePassHeroTag",
                      elevation: 0,
                      extendedPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => createGatepasshold())
                        );
                      },
                      label: Text("Create gate pass", style: TextStyle(fontSize: 12.sp),),
                      backgroundColor: mainColor,
                    ),
                  ),

                ],
              ),
            ),
            Container(
              height: ScreenUtil().screenHeight - 283.h,
              child: DataTable2(
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
                  ),
                  DataColumn2(
                    label: Text('Action', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.S,
                  ),
                ],
                rows: gatePassList.map((e) {
                  int index = gatePassList.indexOf(e);
                  List status = gatePassStatus(e.status);
                  return DataRow(cells: [
                    DataCell(
                        Text(e.date_created!, style: TextStyle(fontSize: 11.sp))),
                    DataCell(Text(e.visitor!,
                        style: TextStyle(fontSize: 11.sp))),
                    DataCell(Text(status[0],
                        style: TextStyle(color: status[1], fontSize: 11.sp))),
                    DataCell(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => gatepassDetailshold(
                                      {
                                        'id':e.id,
                                        'token':e.token
                                            })));
                            },
                            child: Icon(Icons.remove_red_eye,
                              color: Colors.green,
                              size: 14.0.sp,
                              semanticLabel: 'View',
                            ),
                          ),
                          SizedBox(width: 8.r,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => createGatepasshold(isEdit: true, editId: e.id,))
                              );
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                            },
                            child: Icon(Icons.edit,
                              color: Colors.green,
                              size: 14.0.sp,
                              semanticLabel: 'Edit',
                            ),
                          ),
                          SizedBox(width: 8.r,),
                          GestureDetector(
                            onTap: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      alertDialog(context, "Delete Gate Pass", "Are you sure you want to delete this gate pass?",  () async {
                                        Navigator.pop(context, 'Yes');
                                        Map<String, dynamic> formInfo = {
                                          '_list': "GatePassList-\$limit:10,\$offset:0,\$order:date_created desc",
                                        };
                                        setState(() {
                                          loading = true;
                                        });
                                        GatePassService service = GatePassService();
                                        Response rs = await service.deleteGatePass(formInfo, [e.id]);

                                        setState(() {
                                          loading = false;
                                        });
                                        if(rs.status == 200){
                                          setState(() {
                                            gatePassList.removeAt(index);
                                          });

                                          displaySnackbar(_scaffoldKey, "Gate pass removal successful.",
                                              Colors.greenAccent);
                                        }else{
                                          displaySnackbar(_scaffoldKey, "An error occurred while deleting gate pass.",
                                              Colors.orangeAccent);
                                        }


                                      }, () => Navigator.pop(context, 'No')));
                            },
                            child: Icon(Icons.delete,
                              color: Colors.red,
                              size: 14.0.sp,
                              semanticLabel: 'Delete',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);}).toList(),
              ),
            )
          ],
        ),))
    );
  }
}







