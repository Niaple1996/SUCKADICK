import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:senioren_app/services/checkin_service.dart';

final checkinServiceProvider = Provider<CheckinService>((ref) => CheckinService());

class CheckinScreen extends ConsumerWidget {
  const CheckinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (kIsWeb) return; // Web: nichts planen
            await ref.read(checkinServiceProvider).scheduleNextCheckin();
          },
          child: const Text('Check-in planen'),
        ),
      ),
    );
  }
}
