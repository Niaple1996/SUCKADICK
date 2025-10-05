import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/checkin_settings.dart';
import '../../data/repositories/checkin_repository.dart';
import '../../services/auth_providers.dart';
import '../../services/checkin_service.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/radio_tile_large.dart';
import '../../widgets/toggle_row_large.dart';
import '../../widgets/warning_modal.dart';

final _checkinSettingsProvider = StreamProvider<CheckinSettings>((ref) {
  final auth = ref.watch(authStateChangesProvider).value;
  final uid = auth?.uid ?? 'demo';
  return ref.watch(checkinRepositoryProvider).watchSettings(uid);
});

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  String _frequency = 'daily';
  bool _enabled = true;
  DateTime? _nextDue;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () {
      final settings = ref.read(_checkinSettingsProvider).maybeWhen(
            data: (data) => data,
            orElse: () => const CheckinSettings(frequency: 'daily', nextDueAt: null, enabled: true),
          );
      _frequency = settings.frequency;
      _enabled = settings.enabled;
      _nextDue = settings.nextDueAt;
    });
  }

  Future<void> _save() async {
    final auth = ref.read(authStateChangesProvider).value;
    final uid = auth?.uid ?? 'demo';
    final service = ref.read(checkinServiceProvider);
    final settings = CheckinSettings(frequency: _frequency, nextDueAt: _nextDue, enabled: _enabled);
    await service.updateSettings(uid: uid, settings: settings);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check-in Einstellungen wurden gespeichert.')),
    );
  }

  void _confirmDisable() {
    showWarningModal(
      context: context,
      title: 'Sind Sie sicher, dass Sie den Check-in deaktivieren möchten?',
      body:
          'Bitte beachten Sie: Der Check-in bleibt dauerhaft deaktiviert. Denken Sie daran, ihn in Zukunft wieder zu aktivieren.',
      primaryText: 'Ja, deaktivieren',
      onPrimary: () {
        setState(() => _enabled = false);
        _save();
      },
      secondaryText: 'Abbrechen',
      onSecondary: () {
        setState(() => _enabled = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncSettings = ref.watch(_checkinSettingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Optionen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: asyncSettings.when(
          data: (settings) {
            _frequency = settings.frequency;
            _enabled = settings.enabled;
            _nextDue = settings.nextDueAt;
            final service = ref.read(checkinServiceProvider);
            final timerLabel = service.timerLabel(settings);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacingTokens.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckinStatusCard(timerLabel: timerLabel),
                  const SizedBox(height: AppSpacingTokens.xLarge),
                  Text('Frequenz', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacingTokens.medium),
                  RadioTileLarge<String>(
                    label: 'Täglich',
                    value: 'daily',
                    groupValue: _frequency,
                    onChanged: (value) => setState(() => _frequency = value ?? 'daily'),
                  ),
                  RadioTileLarge<String>(
                    label: 'Alle 2 Tage',
                    value: '2d',
                    groupValue: _frequency,
                    onChanged: (value) => setState(() => _frequency = value ?? '2d'),
                  ),
                  RadioTileLarge<String>(
                    label: 'Wöchentlich',
                    value: 'weekly',
                    groupValue: _frequency,
                    onChanged: (value) => setState(() => _frequency = value ?? 'weekly'),
                  ),
                  const SizedBox(height: AppSpacingTokens.xLarge),
                  ToggleRowLarge(
                    label: 'Check-in deaktivieren',
                    value: !_enabled,
                    onChanged: (value) {
                      if (value) {
                        _confirmDisable();
                      } else {
                        setState(() => _enabled = true);
                        _save();
                      }
                    },
                    subtitle: 'Deaktiviert Erinnerungen und Planungen.',
                  ),
                  const SizedBox(height: AppSpacingTokens.xLarge),
                  PrimaryButton(
                    label: 'Speichern',
                    icon: Icons.save,
                    onPressed: _save,
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Check-in Daten konnten nicht geladen werden.'),
                  const SizedBox(height: AppSpacingTokens.medium),
                  SecondaryButton(
                    label: 'Erneut versuchen',
                    icon: Icons.refresh,
                    onPressed: () => ref.refresh(_checkinSettingsProvider),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CheckinStatusCard extends StatelessWidget {
  const CheckinStatusCard({super.key, required this.timerLabel});

  final String timerLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacingTokens.large),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3CCB6A), Color(0xFF2EA44F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadiusTokens.lg,
        boxShadow: AppShadowTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 32),
              const SizedBox(width: AppSpacingTokens.medium),
              Text(
                'Check-in',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          Text(
            timerLabel,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
