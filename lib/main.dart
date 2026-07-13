import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'app.dart';
import 'core/services/notification_service.dart';
import 'config/app_config.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
    visibility: NotificationVisibility.public,
    playSound: true,
    enableVibration: true,
    fullScreenIntent: true,
  );

  const NotificationDetails details = NotificationDetails(android: androidDetails);

  final notification = message.notification;
  if (notification != null) {
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  } else if (message.data.isNotEmpty) {
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'] ?? 'New Notification',
      message.data['body'] ?? '',
      details,
      payload: jsonEncode(message.data),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await AppConfig.init();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize Hive
  await Hive.initFlutter();
  
  runApp(
    const ProviderScope(
      child: EduCoreApp(),
    ),
  );
}
