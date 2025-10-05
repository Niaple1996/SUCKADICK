import 'package:flutter/foundation.dart' show kIsWeb;

class STTService {
  Future<void> startListening({void Function(String)? onText}) async {
    // Web-Stub: verhindert Build-Fehler
    if (kIsWeb) {
      onText?.call('');
      return;
    }
    // TODO: Mobile-Implementierung mit speech_to_text ergänzen
  }

  Future<void> stop() async {}
}
