import 'dart:async';
import 'dart:convert';


import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import '../model/gatepass.dart';
import '../model/response.dart';
import '../model/user.dart';
import '../residence/loading.dart';
import '../service/GatePassService.dart';
import '../service/authdata.dart';
import '../service/locatorService.dart';
import '../residence/try.dart';
import '../service/navigationService.dart';
import '../util/helper.dart';
import '../../data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barcode_widget/barcode_widget.dart';

import 'noticeboard.dart';




class gatepassDetailshold extends StatefulWidget {
  Map details = {'id':"", 'token':''};

  gatepassDetailshold(this.details, {Key? key, }) : super(key: key);

  @override
  State<gatepassDetailshold> createState() => _gatepassDetailsholdState();
}

class _gatepassDetailsholdState extends State<gatepassDetailshold> {

  final _scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey repaintWidgetKey = GlobalKey();
  GatePass? gatePassdetail;
  bool loading = false;
  final visitor = TextEditingController();
  final plate_number = TextEditingController();
  User? user;

  Future<Uint8List?> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
      _scaffoldkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    }
    catch (e) {
      print(e);
    }
    // throw '';
  }

  // Future<ByteData> _capturePngToByteData() async {
  //   try {
  //     RenderRepaintBoundary boundary =
  //     repaintWidgetKey.currentContext!.findRenderObject();
  //     double dpr = ui.window.devicePixelRatio;
  //     ui.Image image = await boundary.toImage(pixelRatio: dpr);
  //     ByteData _byteData =
  //     await image.toByteData(format: ui.ImageByteFormat.png);
  //     return _byteData;
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  void _shareQr() async {
    try {
      RenderRepaintBoundary boundary = _scaffoldkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        await WcFlutterShare.share(
          sharePopupTitle: 'Share',
          fileName: 'share.png',
          mimeType: 'image/png',
          bytesOfFile: pngBytes,
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _repaintWidgetKey = GlobalKey();

  Future<void> _shareScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _repaintWidgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Save Uint8List as a temporary file
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/share.png').writeAsBytes(pngBytes);

        // Share the temporary file using the share package
        await Share.shareFiles([file.path], text: 'Please find your Gate pass and code for access to estate');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  getUser() {
    return AuthData.getUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((savedUser) {
      setState(() {
        user = savedUser;
      });

      getGatePass();
    });
  }

  getGatePass() async {
    setState(() {
      loading = true;
    });

    GatePassService service = GatePassService();
    Response rs = await service.getGatePass([widget.details['id']]);
    setState(() {
      loading = false;
    });
    if (rs.status == 200) {
      Map data = rs.data['store'];
      setState(() {
        gatePassdetail = GatePass.fromJson(data['record']);
      });
    } else {
      displaySnackbar(_scaffoldkey, "Record not found", Colors.redAccent);
      locator<NavigationService>().pop();
    }
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldkey,
      body: (loading)?Loading():SingleChildScrollView(child: Container(
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
                                    child: arrow(context),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                    child: notification(context),
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
                                      Text(
                                        "Gate pass details",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
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
                                Container(
                                  height: ScreenUtil().screenHeight - 235.h,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            // GATE PASS DETAILS

                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18.w, vertical: 8.h),
                                              child: TextFormField(
                                                readOnly: true,
                                                textCapitalization: TextCapitalization.characters,
                                                initialValue: (gatePassdetail?.attr!['visitor'] is String)? gatePassdetail!.attr!['visitor']! : '',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                                decoration: InputDecoration(
                                                    contentPadding: new EdgeInsets.symmetric(
                                                        horizontal: 13, vertical: 10),
                                                    labelText: 'Visitor\'s Name' ,
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
                                                readOnly: true,
                                                textCapitalization: TextCapitalization.characters,
                                                initialValue: (gatePassdetail?.plate_number is String)? gatePassdetail!.plate_number! : '',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
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
                                            SizedBox(height: 30.h,),
                                            RepaintBoundary(
                                              key: _repaintWidgetKey,
                                              child: Container(
                                                child: BarcodeWidget(
                                                  color: mainColor,
                                                  backgroundColor: Colors.white,
                                                  data: ' Id | ' + ((gatePassdetail?.id is String)? gatePassdetail!.id! : '')+';'
                                                      +'\n Token | ' + ((gatePassdetail?.token is String)? gatePassdetail!.token! : '')+';',
                                                  height: 190.h,
                                                  width: 190.w,
                                                  barcode: Barcode.qrCode(),
                                                ),
                                              ),
                                            ),


                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18.w, vertical: 8.h),
                                              child: TextFormField(
                                                readOnly: true,
                                                initialValue: (gatePassdetail?.token is String)? gatePassdetail!.token! : '',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                                decoration: InputDecoration(
                                                    contentPadding: new EdgeInsets.symmetric(
                                                        horizontal: 13, vertical: 10),
                                                    suffixIcon: GestureDetector(child: Icon(Icons.copy_rounded, color: mainColor, semanticLabel: 'Copied', ), onTap: (){
                                                      ClipboardData data = ClipboardData(text: (gatePassdetail?.token is String)? gatePassdetail!.token! : '');

                                                      Clipboard.setData(data);
                                                      displaySnackbar(_scaffoldkey, "Token copied", Colors.blueAccent);
                                                    },) ,
                                                    labelText: 'Gate pass token',
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
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: PrimaryButton(
                                                  btnText: "Done",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 295.h,
                        left: 260.w,
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          child: new RawMaterialButton(
                            shape: new CircleBorder(),
                            fillColor: mainColor,
                            elevation: 0.0,
                            child: Icon(Icons.share_rounded, color: Colors.white,),
                            onPressed: _shareScreenshot,
                          ),
                        ),
                      ),
                    ],
                  )
              ),

            ],
          )
      ),),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/images/logo.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  Widget arrow(BuildContext context) {
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
          heroTag: 'notificationHeroTag',
          child: Icon(
            Icons.notification_important_rounded,
            color: Colors.white,
            size: 30,
          ),
        ));
  }
}

