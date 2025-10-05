import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/stt_service.dart';
import '../../services/tts_service.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';

final assistantMessagesProvider = StateProvider<List<_Message>>((ref) {
  return const [
    _Message(sender: Sender.assistant, text: 'Wie kann ich Ihnen heute helfen?'),
  ];
});

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _controller = TextEditingController();
  bool _isListening = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    final messages = [...ref.read(assistantMessagesProvider), _Message(sender: Sender.user, text: text)];
    ref.read(assistantMessagesProvider.notifier).state = messages;
    _controller.clear();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    ref.read(assistantMessagesProvider.notifier).state = [
      ...messages,
      const _Message(sender: Sender.assistant, text: 'Ich habe Ihre Frage verstanden und melde mich gleich.'),
    ];
  }

  Future<void> _toggleListening() async {
    final stt = ref.read(sttServiceProvider);
    if (_isListening) {
      await stt.stop();
      setState(() => _isListening = false);
      return;
    }
    try {
      await stt.start(onResult: (value) {
        _controller.text = value;
      });
      setState(() => _isListening = true);
    } on StateError {
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Spracherkennung nicht verfügbar'),
          content: const Text('Bitte prüfen Sie die Mikrofonrechte und versuchen Sie es erneut.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(assistantMessagesProvider);
    return Scaffold(
      backgroundColor: AppColorTokens.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Zurück',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Zurück zum Start'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacingTokens.large),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isAssistant = message.sender == Sender.assistant;
                  final alignment = isAssistant ? Alignment.centerLeft : Alignment.centerRight;
                  final color = isAssistant ? Colors.white : AppColorTokens.primary;
                  final textColor = isAssistant ? AppColorTokens.textPrimary : Colors.white;
                  return Align(
                    alignment: alignment,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: AppSpacingTokens.small),
                      padding: const EdgeInsets.all(AppSpacingTokens.medium),
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(24),
                          topRight: const Radius.circular(24),
                          bottomLeft: Radius.circular(isAssistant ? 0 : 24),
                          bottomRight: Radius.circular(isAssistant ? 24 : 0),
                        ),
                        boxShadow: AppShadowTokens.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message.text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor)),
                          if (isAssistant)
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.volume_up, color: AppColorTokens.primary),
                                onPressed: () => ref.read(ttsServiceProvider).speak(message.text),
                                tooltip: 'Vorlesen',
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacingTokens.large),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: AppShadowTokens.cardShadow),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Frage eingeben…',
                    ),
                  ),
                  const SizedBox(height: AppSpacingTokens.medium),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Senden',
                          icon: Icons.send,
                          onPressed: _submit,
                        ),
                      ),
                      const SizedBox(width: AppSpacingTokens.large),
                      Expanded(
                        child: SecondaryButton(
                          label: _isListening ? 'Stoppen' : 'Sprechen',
                          icon: _isListening ? Icons.stop : Icons.mic,
                          onPressed: _toggleListening,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Sender { assistant, user }

class _Message {
  const _Message({required this.sender, required this.text});

  final Sender sender;
  final String text;
}
