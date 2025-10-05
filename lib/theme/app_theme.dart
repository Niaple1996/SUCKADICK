import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tokens.dart';
import 'typography.dart';

final textScaleProvider = StateProvider<double>((ref) => 1.0);

final appThemeProvider = Provider<ThemeData>((ref) {
  final scale = ref.watch(textScaleProvider);
  final base = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: AppColorTokens.primary,
      primaryContainer: AppColorTokens.primary,
      secondary: AppColorTokens.success,
      secondaryContainer: AppColorTokens.success,
      tertiary: AppColorTokens.warning,
      tertiaryContainer: AppColorTokens.warning,
    ),
    surface: AppColorTokens.surface,
    background: AppColorTokens.background,
    appBarStyle: FlexAppBarStyle.primary,
    useMaterial3: true,
    subThemesData: const FlexSubThemesData(
      defaultRadius: 24,
      elevatedButtonRadius: 24,
      outlinedButtonRadius: 24,
      inputDecoratorRadius: 24,
      bottomSheetRadius: 28,
    ),
    visualDensity: VisualDensity.standard,
  ).copyWith(
    scaffoldBackgroundColor: AppColorTokens.background,
    textTheme: AppTypography.textTheme(scale),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorTokens.primary,
      primary: AppColorTokens.primary,
      background: AppColorTokens.background,
      surface: AppColorTokens.surface,
      secondary: AppColorTokens.success,
      error: AppColorTokens.error,
      brightness: Brightness.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(200, 56)),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadiusTokens.lg),
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColorTokens.primary.withOpacity(0.4);
          }
          return AppColorTokens.primary;
        }),
        foregroundColor: MaterialStateProperty.all(AppColorTokens.surface),
        overlayColor: MaterialStateProperty.all(
          AppColorTokens.primary.withOpacity(0.12),
        ),
        elevation: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return 12;
          }
          return 8;
        }),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorTokens.primary,
        textStyle: AppTypography.textTheme(scale).labelLarge,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(color: Color(0xFFCFD8E5)),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    ),
  );

  return base.copyWith(
    visualDensity: VisualDensity.standard,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
});

class TextScaleWrapper extends ConsumerWidget {
  const TextScaleWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scale = ref.watch(textScaleProvider);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}
