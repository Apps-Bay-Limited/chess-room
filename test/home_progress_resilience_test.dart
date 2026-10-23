import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/main_menu_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final corruptedValues in const [
    {'dailyPuzzleLastSolved': 42},
    {'dailyPuzzleStreak': 'invalid'},
  ]) {
    testWidgets('Home stays usable with corrupt progress: $corruptedValues',
        (tester) async {
      SharedPreferences.setMockInitialValues(corruptedValues);
      final model = AppModel();
      addTearDown(model.dispose);
      await model.initialization;
      await model.purchaseInitialization;

      await tester.pumpWidget(_home(model));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('quick-play-button')), findsOneWidget);
      expect(
        tester
            .widget<CupertinoButton>(find.descendant(
              of: find.byKey(const ValueKey('quick-play-button')),
              matching: find.byType(CupertinoButton),
            ))
            .onPressed,
        isNotNull,
      );
      expect(model.game, isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('Home retains progress after a failed refresh and recovers later',
      (tester) async {
    final today = DateTime.now();
    final todayKey = '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    SharedPreferences.setMockInitialValues({
      'dailyPuzzleLastSolved': todayKey,
      'dailyPuzzleStreak': 3,
    });
    final model = AppModel();
    addTearDown(model.dispose);
    await model.initialization;
    await model.purchaseInitialization;
    await tester.pumpWidget(_home(model));
    await tester.pumpAndSettle();
    expect(find.text('Streak: 3'), findsOneWidget);
    expect(find.text('Complete today · keep practicing'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('dailyPuzzleStreak', 'invalid');
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Streak: 3'), findsOneWidget);
    expect(find.text('Complete today · keep practicing'), findsOneWidget);

    await preferences.setInt('dailyPuzzleStreak', 7);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Streak: 7'), findsOneWidget);
    expect(model.game, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Widget _home(AppModel model) => ChangeNotifierProvider.value(
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
    );
