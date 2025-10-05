import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:senioren_app/widgets/app_bottom_nav.dart';
import 'golden_test_utils.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testGoldens('Bottom navigation renders labels', (tester) async {
    await pumpGoldenWidget(
      tester,
      Directionality(
        textDirection: TextDirection.ltr,
        child: AppBottomNavigationBar(
          currentIndex: 0,
          onTap: (_) {},
        ),
      ),
    );
    await screenMatchesGolden(tester, 'bottom_navigation');
  });
}
