import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/resident.dart';
import '../model/response.dart';
import '../residence/gatepassdetails.dart';
import '../residence/loading.dart';
import '../residence/residents.dart';
import '../service/ResidentService.dart';
import '../service/locatorService.dart';
import '../service/navigationService.dart';
import '../util/helper.dart';
import '../util/validator.dart';
import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barcode_widget/barcode_widget.dart';

import 'navigation.dart';
import 'noticeboard.dart';



class createResidenthold extends StatefulWidget {
  Resident? primaryResident;
  bool isEdit = false;
  String? editId = "";
  
   createResidenthold(this.primaryResident, {Key? key, this.isEdit: false, this.editId: ""}) : super(key: key);

  @override
  _createResidentholdState createState() => _createResidentholdState();
}

class _createResidentholdState extends State<createResidenthold> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  bool isEdit = false;
  String? editId = "";
  Resident? editResident;
  bool loading = false;
  final title = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isEdit = widget.isEdit;
    this.editId = widget.editId;
    // print(widget.primaryResident!.name);
    if(isEdit){
      getResident();
    }

  }
  getResident() async {
    setState(() {
      loading = true;
    });

    ResidentService service = ResidentService();
    Response rs = await service.getResident([editId]);
    setState(() {
      loading = false
      ;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      editResident = Resident.fromJson(data['record']);
      if(editResident!=null){
        String titleString =editResident?.attr!['title'];
        title.text = titleString;
        firstName.text = ((editResident?.first_name !=null) ? editResident?.first_name : "")!;
        lastName.text = ((editResident?.last_name !=null) ? editResident?.last_name : "")!;
        email.text = ((editResident?.email !=null) ? editResident?.email : "")!;
        phone.text = ((editResident?.phone !=null) ? editResident?.phone : "")!;
        password.text = ((editResident?.phone !=null) ? editResident?.phone : "")!;
      }

    }else{
      displaySnackbar(_scaffoldkey, "Record not found", Colors.redAccent);
      locator<NavigationService>().pop();
    }
  }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( key: _scaffoldkey,
      body: (loading)?Loading():SingleChildScrollView(
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
                                        "Resident",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.sp,
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
                                      Text(
                                        (isEdit)?"Edit resident":"Create resident",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
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
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children:  <Widget>[
                                // PUT CONTENT FUNCTION HERE
                                createResident(context),
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
      ),)
    );
  }
  Widget createResident(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18.w, vertical: 8.h),
                child: TextFormField(
                  controller: title,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          horizontal: 13, vertical: 10),
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: Colors.black45,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18.w, vertical: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Flexible(
                        child: Padding(
                          padding:  EdgeInsets.only(right: 10.0.w),
                          child: Container(
                            height: 40.h,
                            child: TextFormField(controller: firstName,
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 10),
                                  labelText: 'First name',
                                  labelStyle: TextStyle(
                                    color: Colors.black45,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: BorderSide(
                                      color: Colors.black38,
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
                          padding: EdgeInsets.only(left: 10.0.w),
                          child: Container(
                            height: 40.h,
                            child: TextFormField(
                              controller: lastName,
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 10),
                                  labelText: 'Last name',
                                  labelStyle: TextStyle(
                                    color: Colors.black45,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: BorderSide(
                                      color: Colors.black38,
                                      width: 1.0,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18.w, vertical: 8.h),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phone,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          horizontal: 13, vertical: 10),
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                        color: Colors.black45,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18.w, vertical: 8.h),
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          horizontal: 13, vertical: 10),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.black45,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18.w, vertical: 8.h),
                child: TextFormField(
                  controller: password,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          horizontal: 13, vertical: 10),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.black45,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18.w, vertical: 10.h),
                child: InkWell(
                  onTap: () async {
                    List isEmpty = Validator.isEmpty(email.text);
                    List NotEmail = Validator.notEmail(email.text);
                    if (isEmpty[0]) {
                      displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                          Colors.orange);
                      return;
                    }
                    if (NotEmail[0]) {
                      displaySnackbar(_scaffoldkey,
                          NotEmail[1].toString(), Colors.orange);
                      return;
                    }


                    isEmpty = Validator.isEmpty(title.text);
                    if (isEmpty[0]) {
                      displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                          Colors.orange);
                      return;
                    }
                    isEmpty = Validator.isEmpty(firstName.text);
                    if (isEmpty[0]) {
                      displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                          Colors.orange);
                      return;
                    }
                    isEmpty = Validator.isEmpty(lastName.text);
                    if (isEmpty[0]) {
                      displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                          Colors.orange);
                      return;
                    }
                    isEmpty = Validator.isEmpty(phone.text);
                    if (isEmpty[0]) {
                      displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                          Colors.orange);
                      return;
                    }
                    isEmpty = Validator.isEmpty(password.text);
                    if (isEmpty[0]) {
                      displaySnackbar(_scaffoldkey, isEmpty[1].toString(),
                          Colors.orange);
                      return;
                    }
                    List notNumber = Validator.notNumber(phone.text);
                    if (notNumber[0]) {
                      displaySnackbar(_scaffoldkey, notNumber[1].toString(),
                          Colors.orange);
                      return;
                    }
                    String? primaryId = widget.primaryResident!.id;
                    DateTime ds = DateTime.now();
                    Map<String, dynamic> attr = {'title': title.text};
                    Map<String, dynamic> formInfo = {
                      'can_login': true,
                      'date_start': ds.year.toString()+'-'+ds.month.toString()+'-'+ds.day.toString(),
                      'date_exit': '',
                      'email': email.text,
                      'first_name': firstName.text,
                      'id': (isEdit)?editId:'',
                      'last_name': lastName.text,
                      'name': '',
                      'password': password.text,
                      'phone': phone.text,
                      'primary_id': widget.primaryResident!.id,
                      'site_id': (isEdit)?editResident!.site_id:'',
                      'status': (isEdit)?1:0,
                      'type': 2,
                      'unit': (isEdit)?editResident!.unit:'',
                      'unit_id':widget.primaryResident!.unit_id,
                      'unit_type':'',
                      '_list': "ResidentFamilyList-\$limit:10,\$offset:0,primary_id:$primaryId,\$order:name",
                      '_model':'Resident',
                      'attr':attr
                    };
                    if(isEdit == false){
                      formInfo['mode'] = 'create';
                    }

                    setState(() {
                      loading = true;
                    });
                    Response rs;
                    ResidentService service = ResidentService();
                    if(isEdit){
                       rs = await service.editResident(formInfo, [editId]);
                    }else{
                       rs = await service.createResident(formInfo);
                    }

                    setState(() {
                      loading = false;
                    });
                    if(rs.status == 200){
                      if(isEdit){
                        displaySnackbar(_scaffoldkey, "Resident edit successful.",
                            Colors.greenAccent);
                      }else{

                        displaySnackbar(_scaffoldkey, "Resident creation successful.",
                            Colors.greenAccent);
                      }
                      Navigator.pop(context, true);
                    }else{
                      displaySnackbar(_scaffoldkey, "An error occurred while saving resident.",
                          Colors.orangeAccent);
                    }


                  },
                  child: PrimaryButton(
                    btnText: (isEdit)?"Save Resident":"Add Resident",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// arrow
class arrow extends StatelessWidget {
  const arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
          child: FloatingActionButton(heroTag: "arrow_FloatingButton",
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
}

// notification
class notification extends StatelessWidget {
  const notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
          child: FloatingActionButton(heroTag: "NotificationFloatingButton",
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
}



// content function


// class createResident extends StatefulWidget {
//   const createResident({Key? key}) : super(key: key);
//
//   @override
//   _createResidentState createState() => _createResidentState();
// }
//
// class _createResidentState extends State<createResident> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: ScreenUtil().screenHeight - 235.h,
//       child: Column(
//           children: [
//             Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 18.w, vertical: 6.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         child: Flexible(
//                           child: Padding(
//                             padding:  EdgeInsets.only(right: 10.0.w),
//                             child: Container(
//                               height: 40.h,
//                               child: TextFormField(
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                 ),
//                                 decoration: InputDecoration(
//                                     contentPadding: new EdgeInsets.symmetric(
//                                         horizontal: 13, vertical: 10),
//                                     labelText: 'First name',
//                                     labelStyle: TextStyle(
//                                       color: Colors.black45,
//                                     ),
//                                     floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(13),
//                                       borderSide: BorderSide(
//                                         color: Colors.black26,
//                                         width: 1.0,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(13),
//                                       borderSide: BorderSide(
//                                         color: Colors.black38,
//                                         width: 1.0,
//                                       ),
//                                     )),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         child: Flexible(
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 10.0.w),
//                             child: Container(
//                               height: 40.h,
//                               child: TextFormField(
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                 ),
//                                 decoration: InputDecoration(
//                                     contentPadding: new EdgeInsets.symmetric(
//                                         horizontal: 13, vertical: 10),
//                                     labelText: 'Last name',
//                                     labelStyle: TextStyle(
//                                       color: Colors.black45,
//                                     ),
//                                     floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(13),
//                                       borderSide: BorderSide(
//                                         color: Colors.black26,
//                                         width: 1.0,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(13),
//                                       borderSide: BorderSide(
//                                         color: Colors.black38,
//                                         width: 1.0,
//                                       ),
//                                     )),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 18.w, vertical: 8.h),
//                   child: TextFormField(
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                     ),
//                     decoration: InputDecoration(
//                         contentPadding: new EdgeInsets.symmetric(
//                             horizontal: 13, vertical: 10),
//                         labelText: 'Phone',
//                         labelStyle: TextStyle(
//                           color: Colors.black45,
//                         ),
//                         floatingLabelBehavior: FloatingLabelBehavior.auto,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13),
//                           borderSide: BorderSide(
//                             color: Colors.black26,
//                             width: 1.0,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13),
//                           borderSide: BorderSide(
//                             color: Colors.black38,
//                             width: 1.0,
//                           ),
//                         )),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 18.w, vertical: 8.h),
//                   child: TextFormField(
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                     ),
//                     decoration: InputDecoration(
//                         contentPadding: new EdgeInsets.symmetric(
//                             horizontal: 13, vertical: 10),
//                         labelText: 'Email',
//                         labelStyle: TextStyle(
//                           color: Colors.black45,
//                         ),
//                         floatingLabelBehavior: FloatingLabelBehavior.auto,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13),
//                           borderSide: BorderSide(
//                             color: Colors.black26,
//                             width: 1.0,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13),
//                           borderSide: BorderSide(
//                             color: Colors.black38,
//                             width: 1.0,
//                           ),
//                         )),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 18.w, vertical: 8.h),
//                   child: TextFormField(
//                     obscureText: true,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                     ),
//                     decoration: InputDecoration(
//                         contentPadding: new EdgeInsets.symmetric(
//                             horizontal: 13, vertical: 10),
//                         labelText: 'Password',
//                         labelStyle: TextStyle(
//                           color: Colors.black45,
//                         ),
//                         floatingLabelBehavior: FloatingLabelBehavior.auto,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13),
//                           borderSide: BorderSide(
//                             color: Colors.black26,
//                             width: 1.0,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(13),
//                           borderSide: BorderSide(
//                             color: Colors.black38,
//                             width: 1.0,
//                           ),
//                         )),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 18.w, vertical: 10.h),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => Residentshold()));
//                     },
//                     child: PrimaryButton(
//                       btnText: "Add Resident",
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//     );
//   }
// }


