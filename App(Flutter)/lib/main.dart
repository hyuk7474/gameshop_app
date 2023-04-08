// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shopping_ui/member/login/login.dart';
import 'package:shopping_ui/member/mypage/mypage.dart';
import 'package:shopping_ui/product/bootpay/pay.dart';
import 'package:shopping_ui/product/bootpay/temp/detailscreen_temp.dart';
import 'package:shopping_ui/product/bootpay/temp/detailscreen_temp.dart';
import 'package:shopping_ui/product/pages/home_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /* Create an Android Notification Channel.
    We use this channel in the `AndroidManifest.xml` file to override the
    default FCM channel to enable heads up notifications. */
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Update the iOS foreground notification presentation options
    // to allow heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  KakaoSdk.init(nativeAppKey: '');  // secret key
  runApp(MaterialApp(    
    debugShowCheckedModeBanner: false,        

    home: RootApp(),
  ));  
}