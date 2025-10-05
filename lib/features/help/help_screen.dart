import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/help_video.dart';
import '../../data/repositories/help_repository.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';

final helpVideosProvider = StreamProvider<List<HelpVideo>>((ref) {
  return ref.watch(helpRepositoryProvider).watchVideos();
});

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(helpVideosProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Erklärvideos'),
      ),
      body: SafeArea(
        child: videosAsync.when(
          data: (videos) => ListView(
            padding: const EdgeInsets.all(AppSpacingTokens.large),
            children: [
              for (final video in videos)
                _HelpVideoCard(
                  title: video.title,
                  onTap: () => _launchVideo(video.url),
                ),
              const SizedBox(height: AppSpacingTokens.xLarge),
              PrimaryButton(
                label: 'Kontakt & Support',
                icon: Icons.email,
                onPressed: () => _launchVideo('mailto:support@senioren-app.de'),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Die Videos konnten nicht geladen werden.'),
                const SizedBox(height: AppSpacingTokens.medium),
                SecondaryButton(
                  label: 'Erneut versuchen',
                  icon: Icons.refresh,
                  onPressed: () => ref.refresh(helpVideosProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url.isEmpty ? 'https://example.com' : url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Konnte $url nicht öffnen');
    }
  }
}

class _HelpVideoCard extends StatelessWidget {
  const _HelpVideoCard({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title, Video abspielen',
      button: true,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacingTokens.small),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadiusTokens.lg,
          boxShadow: AppShadowTokens.cardShadow,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColorTokens.primary.withOpacity(0.12),
              borderRadius: AppRadiusTokens.md,
            ),
            child: const Icon(Icons.play_arrow, color: AppColorTokens.primary, size: 32),
          ),
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          onTap: onTap,
        ),
      ),
    );
  }
}
