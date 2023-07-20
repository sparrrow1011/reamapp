import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bck.png"), fit: BoxFit.cover),
          ),
      child: Center(
        child: Text('R.E.A.M', style: TextStyle( color: Colors.white,
          fontSize: 50.0,),

        ),
      ),
    );
  }
}