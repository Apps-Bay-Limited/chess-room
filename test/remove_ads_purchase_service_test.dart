import 'dart:async';

import 'package:chess_room/util/remove_ads_purchase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FakeRemoveAdsStore store;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    store = FakeRemoveAdsStore();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    store.dispose();
  });

  test('loads the Remove Ads product and exposes the localized price',
      () async {
    final service = RemoveAdsPurchaseService(store: store);

    await service.init();

    expect(store.queriedProductIds, contains(removeAdsProductId));
    expect(service.localizedPrice, r'$2.99');
    expect(service.state, RemoveAdsStoreState.available);

    service.dispose();
  });

  test('purchase grants and persists the remove ads entitlement', () async {
    final service = RemoveAdsPurchaseService(store: store);

    await service.init();
    await service.buyRemoveAds();
    await Future<void>.delayed(Duration.zero);

    final prefs = await SharedPreferences.getInstance();
    expect(service.isAdsRemoved, isTrue);
    expect(prefs.getBool(removeAdsEntitlementKey), isTrue);
    expect(store.completedPurchaseCount, 1);

    service.dispose();
  });

  test('purchase flow is active while purchase is pending', () async {
    store.emitPurchaseOnBuy = false;
    final service = RemoveAdsPurchaseService(store: store);

    await service.init();
    await service.buyRemoveAds();

    expect(service.state, RemoveAdsStoreState.purchasing);
    expect(service.isStoreFlowActive, isTrue);

    store.addPurchase(PurchaseStatus.canceled);
    await Future<void>.delayed(Duration.zero);

    expect(service.state, RemoveAdsStoreState.cancelled);
    expect(service.isStoreFlowActive, isFalse);

    service.dispose();
  });

  test('restore reports when no Remove Ads purchase is found', () async {
    final service = RemoveAdsPurchaseService(store: store);

    await service.init();
    await service.restorePurchases();

    expect(service.isAdsRemoved, isFalse);
    expect(service.state, RemoveAdsStoreState.restoreEmpty);

    service.dispose();
  });

  test('Android does not query products or expose purchase support', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final service = RemoveAdsPurchaseService(store: store);

    await service.init();

    expect(service.isSupported, isFalse);
    expect(store.queriedProductIds, isEmpty);
    expect(service.localizedPrice, isNull);

    service.dispose();
  });
}

class FakeRemoveAdsStore implements RemoveAdsStore {
  final StreamController<List<PurchaseDetails>> _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  final Set<String> queriedProductIds = <String>{};
  bool available = true;
  bool emitPurchaseOnBuy = true;
  int completedPurchaseCount = 0;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _purchaseController.stream;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
      Set<String> productIds) async {
    queriedProductIds.addAll(productIds);
    return ProductDetailsResponse(
      productDetails: <ProductDetails>[
        ProductDetails(
          id: removeAdsProductId,
          title: 'Remove Ads',
          description: 'Remove ads permanently from this app.',
          price: r'$2.99',
          rawPrice: 2.99,
          currencyCode: 'USD',
          currencySymbol: r'$',
        ),
      ],
      notFoundIDs: <String>[],
    );
  }

  @override
  Future<bool> buyNonConsumable(ProductDetails product) async {
    if (emitPurchaseOnBuy) {
      addPurchase(PurchaseStatus.purchased, pendingCompletePurchase: true);
    }
    return true;
  }

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    completedPurchaseCount += 1;
  }

  void addPurchase(
    PurchaseStatus status, {
    bool pendingCompletePurchase = false,
  }) {
    _purchaseController.add(<PurchaseDetails>[
      _purchase(status)..pendingCompletePurchase = pendingCompletePurchase,
    ]);
  }

  PurchaseDetails _purchase(PurchaseStatus status) {
    return PurchaseDetails(
      productID: removeAdsProductId,
      verificationData: PurchaseVerificationData(
        localVerificationData: 'local',
        serverVerificationData: 'server',
        source: 'test',
      ),
      transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
      status: status,
    );
  }

  void dispose() {
    _purchaseController.close();
  }
}
