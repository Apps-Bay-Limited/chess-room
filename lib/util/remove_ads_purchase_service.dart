import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
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

class InAppPurchaseRemoveAdsStore implements RemoveAdsStore {
  final InAppPurchasePlatform _iap;

  InAppPurchaseRemoveAdsStore({InAppPurchasePlatform? iap})
      : _iap = iap ?? _storeKitPlatform();

  static InAppPurchasePlatform _storeKitPlatform() {
    InAppPurchaseStoreKitPlatform.registerPlatform();
    return InAppPurchasePlatform.instance;
  }

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
  RemoveAdsPurchaseService({RemoveAdsStore? store}) : _injectedStore = store;

  final RemoveAdsStore? _injectedStore;
  RemoveAdsStore? _store;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
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

  Future<void> init() async {
    await _loadPersistedEntitlement();
    if (!isSupported) {
      return;
    }

    _purchaseSubscription ??= _activeStore.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (_) => _setState(RemoveAdsStoreState.failed),
    );

    await loadProducts();
    await restorePurchases(userInitiated: false);
  }

  Future<void> loadProducts() async {
    if (!isSupported) {
      return;
    }

    _setState(RemoveAdsStoreState.loading);
    _isAvailable = await _activeStore.isAvailable();
    if (!_isAvailable) {
      _removeAdsProduct = null;
      _setState(RemoveAdsStoreState.unavailable);
      return;
    }

    final response =
        await _activeStore.queryProductDetails({removeAdsProductId});
    if (response.productDetails.isEmpty) {
      _removeAdsProduct = null;
      _setState(RemoveAdsStoreState.unavailable);
      return;
    }

    _removeAdsProduct = response.productDetails.first;
    _setState(RemoveAdsStoreState.available);
  }

  Future<void> buyRemoveAds() async {
    if (!isSupported) {
      _setState(RemoveAdsStoreState.unavailable);
      return;
    }

    final product = _removeAdsProduct;
    if (product == null) {
      await loadProducts();
    }

    final loadedProduct = _removeAdsProduct;
    if (loadedProduct == null) {
      _setState(RemoveAdsStoreState.unavailable);
      return;
    }

    _setState(RemoveAdsStoreState.purchasing);
    final started = await _activeStore.buyNonConsumable(loadedProduct);
    if (!started) {
      _setState(RemoveAdsStoreState.failed);
    }
  }

  Future<void> restorePurchases({bool userInitiated = true}) async {
    if (!isSupported) {
      if (userInitiated) {
        _setState(RemoveAdsStoreState.unavailable);
      }
      return;
    }

    _isRestoring = userInitiated;
    _restoreFoundPurchase = false;
    if (userInitiated) {
      _setState(RemoveAdsStoreState.loading);
    }

    await _activeStore.restorePurchases();

    if (userInitiated) {
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    if (userInitiated && !_restoreFoundPurchase) {
      _setState(RemoveAdsStoreState.restoreEmpty);
    }
    _isRestoring = false;
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != removeAdsProductId) {
        if (purchase.pendingCompletePurchase) {
          await _activeStore.completePurchase(purchase);
        }
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _setState(RemoveAdsStoreState.pending);
          break;
        case PurchaseStatus.purchased:
          await _grantEntitlement(RemoveAdsStoreState.purchased);
          break;
        case PurchaseStatus.restored:
          _restoreFoundPurchase = true;
          await _grantEntitlement(
            _isRestoring
                ? RemoveAdsStoreState.restored
                : RemoveAdsStoreState.purchased,
          );
          break;
        case PurchaseStatus.error:
          _setState(RemoveAdsStoreState.failed);
          break;
        case PurchaseStatus.canceled:
          _setState(RemoveAdsStoreState.cancelled);
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _activeStore.completePurchase(purchase);
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
