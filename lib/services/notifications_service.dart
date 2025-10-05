import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService(plugin: FlutterLocalNotificationsPlugin());
});

class NotificationsService {
  NotificationsService({required FlutterLocalNotificationsPlugin plugin})
      : _plugin = plugin;

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}
