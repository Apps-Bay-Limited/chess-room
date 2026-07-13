import 'package:chess_room/util/ads_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    AdsManager.isInitialized.value = false;
    AdsManager.isAdsRemoved.value = false;
    AdsManager.isPurchaseFlowActive.value = false;
    AdsManager.disableAllAdsForScreenshot = false;
  });

  test('canRequestAds is false when Remove Ads entitlement is active', () {
    AdsManager.isInitialized.value = true;

    AdsManager.setAdsRemoved(true);

    expect(AdsManager.canRequestAds, isFalse);
  });

  test('canRequestAds remains true for non-purchased users after ads init', () {
    AdsManager.isInitialized.value = true;

    AdsManager.setAdsRemoved(false);

    expect(AdsManager.canRequestAds, isTrue);
  });

  test('canRequestAds is false while a purchase flow is active', () {
    AdsManager.isInitialized.value = true;
    AdsManager.setAdsRemoved(false);

    AdsManager.setPurchaseFlowActive(true);

    expect(AdsManager.canRequestAds, isFalse);
  });
}
