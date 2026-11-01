import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/app_themes.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/util/premium.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/views/components/premium/premium_paywall.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flutter/cupertino.dart';

/// Board and piece-set pickers. Premium entries stay visible with a lock, so a
/// free player can see what the upgrade adds instead of a shorter list.
class AppearanceSection extends StatelessWidget {
  final AppModel appModel;

  const AppearanceSection({super.key, required this.appModel});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final access = appModel.premiumAccess;
    final themes = themeList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ThemeRow(
          key: const ValueKey('board-theme-picker'),
          label: strings.Board_Theme,
          options: [
            for (var index = 0; index < themes.length; index++)
              _ThemeOption(
                id: themes[index].name,
                label: themes[index].name,
                selected: themes[index].name == appModel.themeName,
                unlocked: access.isBoardThemeUnlocked(themes[index].name),
                swatch: themes[index].darkTile,
                onSelected: () => appModel.setTheme(index),
              ),
          ],
          feature: PremiumFeature.boardTheme,
        ),
        const SizedBox(height: AppSpacing.lg),
        _ThemeRow(
          key: const ValueKey('piece-set-picker'),
          label: strings.Piece_Set,
          options: [
            for (var index = 0; index < appModel.pieceThemes.length; index++)
              _ThemeOption(
                id: appModel.pieceThemes[index],
                label: appModel.pieceThemes[index],
                selected: appModel.pieceThemes[index] == appModel.pieceTheme,
                unlocked:
                    access.isPieceThemeUnlocked(appModel.pieceThemes[index]),
                swatch: AppColors.accent,
                onSelected: () => appModel.setPieceTheme(index),
              ),
          ],
          feature: PremiumFeature.pieceTheme,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: SizedBox(
            key: const ValueKey('appearance-preview'),
            width: 180,
            // Shows the current board colors and piece set together, so a
            // selection can be judged without leaving Settings.
            child: PositionBoard(
              board: ChessBoard(),
              pieceTheme: appModel.pieceTheme,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeOption {
  final String id;
  final String label;
  final bool selected;
  final bool unlocked;
  final Color swatch;
  final VoidCallback onSelected;

  const _ThemeOption({
    required this.id,
    required this.label,
    required this.selected,
    required this.unlocked,
    required this.swatch,
    required this.onSelected,
  });
}

class _ThemeRow extends StatelessWidget {
  final String label;
  final List<_ThemeOption> options;
  final PremiumFeature feature;

  const _ThemeRow({
    super.key,
    required this.label,
    required this.options,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              for (final option in options) ...[
                _ThemeChip(option: option, feature: feature),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final _ThemeOption option;
  final PremiumFeature feature;

  const _ThemeChip({required this.option, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: option.selected,
      button: true,
      child: CupertinoButton(
        key: ValueKey('theme-option-${option.id}'),
        padding: EdgeInsets.zero,
        minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
        onPressed: option.unlocked
            ? option.onSelected
            : () => showPremiumPaywall(context, feature: feature),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: option.selected
                ? AppColors.accent.withValues(alpha: 0.18)
                : AppColors.background.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color:
                  option.selected ? AppColors.accent : AppColors.divider,
              width: option.selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: option.swatch,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.divider, width: 0.5),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                option.label,
                style: TextStyle(
                  color: option.unlocked
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight:
                      option.selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (!option.unlocked) ...[
                const SizedBox(width: AppSpacing.xs),
                const Icon(CupertinoIcons.lock_fill,
                    size: 13, color: AppColors.accent),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
