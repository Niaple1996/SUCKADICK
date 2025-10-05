import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class ToggleRowLarge extends StatelessWidget {
  const ToggleRowLarge({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadiusTokens.lg,
        boxShadow: AppShadowTokens.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSpacingTokens.large),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacingTokens.small),
                  Text(subtitle!, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColorTokens.primary,
          ),
        ],
      ),
    );
  }
}
