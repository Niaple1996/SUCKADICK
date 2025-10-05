import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/checkin_settings.dart';
import '../data/repositories/checkin_repository.dart';

final checkinServiceProvider = Provider<CheckinService>((ref) {
  final repository = ref.watch(checkinRepositoryProvider);
  return CheckinService(repository: repository);
});

class CheckinService {
  CheckinService({required CheckinRepository repository})
      : _repository = repository,
        _notifications = FlutterLocalNotificationsPlugin();

  final CheckinRepository _repository;
  final FlutterLocalNotificationsPlugin _notifications;

  Duration _frequencyToDuration(String frequency) {
    switch (frequency) {
      case '2d':
        return const Duration(days: 2);
      case 'weekly':
        return const Duration(days: 7);
      case 'daily':
      default:
        return const Duration(days: 1);
    }
  }

  DateTime calculateNextDue(DateTime from, String frequency) {
    return from.add(_frequencyToDuration(frequency));
  }

  Future<void> updateSettings({
    required String uid,
    required CheckinSettings settings,
  }) async {
    final nextDue = settings.enabled
        ? calculateNextDue(DateTime.now(), settings.frequency)
        : null;
    final updated = settings.copyWith(nextDueAt: nextDue);
    await _repository.saveSettings(uid, updated);
    await _scheduleNotification(updated);
  }

  Future<void> _scheduleNotification(CheckinSettings settings) async {
    await _notifications.cancel(1);
    if (!settings.enabled || settings.nextDueAt == null) {
      return;
    }
    final androidDetails = AndroidNotificationDetails(
      'checkin_channel',
      'Check-in Erinnerungen',
      channelDescription: 'Informiert über anstehende Check-ins',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notifications.schedule(
      1,
      'Check-in fällig',
      'Bitte melden Sie sich innerhalb der nächsten Stunden.',
      settings.nextDueAt!,
      details,
      androidAllowWhileIdle: true,
    );
  }

  String timerLabel(CheckinSettings settings) {
    if (!settings.enabled) {
      return 'Deaktiviert';
    }
    if (settings.nextDueAt == null) {
      return 'Berechnung läuft…';
    }
    final remaining = settings.nextDueAt!.difference(DateTime.now());
    if (remaining.isNegative) {
      return 'Fällig';
    }
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes Stunden verbleibend';
  }
}
