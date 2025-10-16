import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void configureFCM() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true);

    print('User granted permission :${settings.authorizationStatus}');

    String? token = await messaging.getToken();
    print('FCM Token :${token}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Foreground message received :${message.messageId}');
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        print(
            'App opened from terminated state via notification :${message.messageId}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('onMessageOpenedApp :${message.messageId}');
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fcm_channel',
      'FCM Notifications',
      channelDescription: 'Channel for FCM notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(notification.hashCode,
        notification.title, notification.body, platformDetails,
        payload: message.data.isNotEmpty ? jsonEncode(message.data) : null);
  }
  

}
