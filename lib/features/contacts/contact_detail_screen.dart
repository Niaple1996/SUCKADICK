import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/contact.dart';
import '../../data/repositories/contacts_repository.dart';
import '../../data/repositories/emergency_repository.dart';
import '../../services/auth_providers.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import 'emergency_flow.dart';

class ContactDetailScreen extends ConsumerWidget {
  const ContactDetailScreen({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(contact.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacingTokens.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColorTokens.primary.withOpacity(0.1),
                child: Text(
                  contact.name.isNotEmpty ? contact.name.substring(0, 1).toUpperCase() : '?',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.large),
              Text(contact.name, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacingTokens.small),
              Text(contact.phone, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacingTokens.xLarge),
              if (contact.isEmergency)
                Chip(
                  label: const Text('Notfallkontakt'),
                  backgroundColor: AppColorTokens.error.withOpacity(0.1),
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColorTokens.error),
                ),
              const Spacer(),
              DestructiveButton(
                label: 'Notfall melden',
                icon: Icons.warning,
                onPressed: () => _confirmEmergency(context, ref, contact),
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              SecondaryButton(
                label: 'Bearbeiten',
                icon: Icons.edit,
                onPressed: () => _showEditSheet(context, ref, contact),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmEmergency(BuildContext context, WidgetRef ref, Contact contact) async {
    final confirmed = await showEmergencyConfirmation(context);
    if (confirmed != true) {
      return;
    }
    final auth = ref.read(authStateChangesProvider).value;
    final uid = auth?.uid ?? 'demo';
    await ref.read(emergencyRepositoryProvider).logEmergency(uid);
    if (!context.mounted) {
      return;
    }
    await showEmergencySent(context);
  }

  Future<void> _showEditSheet(BuildContext context, WidgetRef ref, Contact contact) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: contact.name);
    final phoneController = TextEditingController(text: contact.phone);
    bool isEmergency = contact.isEmergency;
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
                    Text('Kontakt bearbeiten', style: Theme.of(context).textTheme.titleLarge),
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
                      validator: (value) => value == null || value.isEmpty ? 'Bitte geben Sie eine Telefonnummer ein.' : null,
                    ),
                    const SizedBox(height: AppSpacingTokens.medium),
                    SwitchListTile.adaptive(
                      value: isEmergency,
                      onChanged: (value) {
                        setState(() => isEmergency = value);
                      },
                      title: const Text('Als Notfallkontakt markieren'),
                    ),
                    const SizedBox(height: AppSpacingTokens.large),
                    PrimaryButton(
                      label: 'Aktualisieren',
                      icon: Icons.save,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        final updated = contact.copyWith(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          isEmergency: isEmergency,
                        );
                        await ref.read(contactsRepositoryProvider).updateContact(uid, updated);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${updated.name} wurde aktualisiert.')),
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
