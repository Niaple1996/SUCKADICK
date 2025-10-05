import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:senioren_app/theme/app_theme.dart';
import 'package:senioren_app/services/localization_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('text scale updates live', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: _TestApp(),
      ),
    );
    await tester.pumpAndSettle();

    Text textWidget = tester.widget(find.text('Probe')); 
    final initialFontSize = textWidget.style?.fontSize ?? 0;

    final container = ProviderScope.containerOf(tester.element(find.byType(_TestApp)));
    container.read(textScaleProvider.notifier).state = 2.0;
    await tester.pumpAndSettle();

    textWidget = tester.widget(find.text('Probe'));
    final updatedFontSize = textWidget.style?.fontSize ?? 0;
    expect(updatedFontSize, greaterThan(initialFontSize));
  });

  testWidgets('locale provider updates MaterialApp locale', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: _TestApp(),
      ),
    );
    await tester.pumpAndSettle();

    final scopeContext = tester.element(find.byType(_TestApp));
    final container = ProviderScope.containerOf(scopeContext);
    container.read(localeProvider.notifier).state = const Locale('en');
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.locale?.languageCode, 'en');
  });
}

class _TestApp extends ConsumerWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return TextScaleWrapper(
      child: MaterialApp(
        locale: locale,
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationDelegates,
        home: Scaffold(
          body: Center(
            child: Text('Probe', style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      ),
    );
  }
}
