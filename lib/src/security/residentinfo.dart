import 'package:flutter/material.dart';
import 'data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';

class residentInfo extends StatefulWidget {
  const residentInfo({Key? key}) : super(key: key);

  @override
  _residentInfoState createState() => _residentInfoState();
}

class _residentInfoState extends State<residentInfo> {
  @override
  Widget build(BuildContext context) {
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
              child: Container(child: Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    SizedBox(
                      height: 80.h,
                    ),
                    Center(
                      child: Text(
                        "Emeka Jide",
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
                        "No 22, Adanna Nkwocha street, Drive 2, 1st avenue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "09025257559, 08109048411",
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
                                padding: EdgeInsets.only(left:10.0.w, top: 10.0.h),
                                child: Text('History' , style: TextStyle(color: mainColor, fontSize:16.sp, fontWeight: FontWeight.w400),),
                              ),
                              DataTable2(
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
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(
                                        Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                                    DataCell(Text('Opeyemi Popoola',
                                        style: TextStyle(fontSize: 11.sp))),
                                    DataCell(Text('Not yet arrived',
                                        style: TextStyle(fontSize: 11.sp))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                        Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                                    DataCell(Text('Opeyemi Popoola',
                                        style: TextStyle(fontSize: 11.sp))),
                                    DataCell(Text('Checked out',
                                        style: TextStyle( fontSize: 11.sp))),
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
