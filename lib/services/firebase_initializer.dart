import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _notifications = FlutterLocalNotificationsPlugin();

Future<void> initializeFirebaseDependencies() async {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await FirebaseAuth.instance.setLanguageCode('de');
  await FirebaseAppCheck.instance.activate();

  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );
  await _notifications.initialize(initializationSettings);
  await FirebaseMessaging.instance.requestPermission();
}
