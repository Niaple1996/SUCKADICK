import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> loadFonts() async {
  await loadAppFonts();
}

Future<void> pumpGoldenWidget(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Material(child: widget),
    ),
  );
  await tester.pumpAndSettle();
}
