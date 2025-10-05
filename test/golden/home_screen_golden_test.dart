import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:senioren_app/data/models/user_profile.dart';
import 'package:senioren_app/features/home/home_screen.dart';
import 'package:senioren_app/features/home/user_providers.dart';
import '../helpers/provider_wrapper.dart';
import 'golden_test_utils.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testGoldens('Home screen cards match design', (tester) async {
    await tester.pumpWidgetWithProviderScope(
      const HomeScreen(),
      overrides: [
        currentUserProfileProvider.overrideWith(
          (ref) => Stream.value(
            const UserProfile(
              uid: 'demo',
              displayName: 'Klaus',
              preferredLanguage: 'de',
              textScale: 1.0,
              notificationsEnabled: true,
            ),
          ),
        ),
      ],
    );
    await screenMatchesGolden(tester, 'home_screen');
  });
}
