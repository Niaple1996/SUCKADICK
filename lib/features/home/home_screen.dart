import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../theme/tokens.dart';
import '../../widgets/app_card.dart';
import '../assistant/assistant_screen.dart';
import '../checkin/checkin_screen.dart';
import '../help/help_screen.dart';
import 'user_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    return profileAsync.when(
      data: (profile) => _HomeContent(name: profile.displayName),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Profil konnte nicht geladen werden.')),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacingTokens.large, vertical: AppSpacingTokens.xLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Willkommen, $name 👋', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacingTokens.small),
          Text('Schön, dass Sie da sind!', style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacingTokens.xLarge),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GridView.count(
                  crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                  mainAxisSpacing: AppSpacingTokens.large,
                  crossAxisSpacing: AppSpacingTokens.large,
                  childAspectRatio: 0.9,
                  children: [
                    AppCard(
                      icon: MdiIcons.robot,
                      title: 'Assistent',
                      subtitle: 'Fragen oder sprechen',
                      gradient: AppColorTokens.primaryGradient,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AssistantScreen()),
                      ),
                    ),
                    AppCard(
                      icon: Icons.check_circle,
                      title: 'Check-in Optionen',
                      subtitle: 'Passen Sie Einstellungen an',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3CCB6A), Color(0xFF2EA44F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CheckinScreen()),
                      ),
                    ),
                    AppCard(
                      icon: Icons.help_outline,
                      title: 'Hilfe',
                      subtitle: 'Erklärvideos',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFA83E), Color(0xFF8349FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HelpScreen()),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
