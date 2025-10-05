import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senioren_app/services/stt_service.dart';

final sttServiceProvider = Provider<STTService>((ref) => STTService());

class AssistantScreen extends ConsumerWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assistent')),
      body: const Center(child: Text('Assistent bereit')),
    );
  }
}
