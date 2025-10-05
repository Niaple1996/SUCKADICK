import 'package:flutter/foundation.dart' show kIsWeb;

class CheckinService {
  Future<void> scheduleNextCheckin() async {
    // Web: Scheduling aus, sonst Fehler mit flutter_local_notifications v16
    if (kIsWeb) return;
    // TODO: Für Android/iOS später mit zonedSchedule implementieren
  }
}
