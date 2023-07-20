
import 'package:flutter/material.dart';
import 'package:reamapp/src/residence/account.dart';

// import 'Message.dart';
import '../login.dart';
import 'residence/mainpage.dart';
import 'security//mainpage.dart' as security;
import 'splash.dart';

const String SPLASHSCREEN = '/splashscreen';
const String MAINPAGE = '/mainpage';
const String SECURITYMAINPAGE = '/securitymainpage';
const String LOGINPAGE = '/loginpage';
const String GATEPASSDETAILS = '/gatepassdetails';
const String ACCOUNTPAGE = '/accountpage';
const String NOTIFICATIONSINGLE = '/notificationsingle';
const String NOTIFICATIONS = '/notifications';
const String MESSAGES = '/messages';
const String MESSAGESINGLE = '/messagesingle';
const String FORGOTPAGE = '/forgotpage';
const String VERIFYSCREEN = '/verifyscreen';
const String RESETSCREEN = '/resetscreen';
const String IMAGEHOST = 'http://attendance.cosgroveafrica.com/mobile/';



Map <String, WidgetBuilder> routes = <String, WidgetBuilder>{
  SPLASHSCREEN: (BuildContext context) => new Splash(),
  MAINPAGE: (BuildContext context) =>MainPage(),
  SECURITYMAINPAGE: (BuildContext context) => security.MainPage(),
  LOGINPAGE: (BuildContext context) => new LoginPage(),
  ACCOUNTPAGE: (BuildContext context) => accounthold(),
  // USERPROFILE: (BuildContext context) => new userProfile(),
  // NOTIFICATIONSINGLE: (BuildContext context) => new NotificationPageSingle(),
  // NOTIFICATIONS: (BuildContext context) => new notificationPage(),
  // MESSAGES: (BuildContext context) => new message(),
  // MESSAGESINGLE: (BuildContext context) => new messageSingle(),
  // FORGOTPAGE: (BuildContext context) => new ForgotPage(),
  // VERIFYSCREEN: (BuildContext context) => new VerifyPage(),
  // RESETSCREEN: (BuildContext context) => new ResetPage(),
};