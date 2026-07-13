import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/util/remove_ads_purchase_service.dart';
import 'package:chess_room/views/components/shared/menu_button.dart';
import 'package:chess_room/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';

class RemoveAdsSection extends StatelessWidget {
  final AppModel appModel;

  const RemoveAdsSection({super.key, required this.appModel});

  @override
  Widget build(BuildContext context) {
    if (!appModel.canPurchaseRemoveAds) {
      return const SizedBox.shrink();
    }

    final service = appModel.purchaseService;
    final status = _statusText(context, service);
    final price = service.localizedPrice;
    final canBuy = !appModel.isAdsRemoved &&
        price != null &&
        service.state != RemoveAdsStoreState.loading &&
        service.state != RemoveAdsStoreState.purchasing &&
        service.state != RemoveAdsStoreState.pending;

    return Column(
      children: [
        TextDefault(S.of(context).Remove_Ads_Description),
        const SizedBox(height: AppSpacing.lg),
        if (appModel.isAdsRemoved)
          TextDefault(
            S.of(context).Remove_Ads_Purchased,
            color: AppColors.accent,
          )
        else
          MenuButton(
            label: price == null
                ? S.of(context).Remove_Ads
                : S.of(context).Remove_Ads_With_Price(price),
            onTap: canBuy ? service.buyRemoveAds : null,
          ),
        const SizedBox(height: AppSpacing.md),
        MenuButton(
          label: S.of(context).Restore_Purchases,
          onTap: service.state == RemoveAdsStoreState.loading ||
                  service.state == RemoveAdsStoreState.purchasing ||
                  service.state == RemoveAdsStoreState.pending
              ? null
              : service.restorePurchases,
        ),
        if (status != null) ...[
          const SizedBox(height: AppSpacing.md),
          TextDefault(status),
        ],
      ],
    );
  }

  String? _statusText(BuildContext context, RemoveAdsPurchaseService service) {
    final strings = S.of(context);
    if (appModel.isAdsRemoved) {
      return strings.Remove_Ads_Purchased;
    }

    switch (service.state) {
      case RemoveAdsStoreState.idle:
        return null;
      case RemoveAdsStoreState.loading:
        return strings.Remove_Ads_Loading;
      case RemoveAdsStoreState.available:
        return null;
      case RemoveAdsStoreState.unavailable:
        return strings.Remove_Ads_Unavailable;
      case RemoveAdsStoreState.purchasing:
        return strings.Purchase_In_Progress;
      case RemoveAdsStoreState.pending:
        return strings.Purchase_Pending;
      case RemoveAdsStoreState.purchased:
        return strings.Purchase_Success;
      case RemoveAdsStoreState.restored:
        return strings.Purchase_Restored;
      case RemoveAdsStoreState.cancelled:
        return strings.Purchase_Cancelled;
      case RemoveAdsStoreState.failed:
        return strings.Purchase_Failed;
      case RemoveAdsStoreState.restoreEmpty:
        return strings.Restore_Not_Found;
    }
  }
}
