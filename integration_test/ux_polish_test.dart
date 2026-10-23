import 'package:chess_room/main.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/ads_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'release_smoke_test.dart' as smoke;
import 'native_promotion_test.dart' as promotion;

/// Uses the existing isolated native match fixture and never starts a purchase.
void main() {
  smoke.main();
  promotion.main();
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('polished home, settings and practice navigation on device',
      (tester) async {
    final disabledAds = AdsManager.disableAllAdsForScreenshot;
    AdsManager.disableAllAdsForScreenshot = true;
    final prefs = await SharedPreferences.getInstance();
    final model = smoke.SmokeAppModel(smoke.SmokeGameStore(prefs));
    try {
      await model.initialization;
      await model.purchaseInitialization;
      model.themeName = 'AppsBay';
      await tester.pumpWidget(ChangeNotifierProvider<AppModel>.value(
          value: model, child: const App(initializeServices: false)));
      await tester.pump(const Duration(seconds: 1));
      await binding.takeScreenshot('06-polished-home');
      await tester.tap(find.byKey(const ValueKey('settings-button')));
      await tester.pumpAndSettle();
      expect(
          find.byKey(const ValueKey('settings-hints-toggle')), findsOneWidget);
      expect(find.byKey(const ValueKey('settings-tip-toggle')), findsOneWidget);
      expect(
          find.byKey(const ValueKey('settings-sound-toggle')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      await binding.takeScreenshot('07-polished-settings');
      await tester.tap(find.byKey(const ValueKey('settings-back-button')));
      await tester.pumpAndSettle();
      final training = find.byKey(const ValueKey('training-button'));
      await tester.ensureVisible(training);
      await tester.tap(training);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('training-progress')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      await binding.takeScreenshot('08-training-progress');
      await tester.tap(find.byKey(const ValueKey('training-puzzles-button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('puzzle-theme-fork')), findsOneWidget);
      await binding.takeScreenshot('09-puzzle-library');
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox());
      await model.saveInProgressGame();
      model.dispose();
      AdsManager.disableAllAdsForScreenshot = disabledAds;
    }
  });
}
