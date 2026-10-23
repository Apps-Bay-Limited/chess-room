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
      constraints: const BoxConstraints(maxWidth: 640),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasSavedGame) ...[
            _HomeAction(
              key: const ValueKey('continue-game-button'),
              label: strings.Continue_Game,
              detail: strings.Continue_Game_Description,
              icon: CupertinoIcons.play_fill,
              primary: true,
              onPressed: isLoading ? null : onContinue,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          _HomeAction(
            key: const ValueKey('quick-play-button'),
            label: strings.Quick_Play,
            detail: strings.Quick_Play_Description,
            icon: CupertinoIcons.bolt_fill,
            primary: !hasSavedGame,
            onPressed: isLoading ? null : onQuickPlay,
          ),
          const SizedBox(height: AppSpacing.lg),
          _HomeAction(
            key: const ValueKey('daily-puzzle-button'),
            label: strings.Daily_Puzzle,
            detail: solvedToday
                ? strings.Daily_Practice_Complete
                : strings.Daily_Practice_Ready,
            icon: solvedToday
                ? CupertinoIcons.check_mark_circled
                : CupertinoIcons.calendar,
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
  final IconData icon;
  final bool primary;

  const _HomeAction({
    super.key,
    required this.label,
    required this.detail,
    required this.onPressed,
    required this.icon,
    this.primary = false,
    this.trailingDetail,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = primary ? AppColors.onAccent : AppColors.textPrimary;
    final detailColor =
        primary ? AppColors.onAccentDetail : AppColors.textSecondary;
    return CupertinoButton(
      onPressed: onPressed,
      color: primary ? AppColors.accent : AppColors.surface,
      disabledColor: primary
          ? AppColors.accent.withValues(alpha: 0.45)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primary ? foreground : AppColors.accent,
            size: primary ? 28 : 24,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: foreground,
                    fontSize: primary ? 22 : 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail,
                  style:
                      TextStyle(color: detailColor, fontSize: 14, height: 1.4),
                ),
                if (trailingDetail != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    trailingDetail!,
                    style: TextStyle(
                      color: detailColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(CupertinoIcons.chevron_forward, color: foreground, size: 16),
        ],
      ),
    );
  }
}
