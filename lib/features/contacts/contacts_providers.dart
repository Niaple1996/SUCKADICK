import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/contact.dart';
import '../../data/repositories/contacts_repository.dart';
import '../../services/auth_providers.dart';

final contactsSearchProvider = StateProvider<String>((ref) => '');

final contactsListProvider = StreamProvider<List<Contact>>((ref) {
  final auth = ref.watch(authStateChangesProvider).value;
  final uid = auth?.uid ?? 'demo';
  return ref.watch(contactsRepositoryProvider).watchContacts(uid);
});

final filteredContactsProvider = Provider<List<Contact>>((ref) {
  final query = ref.watch(contactsSearchProvider);
  final contactsAsync = ref.watch(contactsListProvider);
  return contactsAsync.maybeWhen(
    data: (contacts) {
      if (query.isEmpty) {
        return contacts;
      }
      final lower = query.toLowerCase();
      return contacts
          .where(
            (contact) => contact.name.toLowerCase().contains(lower) || contact.phone.toLowerCase().contains(lower),
          )
          .toList();
    },
    orElse: () => const [],
  );
});

final remainingEmergencySlotsProvider = Provider<int>((ref) {
  final contacts = ref.watch(contactsListProvider).maybeWhen(
        data: (data) => data,
        orElse: () => const <Contact>[],
      );
  final emergencyCount = contacts.where((contact) => contact.isEmergency).length;
  return (3 - emergencyCount).clamp(0, 3);
});
