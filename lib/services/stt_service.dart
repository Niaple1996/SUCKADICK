import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

final sttServiceProvider = Provider<SpeechToTextService>((ref) {
  return SpeechToTextService();
});

class SpeechToTextService {
  SpeechToTextService() : _speech = stt.SpeechToText();

  final stt.SpeechToText _speech;
  bool _isAvailable = false;

  bool get isListening => _speech.isListening;

  Future<bool> init() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      debugPrint('Microphone permission denied');
      return false;
    }
    _isAvailable = await _speech.initialize();
    return _isAvailable;
  }

  Future<void> start({required Function(String) onResult}) async {
    if (!_isAvailable) {
      final available = await init();
      if (!available) {
        throw StateError('Spracheingabe nicht verfügbar');
      }
    }
    await _speech.listen(onResult: onResult, localeId: 'de_DE');
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}
