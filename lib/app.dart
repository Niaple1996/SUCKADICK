import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/contacts/contacts_screen.dart';
import 'features/home/home_screen.dart';
import 'features/settings/settings_screen.dart';
import 'services/localization_service.dart';
import 'theme/app_theme.dart';
import 'widgets/app_bottom_nav.dart';

class SeniorenApp extends ConsumerWidget {
  const SeniorenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final locale = ref.watch(localeProvider);
    return TextScaleWrapper(
      child: MaterialApp(
        title: 'Senioren App',
        theme: theme,
        locale: locale,
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationDelegates,
        home: const _RootScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _RootScaffold extends StatefulWidget {
  const _RootScaffold();

  @override
  State<_RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<_RootScaffold> {
  int _currentIndex = 0;

  final _pages = const [
    HomeScreen(),
    ContactsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
