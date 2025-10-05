import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../theme/tokens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.gradient,
    this.backgroundColor,
    this.semanticLabel,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Gradient? gradient;
  final Color? backgroundColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? backgroundColor ?? AppColorTokens.surface : null,
        borderRadius: AppRadiusTokens.lg,
        boxShadow: AppShadowTokens.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: AppSpacingTokens.small),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      label: semanticLabel ?? '$title – $subtitle',
      button: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppConstants.minTapTarget * 2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadiusTokens.lg,
            onTap: onTap,
            child: card,
          ),
        ),
      ),
    );
  }
}
