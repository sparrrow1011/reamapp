import 'package:flutter/material.dart';


import 'residents.dart';
import 'alert.dart';
import 'dash.dart';
import 'data.dart';
import 'gatepass.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Navigation extends StatefulWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  Navigation({Key? key, this.selectedIndex : 0, required this.onClicked }) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;
  ValueChanged<int> onClicked = (int index) {};
  // void onClicked(int index) {
  //   setState(() {
  //     selectedIndex = index;
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.selectedIndex;
    onClicked = widget.onClicked;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: const BoxDecoration( color: mainColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),

                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Navigationhold(selectedIndex, onClicked),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget Navigationhold(final selectedIndex, ValueChanged<int> onClicked) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics),label: 'Gate pass'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet),label: 'History',),
          BottomNavigationBarItem(icon: Icon(Icons.warning_rounded),label: 'Alerts',),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle_rounded),label: 'Residents',),
        ],
        currentIndex: selectedIndex,
        onTap: (onClicked){
          switch(onClicked){
            case 0: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard()));
            break;
            case 1: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => gatePasshold()));
            break;
            case 2: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => alerthold()));
            break;
            case 3: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Residentshold()));

          }
        },
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.green.withOpacity(0),
        elevation: 0,
        unselectedItemColor: unselected,
      ),

    );
  }
}


class Navigationhold extends StatefulWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  Navigationhold({this.selectedIndex, required this.onClicked});

  @override
  State<Navigationhold> createState() => _NavigationholdState();
}

class _NavigationholdState extends State<Navigationhold> {
  String qrString = "Not Scanned";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scanQR();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics),label: 'Gate pass'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet),label: 'History',),
          BottomNavigationBarItem(icon: Icon(Icons.warning_rounded),label: 'Alerts',),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle_rounded),label: 'Residents',),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_rounded,),label: 'Scanner',),
        ],
        currentIndex: widget.selectedIndex,
        onTap: (onClicked){
          switch(onClicked){
            case 0: Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard()));
            break;
            case 1: Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gatePasshold()));
            break;
            case 2: Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => alerthold()));
            break;
            case 3: Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Residentshold()));
            break;
          }
        },
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.green.withOpacity(0),
        elevation: 0,
        unselectedItemColor: unselected,
      ),

    );
  }
  Future<void> scanQR() async {
    try {
      FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
          .then((value) {
        setState(() {
          qrString = value;
        });
      });
    } catch (e) {
      setState(() {
        qrString = "unable to read the qr";
      });
    }
  }
}

