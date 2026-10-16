import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';

/// The fastest routes back into a match or today's practice.
class HomePlayActions extends StatelessWidget {
  final bool hasSavedGame;
  final bool isLoading;
  final bool solvedToday;
  final int streak;
  final VoidCallback? onContinue;
  final VoidCallback? onQuickPlay;
  final VoidCallback? onDailyPuzzle;

  const HomePlayActions({
    super.key,
    required this.hasSavedGame,
    required this.solvedToday,
    required this.streak,
    required this.onContinue,
    required this.onQuickPlay,
    required this.onDailyPuzzle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasSavedGame) ...[
            _HomeAction(
              key: const ValueKey('continue-game-button'),
              label: strings.Continue_Game,
              detail: strings.Continue_Game_Description,
              onPressed: isLoading ? null : onContinue,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          _HomeAction(
            key: const ValueKey('quick-play-button'),
            label: strings.Quick_Play,
            detail: strings.Quick_Play_Description,
            onPressed: isLoading ? null : onQuickPlay,
          ),
          const SizedBox(height: AppSpacing.lg),
          _HomeAction(
            key: const ValueKey('daily-puzzle-button'),
            label: strings.Daily_Puzzle,
            detail: solvedToday
                ? strings.Daily_Practice_Complete
                : strings.Daily_Practice_Ready,
            onPressed: isLoading ? null : onDailyPuzzle,
            trailingDetail: streak > 0 ? strings.Puzzle_Streak(streak) : null,
          ),
          if (isLoading) ...[
            const SizedBox(height: AppSpacing.md),
            const Center(child: CupertinoActivityIndicator()),
          ],
        ],
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  final String label;
  final String detail;
  final String? trailingDetail;
  final VoidCallback? onPressed;

  const _HomeAction({
    super.key,
    required this.label,
    required this.detail,
    required this.onPressed,
    this.trailingDetail,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      color: AppColors.accent,
      disabledColor: AppColors.accent.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.onAccent,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            detail,
            textAlign: TextAlign.center,
            style:
                const TextStyle(color: AppColors.onAccentDetail, fontSize: 14),
          ),
          if (trailingDetail != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              trailingDetail!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onAccentDetail,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
