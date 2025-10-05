import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../theme/tokens.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      context,
      label,
      onPressed,
      backgroundColor: AppColorTokens.primary,
      foregroundColor: Colors.white,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      context,
      label,
      onPressed,
      backgroundColor: Colors.white,
      foregroundColor: AppColorTokens.primary,
      icon: icon,
      semanticLabel: semanticLabel,
      border: BorderSide(color: AppColorTokens.primary.withOpacity(0.4), width: 2),
    );
  }
}

class DestructiveButton extends StatelessWidget {
  const DestructiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      context,
      label,
      onPressed,
      backgroundColor: AppColorTokens.error,
      foregroundColor: Colors.white,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}

Widget _buildButton(
  BuildContext context,
  String label,
  VoidCallback? onPressed, {
  required Color backgroundColor,
  required Color foregroundColor,
  IconData? icon,
  String? semanticLabel,
  BorderSide? border,
}) {
  final theme = Theme.of(context);
  return Semantics(
    label: semanticLabel ?? label,
    button: true,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppConstants.minTapTarget * 1.2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.lg, side: border ?? BorderSide.none),
          shadowColor: AppColorTokens.shadowColor,
          elevation: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24),
              const SizedBox(width: AppSpacingTokens.small),
            ],
            Text(
              label,
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    ),
  );
}
