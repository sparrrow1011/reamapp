
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reamapp/data.dart';
import 'package:reamapp/src/model/alert.dart';
import 'package:reamapp/src/model/response.dart';
import 'package:reamapp/src/service/AlertService.dart';



import 'navigation.dart';



class alert_addresshold extends StatefulWidget {
  bool edit = true;
  Alert? alert;
  alert_addresshold({Key? key, required this.alert,  this.edit: true}) : super(key: key);

  @override
  _alert_addressholdState createState() => _alert_addressholdState();
}

class _alert_addressholdState extends State<alert_addresshold> with TickerProviderStateMixin {
  int selectedIndex = 0;
  bool buttonLoading = false;
  late AnimationController rippleController;
  late AnimationController scaleController;

  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;
  final solution = TextEditingController();
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();

    rippleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    scaleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    rippleAnimation =
    Tween<double>(begin: 100.0, end: 110.0).animate(rippleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rippleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          rippleController.forward();
        }
      });

    scaleAnimation =
        Tween<double>(begin: 1.0, end: 40.0).animate(scaleController);

    rippleController.forward();
    print(widget.alert?.attr);
  }
  updateAlertStatus() async {
    setState(() {
      buttonLoading = true;
    });

    Map attr = widget.alert?.attr??{};
    attr['solution'] = solution.text;
    print(attr);
    AlertService service = AlertService();
    Response rs = await service.updateAlert({
      'status': 3,
      'attr':attr
    }, [widget.alert?.id]);
    setState(() {
      buttonLoading = false;
    });
    if (rs.status == 200) {
      // Map data = rs.data['store']['dashboard'];
      setState(() {
        widget.edit = false;
        widget.alert?.status = 3;
        widget.alert?.attr = attr;

      });

    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    rippleController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Enable resizing to avoid overlapping with the keyboard
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // page main content container
              Container(
                height: ScreenUtil().screenHeight,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                    child: arrow(context),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 10.w, top: 30.h),
                                    child: Container(),
                                  ),
                                ],
                              ),
                              // PUT CONTENT FUNCTION HERE
                              alert_address()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget alert_address() {
    return Column(
      children: [
        Container(
          height: 100.h,
          child: AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) => Container(
              width: rippleAnimation.value,
              height: rippleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: customShadow,
                    color: Colors.white.withOpacity(0.9)),
                child: AnimatedBuilder(
                  animation: scaleAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: scaleAnimation.value,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: Center(
                        child: Icon(
                          Icons.warning_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: ScreenUtil().screenHeight - 200.h,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0.w, top: 10.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            widget.alert?.name??"",
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: Text(
                            widget.alert?.Address??"",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.alert?.phone_number??"",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: Text(
                            widget.alert?.attr!['description']??"",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ]
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
                SizedBox(
                  height: 20.h,
                ),
                (widget.edit)?TextField(
                  controller: solution,
                  maxLines: 5,
                  maxLength: 500,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                  decoration: InputDecoration(
                      labelText: 'What solution did you take',
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
                ):Text(widget.alert?.attr!['solution']??"", style: TextStyle(color: Colors.white),),
                SizedBox(
                  height: 20.h,
                ),
                if(widget.edit)
                  ((buttonLoading)?CircularProgressIndicator():
                  GestureDetector(
                  onTap: () {
                    updateAlertStatus();
                  },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.red, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ))),
              ],
            ),
          ),
        )
      ],
    );
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
}


