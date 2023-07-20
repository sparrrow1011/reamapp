import 'package:flutter/material.dart';
import '../model/resident.dart';
import '../model/user.dart';
import '../model/visitorsList.dart';
import '../residence/creategatepass.dart';
import '../residence/loading.dart';
import '../service/ResidentService.dart';
import '../service/VisitorService.dart';
import '../service/authdata.dart';
import '../util/helper.dart';
import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';
import '../residence/createresident.dart';
import '../model/response.dart' as resp;

import '../../data.dart';
import 'navigation.dart';
import 'noticeboard.dart';

class Residentshold extends StatefulWidget {
  const Residentshold({Key? key}) : super(key: key);

  @override
  _ResidentsholdState createState() => _ResidentsholdState();
}

class _ResidentsholdState extends State<Residentshold> {
  int selectedIndex = 0;
  User? user;
  Resident? primaryResident;
  List<Resident> residentList = [];
  bool loading = true;
  int limit = 10;
  int offset = 0;

  ScrollController _controller = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // _controller.addListener(() {
    //   // if (_controller.position.pixels > 20 && !_showScrollUp) {
    //   //   setState(() {
    //   //     _showScrollUp = true;
    //   //   });
    //   // } else if (_controller.position.pixels < 20 && _showScrollUp) {
    //   //   setState(() {
    //   //     _showScrollUp = false;
    //   //   });
    //   // }
    //   // On GitHub there was a question on how to determine the event
    //   // of widget being scrolled to the bottom. Here's the sample
    //   if (_controller.position.hasViewportDimension &&
    //       _controller.position.pixels >=
    //           _controller.position.maxScrollExtent - 0.01 && offset > -1) {
    //     print('Scrolled to bottom');
    //   }
    // });
    getUser().then((savedUser) {
      setState(() {
        user = savedUser;
      });
      initList();
    });
  }

  getUser() {
    return AuthData.getUser();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  Future<bool> initList() async {
    offset = 0;
    loading = true;
    List<Resident> val = await getResidentList();
    setState(() {
      residentList = val;
      loading = false;
    });
    return true;
  }

  moreLists() {
    print('lastpage ${offset}');

    if (offset > -1) {
      offset = offset + limit;

      getResidentList(ispaginate: true).then((val) {
        if (val.isEmpty) {
          offset = -1;
        }
        setState(() {
          residentList.addAll(val);
          loading = false;
        });
      });
    }
  }

  Future<List<Resident>> getResidentList({bool ispaginate: false}) async {
    String? userId = user?.id;
    String _list = "ResidentFamilyList-primary_id:$userId";
    Map<String, dynamic> param = {'_list': _list, '_filter': ''};
    if (ispaginate == true) {
      param['_filter'] = param['_filter'] + '\$limit:$limit,\$offset:$offset';
    }
    print(param);
    ResidentService service = ResidentService();
    resp.Response rs = await service.residentList(param, [user?.id]);
    if (rs.status == 200) {
      Map data = rs.data['store'];
      List? dataList = data['ResidentFamilyList'];
      if (primaryResident == null) {
        setState(() {
          primaryResident = Resident.fromJson(data['record']);
        });
      }
      if (dataList != null) {
        return List.from(dataList).map((elem) {
          return Resident.fromJson(elem);
        }).toList();
      } else {
        return <Resident>[];
      }
    } else {
      return <Resident>[];
    }
  }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: loading
          ? Loading()
          : RefreshIndicator(
              child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
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
                                    image: DecorationImage(
                                        image:
                                            AssetImage("assets/images/bck.png"),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 10.w, top: 30.h),
                                            // child: arrow(),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 10.w, top: 30.h),
                                            child: notification(context),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Residents",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7.h,
                                              ),
                                              // Padding(
                                              //   padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                                              //   child: Text(
                                              //     "gate pass",
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //       color: Colors.white,
                                              //       fontSize: 13.sp,
                                              //     ),
                                              //   ),
                                              // ),
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
                                      children: <Widget>[
                                        // PUT CONTENT FUNCTION HERE
                                        Residents(context, _scaffoldKey,
                                            residentList),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),

                      // navigation Menu
                      Container(
                        child: Navigation(selectedIndex: 4, onClicked: onClicked,),
                      )
                    ],
                  ))),
              onRefresh: initList,
            ),
    );
  }

  Widget Residents(
      BuildContext context, final _scaffold_key, List<Resident> residentsList) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!loading &&
              scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            moreLists();
          }
          return false;
        },
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 30.h,
                          child: (primaryResident != null)
                              ? FloatingActionButton.extended(
                                  heroTag: "Create_Resident_Hero_Tag",
                                  elevation: 0,
                                  extendedPadding: EdgeInsets.symmetric(
                                      horizontal: 20.h, vertical: 10.h),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                createResidenthold(
                                                    primaryResident))).then((value) => setState(() { }));
                                  },
                                  label: Text(
                                    "Add Resident",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  backgroundColor: mainColor,
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: ScreenUtil().screenHeight - 323.h,
                    child: DataTable2(
                        columnSpacing: 4.w,
                        horizontalMargin: 10.w,
                        minWidth: MediaQuery.of(context).size.width,
                        showCheckboxColumn: false,
                        scrollController: _controller,
                        columns: [
                          DataColumn2(
                            label: Text(
                              'Name',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Text(
                              'Phone',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Text(
                              'Action',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            size: ColumnSize.S,
                          ),
                        ],
                        rows: residentsList.map((row) {
                          int index = residentsList.indexOf(row);
                          return DataRow(onSelectChanged: (selected){
                            if(selected == true){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          createResidenthold(
                                            primaryResident, editId: row.id, isEdit: true,))).then((value) => setState(() { }));
                            }
                          },cells: [
                            DataCell(Text(row.name!,
                                style: TextStyle(fontSize: 11.sp))),
                            DataCell(Text(row.phone!,
                                style: TextStyle(fontSize: 11.sp))),
                            DataCell(
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  createResidenthold(
                                                      primaryResident, editId: row.id, isEdit: true,))).then((value) => setState(() { }));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                      size: 14.0.sp,
                                      semanticLabel: 'Edit',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.r,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              alertDialog(context, "Delete Resident", "Are you sure you want to delete this resident?",  () async {
                                            Navigator.pop(context, 'Yes');
                                            String? primaryId = primaryResident!.id;
                                            Map<String, dynamic> formInfo = {
                                              '_list': "ResidentFamilyList-\$limit:10,\$offset:0,primary_id:$primaryId,\$order:name",
                                            };
                                            setState(() {
                                              loading = true;
                                            });
                                            ResidentService service = ResidentService();
                                            resp.Response rs = await service.deleteResident(formInfo, [row.id]);

                                            setState(() {
                                              loading = false;
                                            });
                                            if(rs.status == 200){
                                              setState(() {
                                                residentList.removeAt(index);
                                              });

                                              displaySnackbar(_scaffold_key, "Resident removal successful.",
                                                  Colors.greenAccent);
                                            }else{
                                              displaySnackbar(_scaffold_key, "An error occurred while deleting resident.",
                                                  Colors.orangeAccent);
                                            }


                                          }, () => Navigator.pop(context, 'No')));
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 14.0.sp,
                                      semanticLabel: 'Delete',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList()
                        // [
                        //
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Opeyemi Popoola',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        //   DataRow(cells: [
                        //     DataCell(Text('Mathew segun',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(Text('0902567876',
                        //         style: TextStyle(fontSize: 11.sp))),
                        //     DataCell(
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           GestureDetector(
                        //             // onTap: () {
                        //             //   Navigator.push(context,
                        //             //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                        //             // },
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: Colors.green,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Edit',
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8.r,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Icon(
                        //               Icons.delete,
                        //               color: Colors.red,
                        //               size: 14.0.sp,
                        //               semanticLabel: 'Delete',
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        // ],
                        ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notification(BuildContext context) {
    return Container(
        child: FloatingActionButton(
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
}

// arrow
class arrow extends StatelessWidget {
  const arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FloatingActionButton(
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

// notification

// content function
