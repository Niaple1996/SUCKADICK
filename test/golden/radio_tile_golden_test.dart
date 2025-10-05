import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:senioren_app/widgets/radio_tile_large.dart';
import 'golden_test_utils.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testGoldens('Radio tile large states', (tester) async {
    await pumpGoldenWidget(
      tester,
      Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioTileLarge<String>(
              label: 'Täglich',
              value: 'daily',
              groupValue: 'daily',
              onChanged: (_) {},
            ),
            RadioTileLarge<String>(
              label: 'Wöchentlich',
              value: 'weekly',
              groupValue: 'daily',
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
    await screenMatchesGolden(tester, 'radio_tile_large');
  });
}
