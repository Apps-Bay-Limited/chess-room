import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';

class SettingsNavigationButtons extends StatelessWidget {
  final VoidCallback onHowToPlay;
  final VoidCallback onGameHistory;
  final VoidCallback onPrivacyChoices;
  final VoidCallback onMoreApps;
  final VoidCallback onBack;
  final bool showPrivacyChoices;
  final bool showBackButton;

  const SettingsNavigationButtons({
    super.key,
    required this.onHowToPlay,
    required this.onGameHistory,
    required this.onPrivacyChoices,
    required this.onMoreApps,
    required this.onBack,
    required this.showPrivacyChoices,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Column(
      children: [
        _SettingsLink(
          key: const ValueKey('settings-how-to-play-button'),
          label: strings.How_To_Play_Chess,
          icon: CupertinoIcons.question_circle,
          onTap: onHowToPlay,
        ),
        _SettingsLink(
          key: const ValueKey('settings-game-history-button'),
          label: strings.Game_History,
          icon: CupertinoIcons.clock,
          onTap: onGameHistory,
        ),
        if (showPrivacyChoices) ...[
          _SettingsLink(
            key: const ValueKey('settings-privacy-choices-button'),
            label: strings.Privacy_Choices,
            icon: CupertinoIcons.lock_shield,
            onTap: onPrivacyChoices,
          ),
        ],
        _SettingsLink(
          key: const ValueKey('settings-more-apps-button'),
          label: strings.More_Apps,
          icon: CupertinoIcons.square_grid_2x2,
          onTap: onMoreApps,
        ),
        if (showBackButton)
          _SettingsLink(
            key: const ValueKey('settings-back-button'),
            label: strings.Back,
            icon: CupertinoIcons.back,
            onTap: onBack,
          ),
      ],
    );
  }
}

class _SettingsLink extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsLink({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            CupertinoIcons.chevron_forward,
            size: 15,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
