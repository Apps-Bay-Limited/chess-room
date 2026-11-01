import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/util/premium.dart';
import 'package:chess_room/views/components/premium/premium_paywall.dart';
import 'package:chess_room/views/components/shared/menu_button.dart';
import 'package:flutter/cupertino.dart';

/// The in-place stand-in for content the free tier has run out of, with the
/// one button that opens the upgrade sheet.
class PremiumLockedPanel extends StatelessWidget {
  final String message;
  final PremiumFeature feature;

  const PremiumLockedPanel({
    super.key,
    required this.message,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Container(
      key: const ValueKey('premium-locked-panel'),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.lock_fill,
              size: 32, color: AppColors.accent),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          MenuButton(
            key: const ValueKey('premium-locked-unlock'),
            label: strings.Premium_Unlock,
            onTap: () => showPremiumPaywall(context, feature: feature),
          ),
        ],
      ),
    );
  }
}

/// The "N left today" / "Unlimited with Premium" line shown above a gated
/// practice list.
class PremiumAllowanceLabel extends StatelessWidget {
  final int remaining;
  final bool isPremium;
  final String Function(S strings, int remaining) describeRemaining;

  const PremiumAllowanceLabel({
    super.key,
    required this.remaining,
    required this.isPremium,
    required this.describeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Text(
      isPremium ? strings.Premium_Unlimited : describeRemaining(strings, remaining),
      style: const TextStyle(color: AppColors.accent, fontSize: 14),
    );
  }
}
