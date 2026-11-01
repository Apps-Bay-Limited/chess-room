import 'dart:async';

import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/premium_purchase_service.dart';
import 'package:chess_room/views/components/settings_view/premium_section.dart';
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
      purchaseService: PremiumPurchaseService(store: store),
    );
    addTearDown(appModel.dispose);

    await tester.pumpWidget(_localizedApp(PremiumSection(appModel: appModel)));

    expect(find.byKey(const ValueKey('premium-section')), findsNothing);
    expect(find.text('Restore Purchases'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  for (final platform in [TargetPlatform.iOS, TargetPlatform.macOS]) {
    testWidgets('offers buy and restore on ${platform.name}', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      final store = _SectionStore();
      addTearDown(store.dispose);

      // Store setup runs on the real clock: the service's silent restore
      // awaits a timer, which a faked test clock would never fire.
      late final AppModel appModel;
      await tester.runAsync(() async {
        appModel =
            AppModel(purchaseService: PremiumPurchaseService(store: store));
        await appModel.purchaseInitialization;
      });
      addTearDown(appModel.dispose);

      await tester
          .pumpWidget(_localizedApp(PremiumSection(appModel: appModel)));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('premium-section')), findsOneWidget);
      expect(find.text(r'Unlock Premium $2.99'), findsOneWidget);
      expect(find.text('Restore Purchases'), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });
  }
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
    home: CupertinoPageScaffold(
      child: SafeArea(child: SingleChildScrollView(child: home)),
    ),
  );
}

class _SectionStore implements PremiumStore {
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
          id: premiumProductId,
          title: 'Premium',
          description: 'Unlock every theme, unlimited training and no ads.',
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
