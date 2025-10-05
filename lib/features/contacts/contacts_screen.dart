import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/contact.dart';
import '../../data/repositories/contacts_repository.dart';
import '../../services/auth_providers.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/contact_tile.dart';
import 'contact_detail_screen.dart';
import 'contacts_providers.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsListProvider);
    final filteredContacts = ref.watch(filteredContactsProvider);
    final emergencySlots = ref.watch(remainingEmergencySlotsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontakte'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacingTokens.large),
              child: TextField(
                onChanged: (value) => ref.read(contactsSearchProvider.notifier).state = value,
                decoration: InputDecoration(
                  hintText: 'Kontakt suchen…',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: AppRadiusTokens.lg),
                ),
              ),
            ),
            if (emergencySlots > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacingTokens.large),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Noch $emergencySlots Notfallkontakte möglich',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacingTokens.large),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Maximale Notfallkontakte erreicht',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColorTokens.error)),
                ),
              ),
            Expanded(
              child: contactsAsync.when(
                data: (_) => ListView.builder(
                  padding: const EdgeInsets.all(AppSpacingTokens.large),
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacingTokens.small),
                      child: ContactTile(
                        name: contact.name,
                        subtitle: contact.phone,
                        isEmergency: contact.isEmergency,
                        avatar: CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColorTokens.primary.withOpacity(0.1),
                          child: Text(
                            contact.name.isNotEmpty
                                ? contact.name.substring(0, 1).toUpperCase()
                                : '?',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        onContact: () => _contactAction(context, contact),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ContactDetailScreen(contact: contact),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Kontakte konnten nicht geladen werden.'),
                      const SizedBox(height: AppSpacingTokens.medium),
                      SecondaryButton(
                        label: 'Erneut versuchen',
                        icon: Icons.refresh,
                        onPressed: () => ref.refresh(contactsListProvider),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacingTokens.large),
              child: PrimaryButton(
                label: 'Kontakt hinzufügen',
                icon: Icons.person_add,
                onPressed: () => _showAddContactSheet(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _contactAction(BuildContext context, Contact contact) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kontaktieren'),
        content: Text('Möchten Sie ${contact.name} anrufen?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _showAddContactSheet(BuildContext context, WidgetRef ref) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    bool isEmergency = false;
    final auth = ref.read(authStateChangesProvider).value;
    final uid = auth?.uid ?? 'demo';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacingTokens.large,
            right: AppSpacingTokens.large,
            top: AppSpacingTokens.large,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacingTokens.large,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Neuen Kontakt hinzufügen', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacingTokens.medium),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => value == null || value.isEmpty ? 'Bitte geben Sie einen Namen ein.' : null,
                    ),
                    const SizedBox(height: AppSpacingTokens.medium),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Telefonnummer'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Bitte geben Sie eine Telefonnummer ein.' : null,
                    ),
                    const SizedBox(height: AppSpacingTokens.medium),
                    SwitchListTile.adaptive(
                      value: isEmergency,
                      onChanged: (value) {
                        final remaining = ref.read(remainingEmergencySlotsProvider);
                        if (value && remaining <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Es sind bereits drei Notfallkontakte vorhanden.')),
                          );
                          return;
                        }
                        setState(() => isEmergency = value);
                      },
                      title: const Text('Als Notfallkontakt markieren'),
                    ),
                    const SizedBox(height: AppSpacingTokens.large),
                    PrimaryButton(
                      label: 'Speichern',
                      icon: Icons.check,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        final contact = Contact(
                          id: '',
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          isEmergency: isEmergency,
                          createdAt: DateTime.now(),
                        );
                        try {
                          await ref.read(contactsRepositoryProvider).addContact(uid, contact);
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${contact.name} wurde hinzugefügt.')),
                            );
                          }
                        } on StateError catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message ?? 'Es ist ein Fehler aufgetreten.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
