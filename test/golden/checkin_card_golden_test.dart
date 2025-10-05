import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:senioren_app/features/checkin/checkin_screen.dart';
import 'golden_test_utils.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testGoldens('Check-in status card layout', (tester) async {
    await pumpGoldenWidget(
      tester,
      const Directionality(
        textDirection: TextDirection.ltr,
        child: CheckinStatusCard(timerLabel: '23:45 Stunden verbleibend'),
      ),
    );
    await screenMatchesGolden(tester, 'checkin_status_card');
  });
}
