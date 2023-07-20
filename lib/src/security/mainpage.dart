import 'package:flutter/material.dart';
import 'dash.dart';

import 'navigation.dart';




class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'R.E.A.M',
        home: Stack(
          children: <Widget>[
            Dashboard(),
          ],
        )
    );
  }
}









