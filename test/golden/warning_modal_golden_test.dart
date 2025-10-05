import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:senioren_app/widgets/warning_modal.dart';
import 'golden_test_utils.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testGoldens('Warning modal visual', (tester) async {
    await pumpGoldenWidget(
      tester,
      Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              showWarningModal(
                context: context,
                title: 'Warnung',
                body: 'Sind Sie sicher?',
                primaryText: 'Ja, deaktivieren',
                onPrimary: () {},
                secondaryText: 'Abbrechen',
                onSecondary: () {},
              );
            },
            child: const Text('Open'),
          );
        },
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'warning_modal');
  });
}
