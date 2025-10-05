import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'buttons.dart';

Future<void> showWarningModal({
  required BuildContext context,
  required String title,
  required String body,
  required String primaryText,
  required VoidCallback onPrimary,
  required String secondaryText,
  required VoidCallback onSecondary,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.lg),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: AppColorTokens.warning, size: 36),
            const SizedBox(width: AppSpacingTokens.medium),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: Text(
          body,
          style: theme.textTheme.bodyMedium,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: AppSpacingTokens.large, vertical: AppSpacingTokens.medium),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          SecondaryButton(label: secondaryText, onPressed: () {
            Navigator.of(context).pop();
            onSecondary();
          }),
          DestructiveButton(label: primaryText, onPressed: () {
            Navigator.of(context).pop();
            onPrimary();
          }),
        ],
      );
    },
  );
}
