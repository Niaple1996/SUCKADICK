import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../theme/tokens.dart';

class RadioTileLarge<T> extends StatelessWidget {
  const RadioTileLarge({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: subtitle != null ? '$label, $subtitle' : label,
      selected: _isSelected,
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacingTokens.small / 2),
        child: InkWell(
          borderRadius: AppRadiusTokens.lg,
          onTap: () => onChanged(value),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadiusTokens.lg,
              boxShadow: _isSelected ? AppShadowTokens.pressedShadow : AppShadowTokens.cardShadow,
              border: Border.all(
                color: _isSelected ? AppColorTokens.primary : Colors.transparent,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(AppSpacingTokens.large),
            child: Row(
              children: [
                Icon(
                  _isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: _isSelected ? AppColorTokens.primary : AppColorTokens.textSecondary,
                  size: 28,
                ),
                const SizedBox(width: AppSpacingTokens.large),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColorTokens.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacingTokens.xSmall),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
