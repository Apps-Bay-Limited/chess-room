import 'dart:async';

import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/remove_ads_purchase_service.dart';
import 'package:chess_room/views/components/settings_view/remove_ads_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('hides purchase controls on Android', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final store = _SectionStore();
    addTearDown(store.dispose);
    final appModel = AppModel(
      purchaseService: RemoveAdsPurchaseService(store: store),
    );
    addTearDown(appModel.dispose);

    await tester
        .pumpWidget(_localizedApp(RemoveAdsSection(appModel: appModel)));

    expect(find.text('Remove Ads'), findsNothing);
    expect(find.text('Restore Purchases'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });
}

Widget _localizedApp(Widget home) {
  return CupertinoApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: CupertinoPageScaffold(child: Center(child: home)),
  );
}

class _SectionStore implements RemoveAdsStore {
  final StreamController<List<PurchaseDetails>> _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _purchaseController.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
      Set<String> productIds) async {
    return ProductDetailsResponse(
      productDetails: [
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
      notFoundIDs: const [],
    );
  }

  @override
  Future<bool> buyNonConsumable(ProductDetails product) async => true;

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  @override
  Future<void> restorePurchases() async {}

  void dispose() {
    _purchaseController.close();
  }
}
