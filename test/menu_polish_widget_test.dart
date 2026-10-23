import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/ai_difficulty_picker.dart';
import 'package:chess_room/views/components/settings_view/toggle.dart';
import 'package:chess_room/views/components/settings_view/toggles.dart';
import 'package:chess_room/views/main_menu_view.dart';
import 'package:chess_room/views/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('home settings entry keeps the native back route usable',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final model = AppModel();
    addTearDown(model.dispose);
    await model.initialization;
    await model.purchaseInitialization;
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: model,
      child: CupertinoApp(
        theme: const CupertinoThemeData(brightness: Brightness.dark),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const MainMenuView(initializeServices: false),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings-button')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsView), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('settings-back-button')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsView), findsNothing);
    expect(find.byKey(const ValueKey('quick-play-button')), findsOneWidget);
  });

  testWidgets('named difficulty choices keep the existing engine levels',
      (tester) async {
    int? selected;
    await tester
        .pumpWidget(_app(AIDifficultyPicker(3, (value) => selected = value)));
    await tester.pumpAndSettle();

    for (final level
        in const {1: 'Easy', 3: 'Medium', 5: 'Hard', 6: 'Extreme'}.entries) {
      expect(find.text(level.value), findsOneWidget);
      await tester.tap(find.byKey(ValueKey('ai-difficulty-${level.key}')));
      expect(selected, level.key);
    }
  });

  testWidgets('settings row and switch each change the value once',
      (tester) async {
    var enabled = false;
    var changes = 0;
    await tester.pumpWidget(_app(StatefulBuilder(
      builder: (context, setState) => Toggle(
        label: 'Sound',
        description: 'Play sounds when pieces move.',
        toggle: enabled,
        setFunc: (value) => setState(() {
          enabled = value;
          changes++;
        }),
      ),
    )));

    await tester.tap(find.text('Sound'));
    await tester.pump();
    expect(enabled, isTrue);
    expect(changes, 1);
    await tester.tap(find.byType(CupertinoSwitch));
    await tester.pump();
    expect(enabled, isFalse);
    expect(changes, 2);
  });

  testWidgets('visible sound setting uses its existing saved preference',
      (tester) async {
    SharedPreferences.setMockInitialValues({'soundEnabled': false});
    final model = AppModel();
    addTearDown(model.dispose);
    await model.initialization;
    await model.purchaseInitialization;
    await tester.pumpWidget(_app(ListenableBuilder(
      listenable: model,
      builder: (context, _) => Toggles(model),
    )));
    await tester.pumpAndSettle();

    final row = find.byKey(const ValueKey('settings-sound-toggle'));
    await tester.ensureVisible(row);
    final soundSwitch =
        find.descendant(of: row, matching: find.byType(CupertinoSwitch));
    expect(tester.widget<CupertinoSwitch>(soundSwitch).value, isFalse);
    await tester.tap(soundSwitch);
    await tester.pumpAndSettle();

    expect(model.soundEnabled, isTrue);
    expect((await SharedPreferences.getInstance()).getBool('soundEnabled'),
        isTrue);
  });

  testWidgets('settings and difficulty adapt to narrow Arabic with large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_app(
      Column(children: [
        Toggle(
          label: 'إظهار التلميحات',
          description: 'عرض الوجهات القانونية عند اختيار قطعة على اللوحة.',
          toggle: true,
          setFunc: (_) {},
        ),
        AIDifficultyPicker(3, (_) {}),
      ]),
      locale: const Locale('ar'),
      textScale: 2,
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final hard = find.byKey(const ValueKey('ai-difficulty-5'));
    await tester.ensureVisible(hard);
    await tester.tap(hard);
    expect(tester.takeException(), isNull);
  });
}

Widget _app(Widget child, {Locale? locale, double textScale = 1}) =>
    CupertinoApp(
      locale: locale,
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Builder(
          builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(textScale)),
                child: CupertinoPageScaffold(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: child,
                    ),
                  ),
                ),
              )),
    );
