// ignore: file_names
// ignore_for_file: file_names

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../model/pushnotification.dart';
import '../model/response.dart';
import '../model/user.dart';
import '../service/api.dart';
import '../service/authdata.dart';

class PushNotificationService {
  User? user;
  PushNotificationService(){

  }
  getUser() {
    return AuthData.getUser();
  }
  // final FirebaseMessaging _fcm;

  // PushNotificationService(this._fcm);
  //
  // Future initialise() async {
  //   if (Platform.isIOS) {
  //     _fcm.requestNotificationPermissions(IosNotificationSettings());
  //   }
  //
  //   // If you want to test the push notification locally,
  //   // you need to get the token and input to the Firebase console
  //   // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
  //   String token = await _fcm.getToken();
  //   print("FirebaseMessaging token: $token");
  //
  //   _fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //     },
  //   );
  // }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
   late AndroidNotificationChannel channel;

initNotification() async{

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
  final MacOSInitializationSettings initializationSettingsMacOS =
  MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
   channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title,
     description: 'channel description',// description
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          print('notification payload: ' + payload);
        }
      });
}
  void setToken(String? token) async{
    getUser().then((savedUser) async {
      user = savedUser;
      Map body ={
        "user_type": (user!.is_resident == true)?3:2,
        "token": token,
        "user_id": user!.id
      };
      print('FCM Token: $token');
      String path = 'resident/update_push_notification';
      Api api = Api();
      Map data = await api.post(path, body: Map<String,dynamic>.from(body));
      print('token data');
      print(data);
      // return Response.fromJson(Map<String, dynamic>.from(data));
    });

  }
  late final FirebaseMessaging _messaging;
  instantiate() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
  }
  getToken(){
    String? _token;
    late Stream<String> _tokenStream;

    _messaging
        .getToken(
        vapidKey:
        'BNr6PJzGP7D_EGENzrIoTmxpqTL-D-N0LXX0n5PvmzVrhTXn8XpOhkPZffVXmHTuAtCV1O0kEgKZ3E327VeWzm0')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

   registerNotification() async {
    await initNotification();
    await instantiate();
     getToken();
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Handling a OnMESSAGE lISTEN message: ${message.messageId}");
        RemoteNotification? notif = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notif != null && android != null) {
          showNotif(notif, android, channel);
        }
        print(message);

      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print(message.data);
        print("mESSAGE App opened: ${message.messageId}");

      });
      RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
      print(initialMessage);
      print("Handling a Initial Message: ${(initialMessage?.messageId ??"")}");
      if (initialMessage != null) {
        RemoteNotification? notif = initialMessage.notification;
        AndroidNotification? android = initialMessage.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notif != null && android != null) {
          showNotif(notif, android, channel);
        }
      }

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
    await Firebase.initializeApp();
    RemoteNotification? notif = message!.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notif != null && android != null) {
      showNotif(notif, android, channel);
    }
    print("Handle Background Message");

  }

  showNotif(RemoteNotification? notification, AndroidNotification androidNotification, AndroidNotificationChannel channel ){
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: androidNotification.smallIcon,
            // other properties...
          ),
        ));
  }


}