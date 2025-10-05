import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('de'));

final localizationDelegates = <LocalizationsDelegate<dynamic>>[
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

final supportedLocales = const [
  Locale('de'),
  Locale('en'),
  Locale('tr'),
];
