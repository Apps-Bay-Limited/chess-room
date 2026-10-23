import 'package:chess_room/features/training/training_hub_page.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/main_menu_view.dart';
import 'package:chess_room/views/settings_view.dart';
import 'package:chess_room/views/single_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'themeName': 'AppsBay',
      'soundEnabled': false,
      'aiDifficulty': 3,
      'timeLimit': 0,
    });
  });

  for (final locale in S.delegate.supportedLocales) {
    testWidgets(
      '${locale.toLanguageTag()}: small-screen navigation supports large text and reduced motion',
      (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final model = AppModel();
        addTearDown(model.dispose);
        await model.initialization;
        await model.purchaseInitialization;
        await tester.pumpWidget(_localizedApp(model, locale));
        await tester.pumpAndSettle();
        _expectNoLayoutError(tester, 'Home', locale);

        final settingsEntry = find.byKey(const ValueKey('settings-button'));
        final homeContext = tester.element(settingsEntry);
        expect(Localizations.localeOf(homeContext), locale);
        expect(MediaQuery.textScalerOf(homeContext).scale(16), 32);
        expect(MediaQuery.disableAnimationsOf(homeContext), isTrue);
        expect(
          Directionality.of(homeContext),
          locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        );

        await tester.tap(settingsEntry);
        await tester.pumpAndSettle();
        expect(find.byType(SettingsView), findsOneWidget);
        _expectNoLayoutError(tester, 'Settings', locale);

        final soundRow = find.byKey(const ValueKey('settings-sound-toggle'));
        await _show(tester, soundRow, within: find.byType(SettingsView));
        final soundSwitch = find.descendant(
          of: soundRow,
          matching: find.byType(CupertinoSwitch),
        );
        expect(tester.widget<CupertinoSwitch>(soundSwitch).value, isFalse);
        await tester.tap(soundSwitch);
        await tester.pumpAndSettle();
        expect(model.soundEnabled, isTrue);
        expect(
          (await SharedPreferences.getInstance()).getBool('soundEnabled'),
          isTrue,
        );
        _expectNoLayoutError(tester, 'Settings sound control', locale);

        await tester.tap(find.byKey(const ValueKey('settings-back-button')));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsView), findsNothing);

        final aiEntry = find.byKey(const ValueKey('vs-ai-button'));
        await _show(tester, aiEntry, within: find.byType(MainMenuView));
        await tester.tap(aiEntry);
        await tester.pumpAndSettle();
        expect(find.byType(SinglePlayerView), findsOneWidget);
        expect(model.playerCount, 1);
        _expectNoLayoutError(tester, 'AI setup', locale);

        final hardLevel = find.byKey(const ValueKey('ai-difficulty-5'));
        await _show(tester, hardLevel, within: find.byType(SinglePlayerView));
        await tester.tap(hardLevel);
        await tester.pumpAndSettle();
        expect(model.aiDifficulty, 5);

        final startButton = find.byKey(const ValueKey('start-game-button'));
        await _show(tester, startButton, within: find.byType(SinglePlayerView));
        expect(startButton.hitTestable(), findsOneWidget);
        expect(tester.getSize(startButton).height, greaterThanOrEqualTo(48));
        _expectNoLayoutError(tester, 'AI setup controls', locale);

        await tester.tap(find.byKey(const ValueKey('setup-back-button')));
        await tester.pumpAndSettle();
        expect(find.byType(SinglePlayerView), findsNothing);

        final trainingEntry = find.byKey(const ValueKey('training-button'));
        await _show(tester, trainingEntry, within: find.byType(MainMenuView));
        await tester.tap(trainingEntry);
        await tester.pumpAndSettle();
        expect(find.byType(TrainingHubPage), findsOneWidget);
        expect(find.byKey(const ValueKey('training-progress')), findsOneWidget);
        _expectNoLayoutError(tester, 'Training', locale);

        for (final key in const [
          'training-puzzles-button',
          'training-openings-button',
        ]) {
          final practiceEntry = find.byKey(ValueKey(key));
          await _show(tester, practiceEntry,
              within: find.byType(TrainingHubPage));
          expect(practiceEntry.hitTestable(), findsOneWidget);
          _expectNoLayoutError(tester, key, locale);
        }

        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.byType(TrainingHubPage), findsNothing);
        expect(find.byType(MainMenuView), findsOneWidget);
        expect(model.game, isNull);
        _expectNoLayoutError(tester, 'Return Home', locale);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      },
    );
  }
}

Future<void> _show(WidgetTester tester, Finder target,
    {required Finder within}) async {
  final scrollable = find.descendant(
    of: within,
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(target, 240,
      scrollable: scrollable.first, maxScrolls: 30);
  await tester.pumpAndSettle();
}

void _expectNoLayoutError(WidgetTester tester, String screen, Locale locale) {
  expect(tester.takeException(), isNull,
      reason: '$screen should lay out at 2× text in ${locale.toLanguageTag()}');
}

Widget _localizedApp(AppModel model, Locale locale) =>
    ChangeNotifierProvider.value(
      value: model,
      child: CupertinoApp(
        locale: locale,
        theme: const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.accent,
          scaffoldBackgroundColor: AppColors.background,
          barBackgroundColor: AppColors.surface,
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
                color: AppColors.textPrimary, fontSize: 16, height: 1.35),
          ),
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: const MainMenuView(initializeServices: false),
      ),
    );
