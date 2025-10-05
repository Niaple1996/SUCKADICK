import 'package:flutter/material.dart';

/// Global design tokens derived from reference screens.
@immutable
class AppColorTokens {
  const AppColorTokens();

  static const Color primary = Color(0xFF1976D2);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E8AF6), Color(0xFF1B6DE0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color success = Color(0xFF2EA44F);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFD32F2F);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7FA);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF445066);
  static const Color shadowColor = Color(0x1F000000);
}

@immutable
class AppRadiusTokens {
  const AppRadiusTokens();

  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius md = BorderRadius.all(Radius.circular(16));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(24));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(28));
}

@immutable
class AppSpacingTokens {
  const AppSpacingTokens();

  static const double xSmall = 8;
  static const double small = 12;
  static const double medium = 16;
  static const double large = 24;
  static const double xLarge = 32;
}

@immutable
class AppShadowTokens {
  const AppShadowTokens();

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color.fromRGBO(17, 17, 17, 0.16),
      blurRadius: 32,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> pressedShadow = [
    BoxShadow(
      color: Color.fromRGBO(17, 17, 17, 0.22),
      blurRadius: 40,
      offset: Offset(0, 16),
      spreadRadius: 0,
    ),
  ];
}
