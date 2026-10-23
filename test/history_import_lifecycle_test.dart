import 'package:chess_room/features/game_history/game_history_page.dart';
import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'queued import confirmations save once and preserve history route',
      (tester) async {
    final store = _HistoryStore();
    final observer = _PopObserver();
    await _openHistory(tester, store, observer);
    final import = tester.widget<CupertinoButton>(
        find.byKey(const ValueKey('import-pgn-button')));
    import.onPressed!();
    import.onPressed!();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pgn-import-field')), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('pgn-import-field')),
        '[Result "1-0"]\n\n1. e4 e5 2. Nf3 Nc6 1-0');
    final confirm = tester.widget<CupertinoDialogAction>(
        find.byKey(const ValueKey('pgn-import-confirm')));
    confirm.onPressed!();
    confirm.onPressed!();
    // Build while the focused text field's route is still animating out.
    await tester.pump(const Duration(milliseconds: 20));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(store.saves, 1);
    expect(store.games, hasLength(1));
    expect(observer.pops, 1);
    expect(find.byType(GameHistoryPage), findsOneWidget);
    expect(find.text(S.current.PGN_Imported), findsOneWidget);

    final done = tester.widget<CupertinoDialogAction>(
        find.widgetWithText(CupertinoDialogAction, S.current.Done));
    done.onPressed!();
    done.onPressed!();
    await tester.pumpAndSettle();
    expect(observer.pops, 2);
    expect(find.byType(GameHistoryPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('focused import cancellation disposes safely and can reopen',
      (tester) async {
    final store = _HistoryStore();
    final observer = _PopObserver();
    await _openHistory(tester, store, observer);
    await tester.tap(find.byKey(const ValueKey('import-pgn-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('pgn-import-field')), 'unfinished draft');
    final cancel = tester.widget<CupertinoDialogAction>(
        find.byKey(const ValueKey('pgn-import-cancel')));
    cancel.onPressed!();
    cancel.onPressed!();
    await tester.pump(const Duration(milliseconds: 20));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(store.saves, 0);
    expect(observer.pops, 1);
    expect(find.byType(GameHistoryPage), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('import-pgn-button')));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<CupertinoTextField>(
                find.byKey(const ValueKey('pgn-import-field')))
            .controller!
            .text,
        isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('system Back ignores a queued import confirmation',
      (tester) async {
    final store = _HistoryStore();
    final observer = _PopObserver();
    await _openHistory(tester, store, observer);
    await tester.tap(find.byKey(const ValueKey('import-pgn-button')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('pgn-import-field')),
        '[Result "1-0"]\n\n1. e4 e5 2. Nf3 Nc6 1-0');
    final confirm = tester.widget<CupertinoDialogAction>(
        find.byKey(const ValueKey('pgn-import-confirm')));
    await tester.binding.handlePopRoute();
    confirm.onPressed!();
    await tester.pump(const Duration(milliseconds: 20));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(store.saves, 0);
    expect(observer.pops, 1);
    expect(find.byType(GameHistoryPage), findsOneWidget);
    expect(find.byKey(const ValueKey('pgn-import-field')), findsNothing);
    expect(tester.takeException(), isNull);
  });
  for (final actionKey in ['confirm-delete-game', 'cancel-delete-game']) {
    testWidgets('system Back ignores queued $actionKey', (tester) async {
      final game = SavedGame.fromPgn(
        '[Result "1-0"]\n\n1. e4 e5 2. Nf3 Nc6 1-0',
        importedAt: DateTime(2026, 10, 23),
      );
      final store = _HistoryStore()..games.add(game);
      final observer = _PopObserver();
      await _openHistory(tester, store, observer);
      final delete = find.byKey(ValueKey('delete-saved-game-${game.id}'));
      await tester.ensureVisible(delete);
      await tester.tap(delete);
      await tester.pumpAndSettle();
      final action =
          tester.widget<CupertinoDialogAction>(find.byKey(ValueKey(actionKey)));
      await tester.binding.handlePopRoute();
      action.onPressed!();
      await tester.pumpAndSettle();
      expect(store.deletes, 0);
      expect(store.games, hasLength(1));
      expect(observer.pops, 1);
      expect(find.byType(GameHistoryPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

Future<void> _openHistory(
    WidgetTester tester, _HistoryStore store, _PopObserver observer) async {
  await tester.pumpWidget(CupertinoApp(
    navigatorObservers: [observer],
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Builder(
        builder: (context) => CupertinoPageScaffold(
              child: Center(
                  child: CupertinoButton(
                onPressed: () => Navigator.push<void>(
                    context,
                    CupertinoPageRoute<void>(
                        builder: (_) => GameHistoryPage(store: store))),
                child: const Text('Open history'),
              )),
            )),
  ));
  await tester.tap(find.text('Open history'));
  await tester.pumpAndSettle();
}

class _HistoryStore implements GameHistoryStore {
  final List<SavedGame> games = [];
  int saves = 0;
  int deletes = 0;

  @override
  Future<List<SavedGame>> loadGames() async => List.of(games);

  @override
  Future<void> saveGame(SavedGame game) async {
    saves++;
    games.add(game);
  }

  @override
  Future<void> deleteGame(String id) async {
    deletes++;
    games.removeWhere((game) => game.id == id);
  }
}

class _PopObserver extends NavigatorObserver {
  int pops = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
    super.didPop(route, previousRoute);
  }
}
