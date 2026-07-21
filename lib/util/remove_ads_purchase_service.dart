import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String removeAdsProductId = 'com.appsbay.chessRoom1.remove_ads';
const String removeAdsEntitlementKey = 'remove_ads_entitlement';

enum RemoveAdsStoreState {
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

abstract class RemoveAdsStore {
  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<bool> isAvailable();

  Future<ProductDetailsResponse> queryProductDetails(Set<String> productIds);

  Future<bool> buyNonConsumable(ProductDetails product);

  Future<void> restorePurchases();

  Future<void> completePurchase(PurchaseDetails purchase);
}

/// Boundary for a future server-side receipt verifier. The App Store purchase
/// stream remains the authority for this client-only implementation.
abstract class RemoveAdsPurchaseVerifier {
  Future<bool> grantsRemoveAdsEntitlement(PurchaseDetails purchase);
}

class StorePurchaseVerifier implements RemoveAdsPurchaseVerifier {
  const StorePurchaseVerifier();

  @override
  Future<bool> grantsRemoveAdsEntitlement(PurchaseDetails purchase) async {
    return purchase.productID == removeAdsProductId &&
        (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored);
  }
}

class InAppPurchaseRemoveAdsStore implements RemoveAdsStore {
  final InAppPurchase _iap;

  InAppPurchaseRemoveAdsStore({InAppPurchase? iap})
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

class RemoveAdsPurchaseService extends ChangeNotifier {
  RemoveAdsPurchaseService({
    RemoveAdsStore? store,
    RemoveAdsPurchaseVerifier? verifier,
  })  : _injectedStore = store,
        _verifier = verifier ?? const StorePurchaseVerifier();

  final RemoveAdsStore? _injectedStore;
  final RemoveAdsPurchaseVerifier _verifier;
  RemoveAdsStore? _store;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Future<void>? _initialization;
  ProductDetails? _removeAdsProduct;
  bool _isAdsRemoved = false;
  bool _isAvailable = false;
  bool _isRestoring = false;
  bool _restoreFoundPurchase = false;
  RemoveAdsStoreState _state = RemoveAdsStoreState.idle;

  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  bool get isAdsRemoved => _isAdsRemoved;

  bool get isAvailable => _isAvailable;

  ProductDetails? get removeAdsProduct => _removeAdsProduct;

  String? get localizedPrice => _removeAdsProduct?.price;

  RemoveAdsStoreState get state => _state;

  bool get isStoreFlowActive {
    return _state == RemoveAdsStoreState.loading ||
        _state == RemoveAdsStoreState.purchasing ||
        _state == RemoveAdsStoreState.pending;
  }

  RemoveAdsStore get _activeStore {
    return _store ??= _injectedStore ?? InAppPurchaseRemoveAdsStore();
  }

  Future<void> init() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    if (isSupported) {
      // Subscribe before any awaited work so StoreKit updates are not missed
      // while the app is launching.
      _purchaseSubscription ??= _activeStore.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (_) => _setState(RemoveAdsStoreState.failed),
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

    _setState(RemoveAdsStoreState.loading);
    try {
      _isAvailable = await _activeStore.isAvailable();
      if (!_isAvailable) {
        _setUnavailable();
        return;
      }

      final response =
          await _activeStore.queryProductDetails({removeAdsProductId});
      ProductDetails? product;
      for (final candidate in response.productDetails) {
        if (candidate.id == removeAdsProductId) {
          product = candidate;
          break;
        }
      }
      if (response.error != null || product == null) {
        _setUnavailable();
        return;
      }

      _removeAdsProduct = product;
      _setState(RemoveAdsStoreState.available);
    } catch (_) {
      _setUnavailable();
    }
  }

  void _setUnavailable() {
    _isAvailable = false;
    _removeAdsProduct = null;
    _setState(RemoveAdsStoreState.unavailable);
  }

  Future<void> buyRemoveAds() async {
    if (!isSupported) {
      _setUnavailable();
      return;
    }

    if (_removeAdsProduct == null) {
      await loadProducts();
    }

    final product = _removeAdsProduct;
    if (product == null) {
      _setUnavailable();
      return;
    }

    _setState(RemoveAdsStoreState.purchasing);
    try {
      final started = await _activeStore.buyNonConsumable(product);
      if (!started) {
        _setState(RemoveAdsStoreState.failed);
      }
    } catch (_) {
      _setState(RemoveAdsStoreState.failed);
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
      _setState(RemoveAdsStoreState.loading);
    }

    try {
      await _activeStore.restorePurchases();
      // Let purchase-stream events generated by the completed restore request
      // update the entitlement before reporting an empty restore result.
      await Future<void>.delayed(Duration.zero);
      if (userInitiated && !_restoreFoundPurchase) {
        _setState(RemoveAdsStoreState.restoreEmpty);
      }
    } catch (_) {
      if (userInitiated) {
        _setState(RemoveAdsStoreState.failed);
      }
    } finally {
      _isRestoring = false;
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != removeAdsProductId) {
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _setState(RemoveAdsStoreState.pending);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (purchase.status == PurchaseStatus.restored) {
            _restoreFoundPurchase = true;
          }
          final isValid = await _verifier.grantsRemoveAdsEntitlement(purchase);
          if (isValid) {
            await _grantEntitlement(
              purchase.status == PurchaseStatus.restored && _isRestoring
                  ? RemoveAdsStoreState.restored
                  : RemoveAdsStoreState.purchased,
            );
          } else {
            _setState(RemoveAdsStoreState.failed);
          }
          break;
        case PurchaseStatus.error:
          _setState(RemoveAdsStoreState.failed);
          break;
        case PurchaseStatus.canceled:
          _setState(RemoveAdsStoreState.cancelled);
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

  Future<void> _grantEntitlement(RemoveAdsStoreState state) async {
    _isAdsRemoved = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(removeAdsEntitlementKey, true);
    _setState(state);
  }

  Future<void> _loadPersistedEntitlement() async {
    final prefs = await SharedPreferences.getInstance();
    _isAdsRemoved = prefs.getBool(removeAdsEntitlementKey) ?? false;
    notifyListeners();
  }

  void _setState(RemoveAdsStoreState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
