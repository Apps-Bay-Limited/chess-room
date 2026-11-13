import 'dart:async';

import 'package:chess_room/util/premium_purchase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FakePremiumStore store;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    store = FakePremiumStore();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    store.dispose();
  });

  test('loads the Premium product and exposes the localized price',
      () async {
    final service = PremiumPurchaseService(store: store);

    await service.init();

    expect(store.queriedProductIds, contains(premiumProductId));
    expect(service.localizedPrice, r'$2.99');
    expect(service.state, PremiumStoreState.available);

    service.dispose();
  });

  test('purchase grants and persists the premium entitlement', () async {
    final service = PremiumPurchaseService(store: store);

    await service.init();
    await service.buyPremium();
    await Future<void>.delayed(Duration.zero);

    final prefs = await SharedPreferences.getInstance();
    expect(service.isPremium, isTrue);
    expect(prefs.getBool(premiumEntitlementKey), isTrue);
    expect(store.completedPurchaseCount, 1);

    service.dispose();
  });

  test('purchase flow is active while purchase is pending', () async {
    store.emitPurchaseOnBuy = false;
    final service = PremiumPurchaseService(store: store);

    await service.init();
    await service.buyPremium();

    expect(service.state, PremiumStoreState.purchasing);
    expect(service.isStoreFlowActive, isTrue);

    store.addPurchase(PurchaseStatus.canceled);
    await Future<void>.delayed(Duration.zero);

    expect(service.state, PremiumStoreState.cancelled);
    expect(service.isStoreFlowActive, isFalse);

    service.dispose();
  });

  test('restore reports when no Premium purchase is found', () async {
    final service = PremiumPurchaseService(store: store);

    await service.init();
    await service.restorePurchases();

    expect(service.isPremium, isFalse);
    expect(service.state, PremiumStoreState.restoreEmpty);

    service.dispose();
  });

  test('restore grants and persists a prior Premium purchase', () async {
    store.emitRestorePurchase = true;
    final service = PremiumPurchaseService(store: store);

    await service.init();
    await service.restorePurchases();
    await Future<void>.delayed(Duration.zero);

    final prefs = await SharedPreferences.getInstance();
    expect(service.isPremium, isTrue);
    expect(service.state, PremiumStoreState.restored);
    expect(prefs.getBool(premiumEntitlementKey), isTrue);

    service.dispose();
  });

  test('store failures leave the app usable and report unavailable', () async {
    store.throwWhenLoadingProducts = true;
    final service = PremiumPurchaseService(store: store);

    await service.init();

    expect(service.isPremium, isFalse);
    expect(service.state, PremiumStoreState.unavailable);
    expect(service.localizedPrice, isNull);

    service.dispose();
  });

  test('offline launches retain the locally cached entitlement', () async {
    SharedPreferences.setMockInitialValues({premiumEntitlementKey: true});
    store.available = false;
    final service = PremiumPurchaseService(store: store);

    await service.init();

    expect(service.isPremium, isTrue);
    expect(service.state, PremiumStoreState.unavailable);

    service.dispose();
  });

  test('macOS resolves the same product as iOS and restores it', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    store.emitRestorePurchase = true;
    final service = PremiumPurchaseService(store: store);

    await service.init();

    expect(service.isSupported, isTrue);
    expect(store.queriedProductIds, contains(premiumProductId));
    expect(service.localizedPrice, r'$2.99');

    await service.restorePurchases();
    await Future<void>.delayed(Duration.zero);

    final prefs = await SharedPreferences.getInstance();
    expect(service.isPremium, isTrue);
    expect(service.state, PremiumStoreState.restored);
    expect(prefs.getBool(premiumEntitlementKey), isTrue);

    service.dispose();
  });

  test('Android queries the Play product and can grant premium', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final service = PremiumPurchaseService(store: store);

    await service.init();

    expect(service.isSupported, isTrue);
    expect(store.queriedProductIds, contains(premiumPlayProductId));
    expect(store.queriedProductIds, isNot(contains(premiumAppleProductId)));
    expect(service.localizedPrice, r'$2.99');

    await service.buyPremium();
    await Future<void>.delayed(Duration.zero);

    final prefs = await SharedPreferences.getInstance();
    expect(service.isPremium, isTrue);
    expect(prefs.getBool(premiumEntitlementKey), isTrue);
    // Play voids a purchase that is never acknowledged, so the service has to
    // complete it rather than leave it to the next launch.
    expect(store.completedPurchaseCount, 1);

    service.dispose();
  });

  test('a desktop platform without a store exposes no purchase support',
      () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    final service = PremiumPurchaseService(store: store);

    await service.init();

    expect(service.isSupported, isFalse);
    expect(store.queriedProductIds, isEmpty);
    expect(service.localizedPrice, isNull);

    service.dispose();
  });
}

class FakePremiumStore implements PremiumStore {
  final StreamController<List<PurchaseDetails>> _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  final Set<String> queriedProductIds = <String>{};
  bool available = true;
  bool emitPurchaseOnBuy = true;
  bool emitRestorePurchase = false;
  bool throwWhenLoadingProducts = false;
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
    if (throwWhenLoadingProducts) {
      throw StateError('Store unavailable');
    }
    return ProductDetailsResponse(
      productDetails: <ProductDetails>[
        ProductDetails(
          id: premiumProductId,
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
  Future<void> restorePurchases() async {
    if (emitRestorePurchase) {
      addPurchase(PurchaseStatus.restored, pendingCompletePurchase: true);
    }
  }

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
      productID: premiumProductId,
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
