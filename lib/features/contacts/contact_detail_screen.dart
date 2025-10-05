import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senioren_app/data/repositories/emergency_repository.dart';

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) => EmergencyRepository());

class ContactDetailScreen extends ConsumerWidget {
  final dynamic contact; // akzeptiert jeden übergebenen Kontakt
  const ContactDetailScreen({super.key, this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kontakt')),
      body: const Center(child: Text('Kontakt-Details')),
    );
  }
}
