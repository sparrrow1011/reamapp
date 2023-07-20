// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reamapp/src/service/navigationService.dart';

import 'src/routes.dart';
import 'src/service/locatorService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  // PushNotificationService pns = PushNotificationService();
  // pns.registerNotification();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, Widget) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ream Manager',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(button: TextStyle(fontSize: 45.sp)),
            fontFamily: "Nunito"
        ),
        routes: routes,
        initialRoute: SPLASHSCREEN,
        navigatorKey: locator<NavigationService>().navigatorKey,
        // home: Scaffold(
        //   resizeToAvoidBottomInset: false,
        //   body: Container(
        //     child: LoginPage(),
        //   ),
        // ),
      ),
    );

  }

}