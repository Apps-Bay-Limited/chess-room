import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The non-consumable App Store product that grants premium. The iOS and
/// macOS builds ship under one App Store record, so both resolve this same
/// identifier and a purchase made on either platform restores on the other.
const String premiumProductId = 'com.appsbay.chessRoom1.remove_ads';

/// Preserves the key written by the releases that sold this purchase as
/// "Remove Ads", so upgrading players keep their entitlement.
const String premiumEntitlementKey = 'remove_ads_entitlement';

enum PremiumStoreState {
  idle,
  loading,
  available,
  unavailable,
  purchasing,
  pending,
  purchased,
  restored,
  cancelled,
  failed,
  restoreEmpty,
}

abstract class PremiumStore {
  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<bool> isAvailable();

  Future<ProductDetailsResponse> queryProductDetails(Set<String> productIds);

  Future<bool> buyNonConsumable(ProductDetails product);

  Future<void> restorePurchases();

  Future<void> completePurchase(PurchaseDetails purchase);
}

/// Boundary for a future server-side receipt verifier. The App Store purchase
/// stream remains the authority for this client-only implementation.
abstract class PremiumPurchaseVerifier {
  Future<bool> grantsPremiumEntitlement(PurchaseDetails purchase);
}

class StorePurchaseVerifier implements PremiumPurchaseVerifier {
  const StorePurchaseVerifier();

  @override
  Future<bool> grantsPremiumEntitlement(PurchaseDetails purchase) async {
    return purchase.productID == premiumProductId &&
        (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored);
  }
}

class InAppPurchasePremiumStore implements PremiumStore {
  final InAppPurchase _iap;

  InAppPurchasePremiumStore({InAppPurchase? iap})
      : _iap = iap ?? InAppPurchase.instance;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> productIds) {
    return _iap.queryProductDetails(productIds);
  }

  @override
  Future<bool> buyNonConsumable(ProductDetails product) {
    return _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
  }

  @override
  Future<void> restorePurchases() => _iap.restorePurchases();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) {
    return _iap.completePurchase(purchase);
  }
}

class PremiumPurchaseService extends ChangeNotifier {
  PremiumPurchaseService({
    PremiumStore? store,
    PremiumPurchaseVerifier? verifier,
  })  : _injectedStore = store,
        _verifier = verifier ?? const StorePurchaseVerifier();

  final PremiumStore? _injectedStore;
  final PremiumPurchaseVerifier _verifier;
  PremiumStore? _store;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Future<void>? _initialization;
  ProductDetails? _premiumProduct;
  bool _isPremium = false;
  bool _isAvailable = false;
  bool _isRestoring = false;
  bool _restoreFoundPurchase = false;
  PremiumStoreState _state = PremiumStoreState.idle;

  /// StoreKit is reachable on the two Apple platforms that share this app's
  /// App Store record.
  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  bool get isPremium => _isPremium;

  bool get isAvailable => _isAvailable;

  ProductDetails? get premiumProduct => _premiumProduct;

  String? get localizedPrice => _premiumProduct?.price;

  PremiumStoreState get state => _state;

  bool get isStoreFlowActive {
    return _state == PremiumStoreState.loading ||
        _state == PremiumStoreState.purchasing ||
        _state == PremiumStoreState.pending;
  }

  PremiumStore get _activeStore {
    return _store ??= _injectedStore ?? InAppPurchasePremiumStore();
  }

  Future<void> init() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    if (isSupported) {
      // Subscribe before any awaited work so StoreKit updates are not missed
      // while the app is launching.
      _purchaseSubscription ??= _activeStore.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (_) => _setState(PremiumStoreState.failed),
      );
    }

    await _loadPersistedEntitlement();
    if (!isSupported) return;

    await loadProducts();
    await restorePurchases(userInitiated: false);
  }

  Future<void> loadProducts() async {
    if (!isSupported) {
      return;
    }

    _setState(PremiumStoreState.loading);
    try {
      _isAvailable = await _activeStore.isAvailable();
      if (!_isAvailable) {
        _setUnavailable();
        return;
      }

      final response =
          await _activeStore.queryProductDetails({premiumProductId});
      ProductDetails? product;
      for (final candidate in response.productDetails) {
        if (candidate.id == premiumProductId) {
          product = candidate;
          break;
        }
      }
      if (response.error != null || product == null) {
        _setUnavailable();
        return;
      }

      _premiumProduct = product;
      _setState(PremiumStoreState.available);
    } catch (_) {
      _setUnavailable();
    }
  }

  void _setUnavailable() {
    _isAvailable = false;
    _premiumProduct = null;
    _setState(PremiumStoreState.unavailable);
  }

  Future<void> buyPremium() async {
    if (!isSupported) {
      _setUnavailable();
      return;
    }

    if (_premiumProduct == null) {
      await loadProducts();
    }

    final product = _premiumProduct;
    if (product == null) {
      _setUnavailable();
      return;
    }

    _setState(PremiumStoreState.purchasing);
    try {
      final started = await _activeStore.buyNonConsumable(product);
      if (!started) {
        _setState(PremiumStoreState.failed);
      }
    } catch (_) {
      _setState(PremiumStoreState.failed);
    }
  }

  Future<void> restorePurchases({bool userInitiated = true}) async {
    if (!isSupported) {
      if (userInitiated) {
        _setUnavailable();
      }
      return;
    }

    _isRestoring = true;
    _restoreFoundPurchase = false;
    if (userInitiated) {
      _setState(PremiumStoreState.loading);
    }

    try {
      await _activeStore.restorePurchases();
      // Let purchase-stream events generated by the completed restore request
      // update the entitlement before reporting an empty restore result.
      await Future<void>.delayed(Duration.zero);
      if (userInitiated && !_restoreFoundPurchase) {
        _setState(PremiumStoreState.restoreEmpty);
      }
    } catch (_) {
      if (userInitiated) {
        _setState(PremiumStoreState.failed);
      }
    } finally {
      _isRestoring = false;
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != premiumProductId) {
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _setState(PremiumStoreState.pending);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (purchase.status == PurchaseStatus.restored) {
            _restoreFoundPurchase = true;
          }
          final isValid = await _verifier.grantsPremiumEntitlement(purchase);
          if (isValid) {
            await _grantEntitlement(
              purchase.status == PurchaseStatus.restored && _isRestoring
                  ? PremiumStoreState.restored
                  : PremiumStoreState.purchased,
            );
          } else {
            _setState(PremiumStoreState.failed);
          }
          break;
        case PurchaseStatus.error:
          _setState(PremiumStoreState.failed);
          break;
        case PurchaseStatus.canceled:
          _setState(PremiumStoreState.cancelled);
          break;
      }

      if (purchase.pendingCompletePurchase) {
        try {
          await _activeStore.completePurchase(purchase);
        } catch (_) {
          // StoreKit redelivers unfinished transactions on a later launch.
        }
      }
    }
  }

  Future<void> _grantEntitlement(PremiumStoreState state) async {
    _isPremium = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(premiumEntitlementKey, true);
    _setState(state);
  }

  Future<void> _loadPersistedEntitlement() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(premiumEntitlementKey) ?? false;
    notifyListeners();
  }

  void _setState(PremiumStoreState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
