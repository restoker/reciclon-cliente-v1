import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class PushNotificationProvider {
  // Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  // Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void init() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sonido'),
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessageListener() {
    // notificaciones en segundo plano
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null) {
          print('nueva notificacion: $message');
          // Navigator.pushNamed(
          //   context,
          //   '/message',
          //   arguments: MessageArguments(message, true),
          // );
        }
      },
    );

    // recivir las notificacion en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    // acciones al precionar o abrir la notificacion
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }

  void saveToken(User user, BuildContext context) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final userProvider = UserProvider();
      userProvider.init(context, sesionUser: user);
      userProvider.updateNotificationToken(user.id!, token);
    }
  }

  Future<void> sendMessage(
      String to, Map<String, dynamic> data, String titulo, String body) async {
    Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');
    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAPfXEFSA:APA91bH-obwRDZYcVg17sOX4Mtb1cliuir8n-TssWNQ6f5PUGq55SGVAWVmU_AghcTeNbRN0_XB7YM8HSwcEI-H4wAM9QvZZ7KcxgPPrD-LlwxdokIQmRIUPV7peADw5Lmp9buoC-WbB',
      },
      body: jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': titulo,
        },
        'priority': 'high',
        'ttl': '4500s',
        'data': data,
        'to': to
      }),
    );
  }
}
