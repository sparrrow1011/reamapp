import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reamapp/src/model/gatepass.dart';
import 'package:reamapp/src/model/response.dart';
import 'package:reamapp/src/model/user.dart';
import 'package:reamapp/src/residence/gatepassdetails.dart';
import 'package:reamapp/src/residence/loading.dart';
import 'package:reamapp/src/service/GatePassService.dart';
import 'package:reamapp/src/service/authdata.dart';
import 'package:reamapp/src/service/locatorService.dart';
import 'package:reamapp/src/service/navigationService.dart';
import 'package:reamapp/src/util/helper.dart';
import 'package:reamapp/src/util/validator.dart';

import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barcode_widget/barcode_widget.dart';

import 'navigation.dart';
import 'noticeboard.dart';

class createGatepasshold extends StatefulWidget {
  bool isEdit = false;
  String? editId = "";
  createGatepasshold({Key? key, this.isEdit: false, this.editId: ""})
      : super(key: key);

  @override
  _createGatepassholdState createState() => _createGatepassholdState();
}

class _createGatepassholdState extends State<createGatepasshold> {
  int selectedIndex = 0;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool isEdit = false;
  String? editId = "";
  GatePass? editGatePass;
  bool loading = false;
  final visitor = TextEditingController();
  final plate_number = TextEditingController();
  User? user;
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  getUser() {
    return AuthData.getUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isEdit = widget.isEdit;
    this.editId = widget.editId;
    getUser().then((savedUser) {
      setState(() {
        user = savedUser;
      });

      if (isEdit) {
        getGatePass();
      }
    });
  }

  getGatePass() async {
    setState(() {
      loading = true;
    });

    GatePassService service = GatePassService();
    Response rs = await service.getGatePass([editId]);
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      editGatePass = GatePass.fromJson(data['record']);
      if (editGatePass != null) {
        String titleString = editGatePass?.attr!['visitor'];
        visitor.text = titleString;
        plate_number.text = ((editGatePass?.plate_number != null)
            ? editGatePass?.plate_number
            : "")!;
      }
    } else {
      displaySnackbar(_scaffoldkey, "Record not found", Colors.redAccent);
      locator<NavigationService>().pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldkey,
      body: (loading) ? Loading() : SingleChildScrollView(
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
                                      padding:
                                      EdgeInsets.only(right: 10.w, top: 30.h),
                                      child: arrow(),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(right: 10.w, top: 30.h),
                                      child: notification(),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Gate Pass",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          (isEdit)?"Edit gate pass":"Create gate pass",
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
                                children: <Widget>[
                                  // PUT CONTENT FUNCTION HERE
                                  createGatepass(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),

                // navigation Menu
                // Container(
                //   child: Navigation(),
                // )
              ],
            )),
      ),
    );
  }

  Widget arrow() {
    return Container(
        child: FloatingActionButton(
      heroTag: 'arrowHeroTag',
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

  Widget notification() {
    return Container(
        child: FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Notificationhold()));
      },
      mini: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      heroTag: 'notificationHeroTag',
      child: Icon(
        Icons.notification_important_rounded,
        color: Colors.white,
        size: 30,
      ),
    ));
  }

  Widget createGatepass(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - 235.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  child: TextFormField(
                    controller: visitor,
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            horizontal: 13, vertical: 10),
                        labelText: 'Visitor\'s name',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: plate_number,
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            horizontal: 13, vertical: 10),
                        labelText: 'Vehicle plate',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  child: InkWell(
                    onTap: () async {
                      List isEmpty = Validator.isEmpty(visitor.text);
                      if (isEmpty[0]) {
                        displaySnackbar(
                            _scaffoldkey, isEmpty[1].toString(), Colors.orange);
                        return;
                      }
                      DateTime now = DateTime.now();
                      print(now.toString());
                      Map<String, dynamic> attr = {'visitor': visitor.text};
                      Map<String, dynamic> formInfo = {
                        'id': (isEdit) ? editId : '',
                        'date_created': now.toString(),
                        'resident': (isEdit) ? editGatePass!.resident : '',
                        'resident_id':
                            (isEdit) ? editGatePass!.resident_id : user?.id,
                        'site_id': (isEdit) ? editGatePass!.site_id : '',
                        'status': (isEdit) ? editGatePass!.status : 0,
                        'token': (isEdit) ? editGatePass!.token : '',
                        'plate_number': plate_number.text,
                        'type': 1,
                        '_list':
                            "GatePassList-\$limit:10,\$offset:0,\$order:date_created desc",
                        '_model': 'GatePass',
                        'attr': attr
                      };

                      if (isEdit == false) {
                        formInfo['mode'] = 'create';
                      }
                      print(formInfo);
                      setState(() {
                        loading = true;
                      });
                      Response rs;
                      GatePassService service = GatePassService();
                      if (isEdit) {
                        rs = await service.editGatePass(formInfo, [editId]);
                      } else {
                        rs = await service.createGatePass(formInfo);
                      }

                      setState(() {
                        loading = false;
                      });
                      Map data = {};
                      if (rs.status == 200) {
                        if (isEdit) {
                          displaySnackbar(_scaffoldkey,
                              "Gatepass edit successful.", Colors.greenAccent);
                        } else {
                          visitor.clear();
                          plate_number.clear();
                          displaySnackbar(
                              _scaffoldkey,
                              "Gatepass creation successful.",
                              Colors.greenAccent);
                        }
                        data = rs.data['store'];
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => gatepassDetailshold(
                                    data)));
                      } else {
                        displaySnackbar(
                            _scaffoldkey,
                            "An error occurred while saving resident.",
                            Colors.orangeAccent);
                      }

                    },
                    child: PrimaryButton(
                      btnText: (isEdit)?"Save Pass":"Generate Pass",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

