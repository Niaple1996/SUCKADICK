import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';

Future<bool?> showEmergencyConfirmation(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.lg),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: AppColorTokens.error, size: 40),
            const SizedBox(width: AppSpacingTokens.medium),
            Expanded(
              child: Text('Sind Sie sicher, dass Sie einen Notfall melden wollen?',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        content: const Text(
          'Ihre Kontakte werden informiert. Dies ersetzt keinen Notruf.',
        ),
        actions: [
          SecondaryButton(
            label: 'Abbrechen',
            icon: Icons.close,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          DestructiveButton(
            label: 'Ja, Notfall melden',
            icon: Icons.warning,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
}

Future<void> showEmergencySent(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.lg),
        title: Text('Notfall wurde gemeldet', style: Theme.of(context).textTheme.titleLarge),
        content: const Text('Ihre Kontakte wurden informiert. Dies ersetzt keinen Notruf. Wählen Sie im Ernstfall die 112.'),
        actions: [
          PrimaryButton(
            label: 'OK',
            icon: Icons.check,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
