import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/views/components/shared/menu_button.dart';
import 'package:flutter/cupertino.dart';

class SettingsNavigationButtons extends StatelessWidget {
  final VoidCallback onHowToPlay;
  final VoidCallback onGameHistory;
  final VoidCallback onPrivacyChoices;
  final VoidCallback onMoreApps;
  final VoidCallback onBack;
  final bool showPrivacyChoices;

  const SettingsNavigationButtons({
    super.key,
    required this.onHowToPlay,
    required this.onGameHistory,
    required this.onPrivacyChoices,
    required this.onMoreApps,
    required this.onBack,
    required this.showPrivacyChoices,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Column(
      children: [
        MenuButton(
          key: const ValueKey('settings-how-to-play-button'),
          label: strings.How_To_Play_Chess,
          onTap: onHowToPlay,
        ),
        const SizedBox(height: 20),
        MenuButton(
          key: const ValueKey('settings-game-history-button'),
          label: strings.Game_History,
          onTap: onGameHistory,
        ),
        if (showPrivacyChoices) ...[
          const SizedBox(height: 20),
          MenuButton(
            key: const ValueKey('settings-privacy-choices-button'),
            label: strings.Privacy_Choices,
            onTap: onPrivacyChoices,
          ),
        ],
        const SizedBox(height: 20),
        MenuButton(
          key: const ValueKey('settings-more-apps-button'),
          label: strings.More_Apps,
          onTap: onMoreApps,
        ),
        const SizedBox(height: 20),
        MenuButton(
          key: const ValueKey('settings-back-button'),
          label: strings.Back,
          onTap: onBack,
        ),
      ],
    );
  }
}
