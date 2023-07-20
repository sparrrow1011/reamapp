import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:reamapp/data.dart';
import 'package:reamapp/src/model/resident.dart';
import 'package:reamapp/src/model/response.dart';
import 'package:reamapp/src/residence/loading.dart';
import 'package:reamapp/src/security/residentsingle.dart';
import 'package:reamapp/src/service/SresidentService.dart';
import 'package:reamapp/src/util/helper.dart';


import 'navigation.dart';



class Residentshold extends StatefulWidget {
  const Residentshold({Key? key}) : super(key: key);

  @override
  _ResidentsholdState createState() => _ResidentsholdState();
}

class _ResidentsholdState extends State<Residentshold> {
  int selectedIndex = 3;
  List<Resident> residentList = [];
  bool loading = true;
  int limit = 10;
  int offset = 0;
  int residentCount = 0;
  final search = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {

    initList();
  }
  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  Future<bool> refreshList() async {
    search.clear();
   initList();
    return true;
  }
  Future<bool> initList() async {
    offset = 0;
    loading = true;
    List<Resident> val = await residentsList();
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

      residentsList(ispaginate: true).then((val) {
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

  Future<List<Resident>> residentsList({bool ispaginate: false}) async {
    Map<String, dynamic> param = { '_filter': ''};
    if(search.text.length > 0){
      param['_filter'] = param['_filter'] + 'name:%'+search.text.toString() +'%,';
    }
    if (ispaginate == true) {
      param['_filter'] = param['_filter'] + '\$limit:$limit,\$offset:$offset';
    }
    print(param);
    SresidentService service = SresidentService();
    Response rs = await service.residentList(param);
    if (rs.status == 200) {
      Map data = rs.data['store'];
      residentCount = data['count'];
      List? dataList = data['list'];
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
      body:  loading
          ? Loading()
          :RefreshIndicator(
    child: SingleChildScrollView( physics: const AlwaysScrollableScrollPhysics(),
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
                              SizedBox(height: 54.h,),
                              Container(
                                child:  Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Residents",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.sp,
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
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
                                                    controller: search,
                                                    // textCapitalization: TextCapitalization.characters,
                                                    style: TextStyle(
                                                        fontSize: 14.sp, color: Colors.white
                                                    ),
                                                    decoration: InputDecoration(
                                                        contentPadding: new EdgeInsets.symmetric(
                                                            horizontal: 13, vertical: 10),
                                                        labelText: 'Filter',
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
                                                    if(search.text.length > 3){
                                                      initList();
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
                                        height: 7.h,
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
                        top: 140.h,
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
                                Residents(context),
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
      )), onRefresh: refreshList),
    );
  }
  Widget Residents(BuildContext context) {
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
          Container(
            child: Column(
              children: [
                Container(
                  height: ScreenUtil().screenHeight - 323.h,
                  child: DataTable2(
                    columnSpacing: 4.w,
                    horizontalMargin: 10.w,
                    minWidth: MediaQuery.of(context).size.width,
                    columns: [
                      DataColumn2(
                        label: Text('Name', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Phone', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text('Status', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                    ],
                    rows:
                    residentList.map((row) {
      int index = residentList.indexOf(row);
      return DataRow(cells: [
        DataCell(
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => singleResident(resident: row,)));
                },
                child: Text(row.name??"", style: TextStyle(fontSize: 11.sp)))),
        DataCell(
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => singleResident(resident: row)));
                },
                child: Text((row.phone??"") + '\n'+(row.unit??"") , style: TextStyle(fontSize: 11.sp, color: Colors.black)))),

        DataCell(
            Text((row.in_debt == true)?'In-Debt':'Paid', style: TextStyle(fontSize: 11.sp, color: Colors.red))
        ),
      ]);
    }).toList()
                  ),
                )
              ],
            ),
          ),
        ],
      ))),

    );
  }
}



