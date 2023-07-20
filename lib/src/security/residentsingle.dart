import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '/data.dart';
import '../model/gatepass.dart';
import '../model/resident.dart';
import '../model/response.dart';
import '../security/residentinfo.dart';
import '../service/GatePassService.dart';
import 'navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class singleResident extends StatefulWidget {
  Resident resident;
  singleResident({Key? key, required this.resident}) : super(key: key);

  @override
  _singleResidentState createState() => _singleResidentState();
}

class _singleResidentState extends State<singleResident> {
  int selectedIndex = 3;

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

  List gatePassStatus(int? status) {
    List statusList = [];
    switch (status) {
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
    Map<String, dynamic> param = {'_filter': ''};
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
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: ScreenUtil().screenHeight - 76.h,
            child: residentInfo(),
          ),
          // navigation
          Container(
            child: Navigation(
              selectedIndex: selectedIndex,
              onClicked: onClicked,
            ),
          )
        ],
      )),
    );
  }

  Widget residentInfo() {
    return Container(
      color: Colors.green,
      child: Stack(
        children: <Widget>[
          Positioned(
            height: ScreenUtil().screenHeight - 370.h,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bck.png"),
                    fit: BoxFit.cover),
              ),
              child: Container(
                  child: Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80.h,
                    ),
                    Center(
                      child: Text(
                        widget.resident.name ?? "",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Text(
                        widget.resident.unit ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.resident.phone ?? "",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              )),
            ),
          ),
          Positioned(
              top: 230.h,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: ScreenUtil().screenHeight - 305.h,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (!loading &&
                            scrollInfo is ScrollEndNotification &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          moreLists();
                        }
                        return false;
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: ScreenUtil().screenHeight - 283.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0.w, top: 10.0.h),
                                    child: Text(
                                      'History',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  DataTable2(
                                    columnSpacing: 4.w,
                                    horizontalMargin: 10.w,
                                    minWidth: MediaQuery.of(context).size.width,
                                    columns: [
                                      DataColumn2(
                                        label: Text(
                                          'Date issued',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        size: ColumnSize.S,
                                      ),
                                      DataColumn2(
                                        label: Text(
                                          'Visitor name',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        size: ColumnSize.M,
                                      ),
                                      DataColumn2(
                                        label: Text(
                                          'Status',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        size: ColumnSize.S,
                                      ),
                                    ],
                                    rows: gatePassList.map((e) {
                                      int index = gatePassList.indexOf(e);
                                      List status = gatePassStatus(e.status);
                                      return DataRow(cells: [
                                        DataCell(Text(e.date_created ?? "",
                                            style: TextStyle(fontSize: 11.sp))),
                                        DataCell(Text(e.visitor ?? "",
                                            style: TextStyle(fontSize: 11.sp))),
                                        DataCell(Text(status[0],
                                            style: TextStyle(fontSize: 11.sp, color: status[1]))),
                                      ]);
                                    }).toList(),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              )),
        ],
      ),
    );
  }
}
