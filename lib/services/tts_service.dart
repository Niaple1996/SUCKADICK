import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

class TtsService {
  TtsService() : _tts = FlutterTts();

  final FlutterTts _tts;

  Future<void> speak(String text) async {
    try {
      await _tts.setLanguage('de-DE');
      await _tts.setSpeechRate(0.4);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } on Exception catch (_) {
      debugPrint('TTS not available');
    }
  }

  Future<void> stop() => _tts.stop();
}
