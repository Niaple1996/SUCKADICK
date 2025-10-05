import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/auth_providers.dart';
import '../../services/localization_service.dart';
import '../../theme/app_theme.dart';

final settingsControllerProvider = Provider<SettingsController>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  final auth = ref.watch(authStateChangesProvider).value;
  final uid = auth?.uid ?? 'demo';
  return SettingsController(ref: ref, repository: repository, uid: uid);
});

class SettingsController {
  SettingsController({required Ref ref, required UserRepository repository, required String uid})
      : _ref = ref,
        _repository = repository,
        _uid = uid;

  final Ref _ref;
  final UserRepository _repository;
  final String _uid;

  Future<void> updateNotifications(bool enabled) async {
    final profile = await _currentProfile();
    final updated = profile.copyWith(notificationsEnabled: enabled);
    await _repository.saveProfile(updated);
  }

  Future<void> updateTextScale(double scale) async {
    final profile = await _currentProfile();
    final updated = profile.copyWith(textScale: scale);
    _ref.read(textScaleProvider.notifier).state = scale;
    await _repository.saveProfile(updated);
  }

  Future<void> updateLanguage(String language) async {
    final profile = await _currentProfile();
    final updated = profile.copyWith(preferredLanguage: language);
    _ref.read(localeProvider.notifier).state = Locale(language);
    await _repository.saveProfile(updated);
  }

  Future<UserProfile> _currentProfile() async {
    return _repository.watchProfile(_uid).first;
  }
}
