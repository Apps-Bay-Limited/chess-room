import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/ads_manager.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/util/premium.dart';
import 'package:chess_room/util/premium_purchase_service.dart';
import 'package:chess_room/views/components/shared/menu_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// Opens the upgrade sheet for the feature the player just reached for.
/// Returns once the sheet closes; the entitlement itself is observed through
/// [AppModel], so callers re-read `premiumAccess` rather than this result.
Future<void> showPremiumPaywall(
  BuildContext context, {
  required PremiumFeature feature,
}) {
  final appModel = Provider.of<AppModel>(context, listen: false);
  if (!appModel.canPurchasePremium) {
    // Without a reachable store there is nothing to offer, so a locked tap
    // must not open a sheet whose only button cannot work.
    return Future<void>.value();
  }

  return showCupertinoModalPopup<void>(
    context: context,
    builder: (_) => ChangeNotifierProvider<AppModel>.value(
      value: appModel,
      child: PremiumPaywall(feature: feature),
    ),
  );
}

/// The upgrade sheet. Also usable directly by previews and widget tests.
class PremiumPaywall extends StatelessWidget {
  final PremiumFeature feature;

  const PremiumPaywall({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        final service = appModel.purchaseService;
        final price = service.localizedPrice;
        final canBuy = !appModel.isPremium &&
            price != null &&
            !service.isStoreFlowActive;

        return Container(
          key: const ValueKey('premium-paywall'),
          padding: const EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: AppSpacing.xxl,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.sparkles,
                          color: AppColors.accent, size: 24),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          strings.Premium,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _lockedReason(strings, feature),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    strings.Premium_Description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (final benefit in premiumBenefits(strings))
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _Benefit(benefit),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  if (!appModel.isPremium)
                    MenuButton(
                      key: const ValueKey('premium-paywall-buy'),
                      label: price == null
                          ? strings.Premium_Unlock
                          : strings.Premium_Unlock_With_Price(price),
                      onTap: canBuy ? service.buyPremium : null,
                    ),
                  CupertinoButton(
                    key: const ValueKey('premium-paywall-restore'),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    onPressed:
                        service.isStoreFlowActive ? null : service.restorePurchases,
                    child: Text(
                      strings.Restore_Purchases,
                      style: const TextStyle(
                          color: AppColors.accent, fontSize: 15),
                    ),
                  ),
                  if (premiumStatusText(strings, appModel) case final status?)
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appModel.isPremium
                              ? AppColors.success
                              : AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  CupertinoButton(
                    key: const ValueKey('premium-paywall-dismiss'),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      appModel.isPremium ? strings.Done : strings.Not_Now,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Benefit extends StatelessWidget {
  final String label;

  const _Benefit(this.label);

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(CupertinoIcons.check_mark_circled,
                color: AppColors.success, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                height: 1.35,
              ),
            ),
          ),
        ],
      );
}

/// The benefit list shared by the paywall and the Settings section. The ad-free
/// line is left out where no ads are served, so the Mac build does not promise
/// to remove something it never shows. The last line names the reach the
/// player's own store gives: the App Store sells one purchase across iPhone,
/// iPad and Mac, while a Play purchase follows the Google Play account.
List<String> premiumBenefits(S strings) => [
      strings.Premium_Benefit_Themes,
      strings.Premium_Benefit_Training,
      strings.Premium_Benefit_Review,
      strings.Premium_Benefit_History,
      if (AdsManager.isSupportedPlatform) strings.Premium_Benefit_No_Ads,
      if (isPlayBillingPlatform)
        strings.Premium_Benefit_Play
      else
        strings.Premium_Benefit_Shared,
    ];

/// The one-line store status shared by the paywall and the Settings section.
String? premiumStatusText(S strings, AppModel appModel) {
  if (appModel.isPremium) return strings.Premium_Active;

  return switch (appModel.purchaseService.state) {
    PremiumStoreState.idle => null,
    PremiumStoreState.available => null,
    PremiumStoreState.loading => strings.Premium_Loading,
    PremiumStoreState.unavailable => strings.Premium_Unavailable,
    PremiumStoreState.purchasing => strings.Purchase_In_Progress,
    PremiumStoreState.pending => strings.Purchase_Pending,
    PremiumStoreState.purchased => strings.Purchase_Success,
    PremiumStoreState.restored => strings.Purchase_Restored,
    PremiumStoreState.cancelled => strings.Purchase_Cancelled,
    PremiumStoreState.failed => strings.Purchase_Failed,
    PremiumStoreState.restoreEmpty => strings.Restore_Not_Found,
  };
}

String _lockedReason(S strings, PremiumFeature feature) => switch (feature) {
      PremiumFeature.libraryPuzzles => strings.Premium_Puzzles_Spent,
      PremiumFeature.gameReview => strings.Premium_Reviews_Spent,
      PremiumFeature.openingCourses => strings.Premium_Locked_Opening,
      PremiumFeature.pieceTheme => strings.Premium_Locked_Piece_Theme,
      PremiumFeature.boardTheme => strings.Premium_Locked_Board_Theme,
      PremiumFeature.gameHistory => strings.Premium_Benefit_History,
    };
