import 'package:flutter/material.dart';
import '../model/notice.dart';
import '../model/response.dart';
import '../residence/loading.dart';
import '../residence/noticeboardsingle.dart';
import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';

import 'mainpage.dart';
import 'navigation.dart';

import '../service/NoticeService.dart';



class Notificationhold extends StatefulWidget {
  const Notificationhold({Key? key}) : super(key: key);

  @override
  _NotificationholdState createState() => _NotificationholdState();
}

class _NotificationholdState extends State<Notificationhold> {
  int selectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List<Notice> noticeList = [];
  int limit = 10;
  int offset = 0;
  int noticeCount = 0;
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
    List<Notice> val = await getNoticeList();
    setState(() {
      noticeList = val;
      loading = false;
    });
    return true;
  }

  moreLists() {
    print('lastpage ${offset}');

    if (offset > -1) {
      offset = offset + limit;

      getNoticeList(ispaginate: true).then((val) {
        if (val.isEmpty) {
          offset = -1;
        }
        setState(() {
          noticeList.addAll(val);
          loading = false;
        });
      });
    }
  }

  Future<List<Notice>> getNoticeList({bool ispaginate: false}) async {
    Map<String, dynamic> param = { '_filter': ''};
    if (ispaginate == true) {
      param['_filter'] = param['_filter'] + '\$limit:$limit,\$offset:$offset';
    }
    print(param);
    NoticeService service = NoticeService();
    Response rs = await service.noticeList(param);
    if (rs.status == 200) {
      Map data = rs.data['store'];
      noticeCount = data['count'];
      List? dataList = data['list'];
      if (dataList != null) {
        return List.from(dataList).map((elem) {
          return Notice.fromJson(elem);
        }).toList();
      } else {
        return <Notice>[];
      }
    } else {
      return <Notice>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      body: (loading)? Loading():RefreshIndicator(
          child: SingleChildScrollView( physics: AlwaysScrollableScrollPhysics(),
        child:  Container(
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
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h)
                                  ),
                                ],
                              ),
                              Container(
                                child:  Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Notice Board",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.sp,
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
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
                                notificationlist(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),


              // navigation Menu
              // Container(child: Navigation(),)
            ],
          )
      ),) , onRefresh: initList)
    );
  }
  Widget arrow() {
    return
      Container(
          child: FloatingActionButton(heroTag: 'arrowheroTag',
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
  Widget notificationlist(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child:
      NotificationListener<ScrollNotification>(
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
                    label: Text('Subject', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Read', style: TextStyle(fontSize: 12.sp),),
                    size: ColumnSize.S,
                  ),
                ],
                rows: noticeList.map((Notice row) => DataRow(cells: [
                  DataCell(
                      Text(row.date_created!, style: TextStyle(fontSize: 11.sp))),
                  DataCell(Text (row.title!,
                      maxLines: 1,style: TextStyle(fontSize: 11.sp))),
                  DataCell(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 8.r,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => NotificationSinglehold(row.id)));
                          },
                          child: Icon(Icons.remove_red_eye_sharp,
                            color: Colors.green,
                            size: 14.0.sp,
                            semanticLabel: 'Read',
                          ),
                        ),
                        SizedBox(width: 8.r,),
                      ],
                    ),
                  ),
                ])).toList()
                
                // [
                //   DataRow(cells: [
                //     DataCell(
                //         Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                //     DataCell(Text ('The issue of water in the estate as been a major concern for the past two weeks',
                //         maxLines: 1,style: TextStyle(fontSize: 11.sp))),
                //     DataCell(
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           SizedBox(width: 8.r,),
                //           GestureDetector(
                //             onTap: () {
                //               Navigator.push(context,
                //                   MaterialPageRoute(builder: (context) => NotificationSinglehold()));
                //             },
                //             child: Icon(Icons.remove_red_eye_sharp,
                //               color: Colors.green,
                //               size: 14.0.sp,
                //               semanticLabel: 'Read',
                //             ),
                //           ),
                //           SizedBox(width: 8.r,),
                //         ],
                //       ),
                //     ),
                //   ]),
                // ],
              ),
            )
          ],
        ),)

    );
  }
}





