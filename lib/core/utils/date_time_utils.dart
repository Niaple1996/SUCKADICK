import 'package:intl/intl.dart';

/// Formats durations and timestamps for localized display.
class DateTimeUtils {
  const DateTimeUtils._();

  static String humanizeDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours <= 0) {
      return Intl.message(
        '$minutes Minuten verbleibend',
        name: 'minutesRemaining',
        args: [minutes],
      );
    }
    return Intl.message(
      '$hours:${minutes.toString().padLeft(2, '0')} Stunden verbleibend',
      name: 'hoursRemaining',
      args: [hours, minutes],
    );
  }
}
