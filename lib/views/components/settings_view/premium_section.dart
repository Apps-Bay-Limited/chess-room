import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/premium/premium_paywall.dart';
import 'package:chess_room/views/components/shared/menu_button.dart';
import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';

/// The Settings entry point for the shared premium purchase. The same product
/// backs the iOS and macOS builds, so this section offers both Buy and Restore
/// wherever StoreKit is reachable.
class PremiumSection extends StatelessWidget {
  final AppModel appModel;

  const PremiumSection({super.key, required this.appModel});

  @override
  Widget build(BuildContext context) {
    if (!appModel.canPurchasePremium) {
      return const SizedBox.shrink();
    }

    final strings = S.of(context);
    final service = appModel.purchaseService;
    final status = premiumStatusText(strings, appModel);
    final price = service.localizedPrice;
    final canBuy =
        !appModel.isPremium && price != null && !service.isStoreFlowActive;

    return Container(
      key: const ValueKey('premium-section'),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.sparkles,
                  color: AppColors.accent, size: 22),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  strings.Premium,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            strings.Premium_Description,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14, height: 1.4),
          ),
          if (!appModel.isPremium) ...[
            const SizedBox(height: AppSpacing.lg),
            for (final benefit in premiumBenefits(strings))
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(CupertinoIcons.check_mark_circled,
                          color: AppColors.success, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        benefit,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (!appModel.isPremium)
            MenuButton(
              key: const ValueKey('premium-buy-button'),
              label: price == null
                  ? strings.Premium_Unlock
                  : strings.Premium_Unlock_With_Price(price),
              onTap: canBuy ? service.buyPremium : null,
            ),
          const SizedBox(height: AppSpacing.md),
          CupertinoButton(
            key: const ValueKey('premium-restore-button'),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            onPressed:
                service.isStoreFlowActive ? null : service.restorePurchases,
            child: Text(
              strings.Restore_Purchases,
              style: const TextStyle(color: AppColors.accent, fontSize: 15),
            ),
          ),
          if (status != null) ...[
            const SizedBox(height: AppSpacing.md),
            Semantics(
              liveRegion: true,
              child: Text(
                status,
                style: TextStyle(
                  color: appModel.isPremium
                      ? AppColors.success
                      : AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
