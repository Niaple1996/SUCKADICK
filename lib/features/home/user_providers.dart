import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/auth_providers.dart';
import '../../theme/app_theme.dart';

final currentUserProfileProvider = StreamProvider<UserProfile>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) {
      final uid = user?.uid ?? 'demo';
      return ref.watch(userRepositoryProvider).watchProfile(uid);
    },
    error: (_, __) => Stream.value(
      const UserProfile(
        uid: 'demo',
        displayName: 'Gast',
        preferredLanguage: 'de',
        textScale: 1.0,
        notificationsEnabled: true,
      ),
    ),
    loading: () => Stream.value(
      const UserProfile(
        uid: 'loading',
        displayName: 'Gast',
        preferredLanguage: 'de',
        textScale: 1.0,
        notificationsEnabled: true,
      ),
    ),
  );
});

final userTextScaleProvider = Provider<double>((ref) {
  final profile = ref.watch(currentUserProfileProvider).maybeWhen(
        data: (data) => data.textScale,
        orElse: () => 1.0,
      );
  ref.read(textScaleProvider.notifier).state = profile;
  return profile;
});
