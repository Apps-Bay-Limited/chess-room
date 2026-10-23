import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/main_menu_view/home_play_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home actions continue, quick play, and practice independently',
      (tester) async {
    var continued = 0;
    var played = 0;
    var practiced = 0;
    await tester.pumpWidget(_app(HomePlayActions(
      hasSavedGame: true,
      solvedToday: true,
      streak: 4,
      onContinue: () => continued++,
      onQuickPlay: () => played++,
      onDailyPuzzle: () => practiced++,
    )));
    await tester.pumpAndSettle();

    expect(find.text('Streak: 4'), findsOneWidget);
    expect(find.text('Complete today · keep practicing'), findsOneWidget);
    final buttons =
        tester.widgetList<CupertinoButton>(find.byType(CupertinoButton));
    expect(buttons.where((button) => button.color == AppColors.accent),
        hasLength(1));
    expect(
      tester
          .widget<CupertinoButton>(find.descendant(
            of: find.byKey(const ValueKey('continue-game-button')),
            matching: find.byType(CupertinoButton),
            matchRoot: true,
          ))
          .color,
      AppColors.accent,
    );
    await tester.tap(find.byKey(const ValueKey('continue-game-button')));
    await tester.tap(find.byKey(const ValueKey('quick-play-button')));
    await tester.tap(find.byKey(const ValueKey('daily-puzzle-button')));
    expect([continued, played, practiced], [1, 1, 1]);
  });

  testWidgets('new players see quick play without a Continue action',
      (tester) async {
    await tester.pumpWidget(_app(HomePlayActions(
      hasSavedGame: false,
      solvedToday: false,
      streak: 0,
      onContinue: () {},
      onQuickPlay: () {},
      onDailyPuzzle: () {},
    )));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('continue-game-button')), findsNothing);
    expect(find.text('A fresh challenge for today'), findsOneWidget);
    expect(find.textContaining('Streak:'), findsNothing);
  });

  testWidgets('game actions remain disabled while a save is loading',
      (tester) async {
    var calls = 0;
    await tester.pumpWidget(_app(HomePlayActions(
      hasSavedGame: true,
      solvedToday: false,
      streak: 0,
      isLoading: true,
      onContinue: () => calls++,
      onQuickPlay: () => calls++,
      onDailyPuzzle: () => calls++,
    )));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('quick-play-button')));
    await tester.tap(find.byKey(const ValueKey('continue-game-button')));
    expect(calls, 0);
    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });

  for (final size in const [Size(375, 667), Size(700, 390)]) {
    testWidgets('home actions support Arabic and large text at $size',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(_app(
        HomePlayActions(
          hasSavedGame: true,
          solvedToday: false,
          streak: 12,
          onContinue: () {},
          onQuickPlay: () {},
          onDailyPuzzle: () {},
        ),
        locale: const Locale('ar'),
        textScale: 2,
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final quickPlay = find.byKey(const ValueKey('quick-play-button'));
      await tester.ensureVisible(quickPlay);
      expect(Directionality.of(tester.element(quickPlay)), TextDirection.rtl);
      expect(tester.getSize(quickPlay).height, greaterThanOrEqualTo(48));
    });
  }
}

Widget _app(Widget child, {Locale? locale, double textScale = 1}) {
  return CupertinoApp(
    locale: locale,
    theme: const CupertinoThemeData(brightness: Brightness.dark),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: true,
        ),
        child: CupertinoPageScaffold(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(child: child),
            ),
          ),
        ),
      );
    }),
  );
}
