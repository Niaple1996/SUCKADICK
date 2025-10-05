import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'buttons.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatar,
    required this.onContact,
    this.onTap,
    this.isEmergency = false,
  });

  final String name;
  final String? subtitle;
  final Widget avatar;
  final VoidCallback onContact;
  final VoidCallback? onTap;
  final bool isEmergency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: isEmergency ? '$name, Notfallkontakt' : name,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadiusTokens.lg,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadiusTokens.lg,
            boxShadow: AppShadowTokens.cardShadow,
          ),
          padding: const EdgeInsets.all(AppSpacingTokens.large),
          child: Row(
            children: [
              avatar,
              const SizedBox(width: AppSpacingTokens.large),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        if (isEmergency)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColorTokens.error,
                              borderRadius: AppRadiusTokens.sm,
                            ),
                            child: Text(
                              'SOS',
                              style: theme.textTheme.labelLarge?.copyWith(color: Colors.white, fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacingTokens.small),
                      Text(subtitle!, style: theme.textTheme.bodyMedium),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacingTokens.large),
              SecondaryButton(
                label: 'Kontaktieren',
                icon: Icons.phone,
                onPressed: onContact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
