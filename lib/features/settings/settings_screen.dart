import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../home/user_providers.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: profileAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.all(AppSpacingTokens.large),
          children: [
            _SettingsTile(
              icon: Icons.notifications_active,
              title: 'Benachrichtigungen',
              subtitle: 'Sie erhalten Check-in-Erinnerungen.',
              trailing: Chip(
                label: Text(profile.notificationsEnabled ? 'Aktiviert' : 'Deaktiviert'),
                backgroundColor: profile.notificationsEnabled
                    ? AppColorTokens.success.withOpacity(0.15)
                    : AppColorTokens.warning.withOpacity(0.2),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationSettingsPage()),
              ),
            ),
            _SettingsTile(
              icon: Icons.text_fields,
              title: 'Schriftgröße anpassen',
              subtitle: 'Aktuell ${(profile.textScale * 100).round()} %',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TextScalePage()),
              ),
            ),
            _SettingsTile(
              icon: Icons.language,
              title: 'Sprache ändern',
              subtitle: 'Aktuell ${profile.preferredLanguage.toUpperCase()}',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LanguageSettingsPage()),
              ),
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'Info & Hilfe',
              subtitle: 'Version 1.0.0',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InfoHelpPage()),
              ),
            ),
            _SettingsTile(
              icon: Icons.privacy_tip,
              title: 'Datenschutz',
              subtitle: 'Impressum, Datenschutz und Rechte',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyOverviewPage()),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Einstellungen konnten nicht geladen werden: $error')),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title, $subtitle',
      button: true,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacingTokens.small),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadiusTokens.lg,
          boxShadow: AppShadowTokens.cardShadow,
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: AppColorTokens.primary.withOpacity(0.12),
            child: Icon(icon, color: AppColorTokens.primary, size: 28),
          ),
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          trailing: trailing,
        ),
      ),
    );
  }
}

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends ConsumerState<NotificationSettingsPage> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(currentUserProfileProvider).maybeWhen(
          data: (data) => data,
          orElse: () => null,
        );
    _enabled = profile?.notificationsEnabled ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Benachrichtigungen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadiusTokens.lg,
                boxShadow: AppShadowTokens.cardShadow,
              ),
              padding: const EdgeInsets.all(AppSpacingTokens.large),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Benachrichtigungen aktivieren', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: AppSpacingTokens.small),
                        const Text('Sie erhalten Check-in-Erinnerungen.'),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _enabled ?? true,
                    onChanged: (value) async {
                      setState(() => _enabled = value);
                      await controller.updateNotifications(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextScalePage extends ConsumerStatefulWidget {
  const TextScalePage({super.key});

  @override
  ConsumerState<TextScalePage> createState() => _TextScalePageState();
}

class _TextScalePageState extends ConsumerState<TextScalePage> {
  double? _selected;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(currentUserProfileProvider).maybeWhen(
          data: (data) => data,
          orElse: () => null,
        );
    _selected = profile?.textScale ?? 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Schriftgröße'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wählen Sie die gewünschte Schriftgröße und bestätigen Sie mit „Übernehmen“.')
                .paddingOnly(bottom: AppSpacingTokens.large),
            RadioListTile<double>(
              value: 1.0,
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value),
              title: const Text('Klein 100 %'),
            ),
            RadioListTile<double>(
              value: 1.5,
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value),
              title: const Text('Mittel 150 %'),
            ),
            RadioListTile<double>(
              value: 2.0,
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value),
              title: const Text('Groß 200 %'),
            ),
            const SizedBox(height: AppSpacingTokens.large),
            PrimaryButton(
              label: 'Übernehmen',
              icon: Icons.check,
              onPressed: () async {
                if (_selected != null) {
                  await controller.updateTextScale(_selected!);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Schriftgröße auf ${(_selected! * 100).round()} % gesetzt.')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSettingsPage extends ConsumerStatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  ConsumerState<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends ConsumerState<LanguageSettingsPage> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(currentUserProfileProvider).maybeWhen(
          data: (data) => data,
          orElse: () => null,
        );
    _selected = profile?.preferredLanguage ?? 'de';
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Sprache ändern'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          children: [
            RadioListTile<String>(
              value: 'de',
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value),
              title: const Text('Deutsch'),
            ),
            RadioListTile<String>(
              value: 'en',
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value),
              title: const Text('Englisch'),
            ),
            RadioListTile<String>(
              value: 'tr',
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value),
              title: const Text('Türkisch'),
            ),
            const SizedBox(height: AppSpacingTokens.large),
            PrimaryButton(
              label: 'Übernehmen',
              icon: Icons.check,
              onPressed: () async {
                if (_selected != null) {
                  await controller.updateLanguage(_selected!);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sprache auf ${_selected!.toUpperCase()} gesetzt.')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InfoHelpPage extends StatelessWidget {
  const InfoHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Info & Hilfe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Version 1.0.0'),
            SizedBox(height: AppSpacingTokens.medium),
            Text('Bei Fragen wenden Sie sich bitte an support@senioren-app.de.'),
          ],
        ),
      ),
    );
  }
}

class PrivacyOverviewPage extends StatelessWidget {
  const PrivacyOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Datenschutz'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        children: [
          _PrivacyTile(title: 'Impressum'),
          _PrivacyTile(title: 'Datenschutz'),
          _PrivacyTile(title: 'Einwilligungen'),
          _PrivacyTile(title: 'Daten & Rechte'),
        ],
      ),
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  const _PrivacyTile({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacingTokens.small),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadiusTokens.lg,
        boxShadow: AppShadowTokens.cardShadow,
      ),
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PrivacyContentPage(title: title),
          ),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      ),
    );
  }
}

class PrivacyContentPage extends StatelessWidget {
  const PrivacyContentPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Text(
          '$title – Dieser Bereich enthält wichtige Informationen. Inhalte werden später ergänzt.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

extension WidgetPaddingOnly on Widget {
  Widget paddingOnly({double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 0),
      child: this,
    );
  }
}
