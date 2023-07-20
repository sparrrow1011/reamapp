import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '/data.dart';
import '../model/Pending.dart';
import '../model/payment.dart';
import '../model/response.dart';
import '../model/status.dart';
import '../model/user.dart';
import '../residence/createpayment.dart';
import '../residence/loading.dart';
import '../service/AccountService.dart';
import '../service/authdata.dart';
import 'accounttab.dart';
import 'navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'noticeboard.dart';

class accounthold extends StatefulWidget {
  const accounthold({Key? key}) : super(key: key);

  @override
  _accountholdState createState() => _accountholdState();
}

class TabProp{
String tabName = "";
Function TabWidget;
Function getFuc = (){};
int offset =0;
List list = [];

TabProp(this.tabName, this.TabWidget, this.getFuc);
}
class _accountholdState extends State<accounthold> {

  int selectedIndex = 1;
  int tabIndex = 0;
  bool loading = false;
  List<TabProp> tabS = [];
  List statusList = [];
  List paymentList = [];
  List pendingList = [];
  Status? statusRecord;
  User? user;
  int limit = 10;
  int offset = 0;
  String test = 'Testing it';

  @override
  void didChangeDependencies() {
    // tabS.add({
    //   'tabName': 'Status',
    //   'Tab': (context){ return status(context);},
    //   'getFuc': ({ispaginate: false}){ return getStatusList(ispaginate: ispaginate);},
    //   'list': (List<Status> list){
    //     setState(() {
    //       // statusList = list;
    //       // if(statusList != null){
    //       //   print(statusList.length);
    //       // }
    //     });
    //   },
    //   'offset': 0,
    // });
    // tabS.add({
    //   'tabName': 'Payment',
    //   'Tab': (context){ return payment(context);},
    //   'getFuc': (){},
    //   'list': (List<Status> list){},
    //   'offset': 0,
    // });
    // tabS.add({
    //   'tabName': 'Payment Pending',
    //   'Tab': (context){ return pending(context);},
    //   'getFuc': (){},
    //   'list': (List<Status> list){},
    //   'offset': 0,
    // });
  }

  setTabs(){
    tabS.add(TabProp("Status", status,  getStatusList));
    tabS.add(TabProp("Payment", payment,  getPaymentList));
    tabS.add(TabProp("Payment Pending", pending,  getPendingList));
  }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setTabs();
    getUser().then((savedUser) {
      setState(() {
        user = savedUser;
      });
      initAllLists();
    });
  }
  initAllLists() async {
    setState(() {
      loading = true;
    });

    for(int i = 0; i < tabS.length; i++ ){
      await initList(i);
    }
    setState(() {
      loading = false;
    });

  }


   initList(int i) async {
    tabS[i].offset = 0;
    List val = await tabS[i].getFuc(ispaginate: true);
    setState(() {
      tabS[i].list = val;
    });
  }

  Future<bool> refreshList() async {
      initList(tabIndex);
    return true;
  }

  getUser() {
    return AuthData.getUser();
  }

  moreLists(int i) {
    // print('lastpage ${offset}');

    if (offset > -1) {
      offset = offset + limit;

      getStatusList(ispaginate: true).then((val) {
        if (val.isEmpty) {
          offset = -1;
        }
        setState(() {
          tabS[i].list.addAll(val);
          loading = false;
        });
      });
    }
  }

  Future<List<Status>> getStatusList({bool ispaginate: false}) async {
    Map<String, dynamic> param = { '_filter': ''};
    String? userId = user?.id;
    // if (ispaginate == true) {
      // param['_filter'] = param['_filter'] + '\$limit:$limit,\$offset:$offset'
      param['_list'] = 'InvoiceList-\$order:year desc\$month desc|ResidentDueStatus-id:$userId,\$order:due';
    // }
    // print(param);
    AccountService service = AccountService();
    Response rs = await service.statusList(param, [user?.id]);
    if (rs.status == 200) {
      Map data = rs.data['store'];
      setState(() {
        statusRecord = Status.fromJson(data['record']);
      });
      List? dataList = data['ResidentDueStatus'];
      if (dataList != null) {
        List<Status> ls =  List.from(dataList).map((elem) {
          return Status.fromJson(elem);
        }).toList();
        return ls;
      } else {
        return <Status>[];
      }
    } else {
      return <Status>[];
    }
  }
  Future<List<Payment>> getPaymentList({bool ispaginate: false}) async {
    Map<String, dynamic> param = { '_filter': ''};
    String? userId = user?.id;
    if (ispaginate == true) {
      param['_filter'] = param['_filter'] + '\$limit:999999,\$offset:0,\$order:date_trx desc';
    }
    param['_list'] = 'UnitType';
    // print(param);
    AccountService service = AccountService();
    Response rs = await service.paymentList(param);
    if (rs.status == 200) {
      Map data = rs.data['store'];
      List? dataList = data['list'];
      if (dataList != null) {
        List<Payment> pm =  List.from(dataList).map((elem) {
          return Payment.fromJson(elem);
        }).toList();
        return pm;
      } else {
        return <Payment>[];
      }
    } else {
      return <Payment>[];
    }
  }
  Future<List<Pending>> getPendingList({bool ispaginate: false}) async {
    Map<String, dynamic> param = { '_filter': ''};
    String? userId = user?.id;
    if (ispaginate == true) {
      param['_filter'] = param['_filter'] + '\$limit:10,\$offset:0,\$order:date_trx desc';
    }
    param['_list'] = 'ResidentList-type:1';
    // print(param);
    AccountService service = AccountService();
    Response rs = await service.pendingList(param);
    if (rs.status == 200) {
      Map data = rs.data['store'];
      List? dataList = data['list'];
      if (dataList != null) {
        List<Pending> pm =  List.from(dataList).map((elem) {
          return Pending.fromJson(elem);
        }).toList();
        return pm;
      } else {
        return <Pending>[];
      }
    } else {
      return <Pending>[];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loading)?Loading():RefreshIndicator(
          child: SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(),
          child:Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              // page main content container
              Container(
                height: ScreenUtil().screenHeight - 76.h,
                child: account(context),
              ),

              // navigation Menu
              Container(child: Navigation(selectedIndex:selectedIndex , onClicked: onClicked,),)
            ],
          )
      )), onRefresh: refreshList),
    );
  }
  Widget notification() {
    return
      Container(
          child: FloatingActionButton(heroTag: "notificationTag",
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
  Widget account(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          height: 180.h,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
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
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10.w, top: 30.h),
                      child: notification(),
                    ),
                  ],
                ),
                Container(
                  child:  Center(
                    child: Text(
                      "Accounts",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                      ),
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
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  accountTab(context),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget accountTab(BuildContext context) {



    return SingleChildScrollView(
      child: DefaultTabController(
        length: tabS.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: TabBar(onTap: (int i){
         setState(() {
           tabIndex = i;
         });

              },
                labelColor: mainColor,
                unselectedLabelColor: Colors.black45,
                indicatorColor: mainColor,
                isScrollable: true,
                labelStyle: TextStyle(fontSize: 17.sp),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                ),
                tabs: [
                  for (final tab in tabS) Tab(text: tab.tabName),
                ],
              ),
            ),
            Container(
              height: ScreenUtil().screenHeight - 273.h,
              child: TabBarView(
                children: [
                  for (final tab in tabS)
                     Container(
                    child: tab.TabWidget(context, tab.list)
                     ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget status(BuildContext context, List list) {
    return Container(
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
                      Container(
                        height: 30.h,
                        child: FloatingActionButton.extended(
                          elevation: 0,
                          extendedPadding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => createPaymenthold(statusRecord!))
                            );
                          },
                          label: Text("Add new Payment", style: TextStyle(fontSize: 12.sp),),
                          backgroundColor: mainColor,
                        ),
                      ),
                      if ((statusRecord != null) && int.tryParse(statusRecord!.balance!)! > -1) Text(
                        "Paid"+test,
                        style: TextStyle(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                      ) else Text(
                        "Indebt",
                        style: TextStyle(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().screenHeight - 323.h,
                  child: DataTable2(
                    columnSpacing: 4.w,
                    horizontalMargin: 10.w,
                    minWidth: MediaQuery.of(context).size.width,
                    columns: [
                      DataColumn2(
                        label: Text('Due', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text('Billed', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Paid', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Balance', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                    ],
                    rows: list.cast<Status>().map((rw) {
                      // print(rw);
                      return DataRow(cells: [
                        DataCell(Text(rw.due!,
                            style: TextStyle(fontSize: 12.sp))),
                        DataCell(
                            Text('₦ '+rw.invoices!, style: TextStyle(fontSize: 12.sp))),
                        DataCell(
                            Text('₦ '+rw.payments!, style: TextStyle(fontSize: 12.sp))),
                        DataCell(Text(
                          '(₦ '+rw.balance! + ')',
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        )),
                      ]);
                    }).toList(),

                  )
                )
              ],
            ),
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height,
    );
  }
  Widget payment(BuildContext context, List list) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 30.h,
                        child: FloatingActionButton.extended(
                          elevation: 0,
                          extendedPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => createPaymenthold(statusRecord!))
                            );
                          },
                          icon: Icon(Icons.payments, size: 15.h,),
                          label: Text("Add Payment", style: TextStyle(fontSize: 12.sp),),
                          backgroundColor: mainColor,
                        ),
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
                    columns: [
                      DataColumn2(
                        label: Text('Date', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Reference ID', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Type', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Amount', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                    ],
                    rows: list.cast<Payment>().map((rw) {
                      // print(rw);
                      return DataRow(cells: [
                        DataCell(
                            Text(rw.date_trx??"", style: TextStyle(fontSize: 11.sp))),
                        DataCell(Text(rw.invoice_number??"",
                            style: TextStyle(fontSize: 11.sp))),
                        DataCell(Text('Invoice',
                            style: TextStyle( fontSize: 11.sp))),
                        DataCell(Text(
                          '₦ '+  (rw.balance ?? ""),
                          style: TextStyle( fontSize: 11.sp, color: Colors.red),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      height: ScreenUtil().screenHeight,
    );
  }
  Widget pending(BuildContext context, List list) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(height: 10.h,),
                Container(
                  height: ScreenUtil().screenHeight - 283.h,
                  child: DataTable2(
                    columnSpacing: 4.w,
                    horizontalMargin: 10.w,
                    minWidth: MediaQuery.of(context).size.width,
                    columns: [
                      DataColumn2(
                        label: Text('Date', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Resident', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text('Amount', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                    ],
                    rows: list.cast<Pending>().map((rw) {
                      // print(rw);
                      return DataRow(cells: [
                      DataCell(
                      Text(rw.date_trx??"", style: TextStyle(fontSize: 11.sp))),
                      DataCell(Text(rw.resident_name??"",
                      style: TextStyle(fontSize: 11.sp))),
                      DataCell(Text(
                      '₦ '+(rw.amount??""),
                      style: TextStyle(color: Colors.red, fontSize: 11.sp),
                      )),
                      ]);
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height,
    );
  }
}









