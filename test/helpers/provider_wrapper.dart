import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

extension ProviderScopePump on WidgetTester {
  Future<void> pumpWidgetWithProviderScope(
    Widget child, {
    List<Override>? overrides,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides ?? const [],
        child: MaterialApp(home: child),
      ),
    );
    await pumpAndSettle();
  }
}
