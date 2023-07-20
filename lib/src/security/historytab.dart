import 'package:flutter/material.dart';
import 'data.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(historyTab());

class historyTab extends StatelessWidget {
  const historyTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Active',
      'Checked in',
      'Checked Out',
      'Expired',
    ];

    
    return SingleChildScrollView(
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: TabBar(
                labelColor: mainColor,
                unselectedLabelColor: Colors.black45,
                indicatorColor: mainColor,
                isScrollable: true,
                labelStyle: TextStyle(fontSize: 14.sp),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12.sp,
                ),
                tabs: [
                  for (final tab in tabs) Tab(text: tab),
                ],
              ),
            ),
            Container(
              height: ScreenUtil().screenHeight - 273.h,
              child: TabBarView(
                children: [
                  Container(
                    child: active(),
                  ),
                  Container(
                    child: checkedin(),
                  ),
                  Container(
                    child: checkedout(),
                  ),
                  Container(
                    child: expired(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


// active
class active extends StatefulWidget {
  const active({Key? key}) : super(key: key);

  @override
  _activeState createState() => _activeState();
}

class _activeState extends State<active> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
                        label: Text('Date of Arrival', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text("Visitor's name", style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text('Action', style: TextStyle(fontSize: 12.sp),),
                        size: ColumnSize.S,
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                            Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                        DataCell(Text('Opeyemi Popoola',
                            style: TextStyle(fontSize: 11.sp))),
                        DataCell(
                          GestureDetector(
                            // onTap: () {
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                            // },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('Check in', style: TextStyle(color: Colors.white, fontSize: 10.sp),),
                              ),
                            )
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                            Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                        DataCell(Text('Opeyemi Popoola',
                            style: TextStyle(fontSize: 11.sp))),
                        DataCell(
                          GestureDetector(
                            // onTap: () {
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                            // },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('Check in', style: TextStyle(color: Colors.white, fontSize: 10.sp),),
                                ),
                              )
                          ),
                        ),
                      ]),
                    ],
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


// checked in
class checkedin extends StatefulWidget {
  const checkedin({Key? key}) : super(key: key);

  @override
  _checkedinState createState() => _checkedinState();
}

class _checkedinState extends State<checkedin> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  label: Text('Date of Arrival', style: TextStyle(fontSize: 12.sp),),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text("Visitor's name", style: TextStyle(fontSize: 12.sp),),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text('Action', style: TextStyle(fontSize: 12.sp),),
                  size: ColumnSize.S,
                ),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(
                      Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                  DataCell(Text('Opeyemi Popoola',
                      style: TextStyle(fontSize: 11.sp))),
                  DataCell(
                    GestureDetector(
                      // onTap: () {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                      // },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Check out', style: TextStyle(color: Colors.white, fontSize: 10.sp),),
                          ),
                        )
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                      Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                  DataCell(Text('Opeyemi Popoola',
                      style: TextStyle(fontSize: 11.sp))),
                  DataCell(
                    GestureDetector(
                      // onTap: () {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => editgatepassDetailshold(firstname: firstname, lastname: lastname, vehicleplate: vehicleplate)));
                      // },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Check out', style: TextStyle(color: Colors.white, fontSize: 10.sp),),
                          ),
                        )
                    ),
                  ),
                ]),
              ],
            ),
          )
        ],
      ),
      height: ScreenUtil().screenHeight,
    );
  }
}


// checked out
class checkedout extends StatefulWidget {
  const checkedout({Key? key}) : super(key: key);

  @override
  _checkedoutState createState() => _checkedoutState();
}

class _checkedoutState extends State<checkedout> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  label: Text('Date of Arrival', style: TextStyle(fontSize: 12.sp),),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text("Visitor's name", style: TextStyle(fontSize: 12.sp),),
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
                  DataCell(
                      Text('Checked out',
                          style: TextStyle(fontSize: 11.sp))
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                      Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                  DataCell(Text('Opeyemi Popoola',
                      style: TextStyle(fontSize: 11.sp))),
                  DataCell(
                      Text('Checked out',
                          style: TextStyle(fontSize: 11.sp))
                  ),
                ]),
              ],
            ),
          )
        ],
      ),
      height: MediaQuery.of(context).size.height,
    );
  }
}



// expired
class expired extends StatefulWidget {
  const expired({Key? key}) : super(key: key);

  @override
  _expiredState createState() => _expiredState();
}

class _expiredState extends State<expired> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  label: Text('Date of Arrival', style: TextStyle(fontSize: 12.sp),),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text("Visitor's name", style: TextStyle(fontSize: 12.sp),),
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
                  DataCell(
                      Text('Expired',
                          style: TextStyle(fontSize: 11.sp))
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                      Text('22-12-2021', style: TextStyle(fontSize: 11.sp))),
                  DataCell(Text('Opeyemi Popoola',
                      style: TextStyle(fontSize: 11.sp))),
                  DataCell(
                      Text('Expired',
                          style: TextStyle(fontSize: 11.sp))
                  ),
                ]),
              ],
            ),
          )
        ],
      ),
      height: MediaQuery.of(context).size.height,
    );
  }
}

