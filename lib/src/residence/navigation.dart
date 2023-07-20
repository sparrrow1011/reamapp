import 'package:flutter/material.dart';
import '../residence/account.dart';
import '../residence/dash.dart';
import '../residence/gatepass.dart';
import '../residence/residents.dart';
import '../routes.dart';

import 'alert.dart';
import '../../data.dart';


class Navigation extends StatefulWidget {

  final selectedIndex;
  ValueChanged<int> onClicked;
   Navigation({Key? key, this.selectedIndex:0, required this.onClicked }) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;
  ValueChanged<int> onClicked = (int index) {};
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
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: const BoxDecoration( color: mainColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),

                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Navigationhold(context,
                         selectedIndex,
                        onClicked
                      ),
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
  Widget Navigationhold(BuildContext context, int selectedIndex, ValueChanged<int>onClicked) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet),label: 'Accounts',),
          BottomNavigationBarItem(icon: Icon(Icons.warning_rounded),label: 'Alert',),
          BottomNavigationBarItem(icon: Icon(Icons.analytics),label: 'Gate Pass',),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle_rounded,),label: 'Resident',),
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
                    builder: (context) => accounthold()));
            break;
            case 2: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => alerthold()));
            break;
            case 3: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => gatePasshold()));
            break;
            case 4: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Residentshold()));
            // case 4: Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => Residentshold()));
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


class Navigationhold extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  Navigationhold({this.selectedIndex, required this.onClicked});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet),label: 'Accounts',),
          BottomNavigationBarItem(icon: Icon(Icons.warning_rounded),label: 'Alert',),
          BottomNavigationBarItem(icon: Icon(Icons.analytics),label: 'Gate Pass',),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle_rounded,),label: 'Resident',),
        ],
        currentIndex: selectedIndex,
        onTap: (onClicked){
          switch(onClicked){
            case 0: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard()));
            break;
            case 1: Navigator.pushReplacementNamed(context, ACCOUNTPAGE);
            break;
            case 2: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => alerthold()));
            break;
            case 3: Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => gatePasshold()));
            break;
            case 4: Navigator.pushReplacement(
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

