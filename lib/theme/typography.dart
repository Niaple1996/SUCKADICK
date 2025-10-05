import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

/// Application typography using Roboto like reference screens.
class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(double scale) {
    final base = GoogleFonts.robotoTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 32 * scale,
        fontWeight: FontWeight.w700,
        color: AppColorTokens.textPrimary,
        height: 1.4,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 22 * scale,
        fontWeight: FontWeight.w600,
        color: AppColorTokens.textPrimary,
        height: 1.4,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 24 * scale,
        fontWeight: FontWeight.w700,
        color: AppColorTokens.textPrimary,
        height: 1.4,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 20 * scale,
        fontWeight: FontWeight.w600,
        color: AppColorTokens.textPrimary,
        height: 1.5,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 18 * scale,
        fontWeight: FontWeight.w500,
        color: AppColorTokens.textSecondary,
        height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w400,
        color: AppColorTokens.textSecondary,
        height: 1.5,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 18 * scale,
        fontWeight: FontWeight.w700,
        color: AppColorTokens.surface,
        height: 1.4,
        letterSpacing: 0.2,
      ),
    );
  }
}
