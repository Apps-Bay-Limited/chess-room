import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../../generated/l10n.dart';
import '../../../../util/app_design.dart';

class AIDifficultyPicker extends StatelessWidget {
  final int aiDifficulty;
  final ValueChanged<int?> setFunc;

  const AIDifficultyPicker(this.aiDifficulty, this.setFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final options = {
      1: strings.Easy,
      3: strings.Medium,
      5: strings.Hard,
      6: strings.Extreme,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.AI_Difficulty,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(builder: (context, constraints) {
          final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
          final columns = scale > 1.4 || constraints.maxWidth < 280 ? 1 : 2;
          final width =
              (constraints.maxWidth - AppSpacing.sm * (columns - 1)) / columns;
          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (index, option) in options.entries.indexed)
                SizedBox(
                  width: width,
                  child: Semantics(
                    selected: aiDifficulty == option.key,
                    child: CupertinoButton(
                      key: ValueKey('ai-difficulty-${option.key}'),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (aiDifficulty != option.key) {
                          HapticFeedback.selectionClick();
                        }
                        setFunc(option.key);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: aiDifficulty == option.key
                              ? AppColors.surfaceRaised
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: aiDifficulty == option.key
                                ? AppColors.accent
                                : AppColors.divider,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.value,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ExcludeSemantics(
                              child: Row(
                                children: [
                                  for (var star = 0; star <= index; star++)
                                    const Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(end: 3),
                                      child: Icon(
                                        CupertinoIcons.star_fill,
                                        color: AppColors.accent,
                                        size: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
