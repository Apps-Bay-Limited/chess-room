import 'dart:async';

import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_page.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/game_history/game_history_page.dart';
import 'package:chess_room/features/game_history/game_replay_page.dart';
import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:chess_room/features/opening_trainer/opening_trainer_page.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/features/training/training_hub_page.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('opening progress ignores invalid shapes without rewriting saved data',
      () async {
    for (final encoded in <Object>[
      '{',
      '{}',
      'null',
      '[1,"italian"]',
      7,
    ]) {
      SharedPreferences.setMockInitialValues({
        'opening_trainer_completed_v1': encoded,
      });
      final store = SharedPreferencesOpeningProgressStore();
      expect(await store.loadCompletedIds(),
          encoded == '[1,"italian"]' ? {'italian'} : isEmpty);
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.get('opening_trainer_completed_v1'), encoded);
    }
  });

  testWidgets('training totals ignore unknown IDs and refresh after practice',
      (tester) async {
    final puzzles = _PuzzleStore({themedPuzzles.first.id, 'removed-puzzle'});
    final openings = _OpeningStore({'italian', 'removed-opening'});
    await tester.pumpWidget(_app(TrainingHubPage(
      puzzleProgressStore: puzzles,
      openingProgressStore: openings,
    )));
    await tester.pumpAndSettle();

    expect(
        find.text(S.current.Puzzles_Completed_Count(1, themedPuzzles.length)),
        findsOneWidget);
    expect(
        find.text(S.current.Openings_Completed_Count(1, openingCourses.length)),
        findsOneWidget);
    await tester
        .ensureVisible(find.byKey(const ValueKey('training-puzzles-button')));
    await tester.tap(find.byKey(const ValueKey('training-puzzles-button')));
    await tester.pumpAndSettle();
    puzzles.ids.add(themedPuzzles[1].id);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
        find.text(S.current.Puzzles_Completed_Count(2, themedPuzzles.length)),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('one progress failure preserves other totals and practice routes',
      (tester) async {
    final puzzles = _PuzzleStore({})..failReads = true;
    final openings = _OpeningStore({'italian'});
    await tester.pumpWidget(_app(TrainingHubPage(
      puzzleProgressStore: puzzles,
      openingProgressStore: openings,
    )));
    await tester.pumpAndSettle();

    expect(find.text(S.current.Training_Progress_Unavailable), findsOneWidget);
    expect(
        find.text(S.current.Openings_Completed_Count(1, openingCourses.length)),
        findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('training-openings-button')),
      300,
    );
    await tester.tap(find.byKey(const ValueKey('training-openings-button')));
    await tester.pumpAndSettle();
    expect(find.byType(OpeningTrainerPage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    puzzles.failReads = false;
    puzzles.ids.add(themedPuzzles.first.id);
    await tester
        .ensureVisible(find.byKey(const ValueKey('training-progress-retry')));
    await tester.tap(find.byKey(const ValueKey('training-progress-retry')));
    await tester.pumpAndSettle();
    expect(find.text(S.current.Training_Progress_Unavailable), findsNothing);
    expect(
        find.text(S.current.Puzzles_Completed_Count(1, themedPuzzles.length)),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('late progress completion after disposal does not update a page',
      (tester) async {
    final puzzles = _PendingPuzzleStore();
    final openings = _PendingOpeningStore();
    await tester.pumpWidget(_app(TrainingHubPage(
      puzzleProgressStore: puzzles,
      openingProgressStore: openings,
    )));
    await tester.pumpWidget(const SizedBox());
    puzzles.result.complete({themedPuzzles.first.id});
    openings.result.completeError(StateError('unavailable'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('daily practice remains usable after a failed progress read',
      (tester) async {
    final store = _DailyStore()..failRead = true;
    final puzzle = dailyPuzzles.firstWhere((puzzle) => puzzle.id == 'queen-f8');
    await tester.pumpWidget(_app(DailyPuzzlePage(
      puzzle: puzzle,
      today: DateTime(2026, 10, 23),
      progressStore: store,
    )));
    await tester.pumpAndSettle();
    expect(find.text(S.current.Training_Progress_Unavailable), findsOneWidget);
    await _solveDaily(tester, puzzle);
    expect(store.saved, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'daily completion can retry a failed save without replaying moves',
      (tester) async {
    final store = _DailyStore()..failWrite = true;
    final puzzle = dailyPuzzles.firstWhere((puzzle) => puzzle.id == 'queen-f8');
    await tester.pumpWidget(_app(DailyPuzzlePage(
      puzzle: puzzle,
      today: DateTime(2026, 10, 23),
      progressStore: store,
    )));
    await tester.pumpAndSettle();
    await _solveDaily(tester, puzzle);
    expect(store.saved, isFalse);
    expect(find.text(S.current.Training_Progress_Unavailable), findsOneWidget);
    final board = tester.widget<PositionBoard>(find.byType(PositionBoard));
    final fen = chessPositionToFen(board.board, Player.player2);
    store.failWrite = false;
    await tester.ensureVisible(find.text(S.current.Retry));
    await tester.tap(find.text(S.current.Retry));
    await tester.pumpAndSettle();
    expect(store.saved, isTrue);
    expect(
        chessPositionToFen(
            tester.widget<PositionBoard>(find.byType(PositionBoard)).board,
            Player.player2),
        fen);
    expect(find.text(S.current.Training_Progress_Unavailable), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'deletion cancellation preserves history and confirm deletes once',
      (tester) async {
    final game = _savedGame();
    final store = _HistoryStore([game]);
    await tester.pumpWidget(_app(GameHistoryPage(store: store)));
    await tester.pumpAndSettle();
    final delete = find.byKey(ValueKey('delete-saved-game-${game.id}'));
    await tester.ensureVisible(delete);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cancel-delete-game')));
    await tester.pumpAndSettle();
    expect(store.deletes, 0);
    expect(find.byKey(ValueKey('saved-game-${game.id}')), findsOneWidget);

    await tester.tap(delete);
    await tester.pumpAndSettle();
    final confirm = tester.widget<CupertinoDialogAction>(
        find.byKey(const ValueKey('confirm-delete-game')));
    confirm.onPressed!();
    confirm.onPressed!();
    await tester.pumpAndSettle();
    expect(store.deletes, 1);
    expect(store.games, isEmpty);
    expect(find.byType(GameHistoryPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed deletion leaves the saved game available',
      (tester) async {
    final game = _savedGame();
    final store = _HistoryStore([game])..failDelete = true;
    await tester.pumpWidget(_app(GameHistoryPage(store: store)));
    await tester.pumpAndSettle();
    final delete = find.byKey(ValueKey('delete-saved-game-${game.id}'));
    await tester.ensureVisible(delete);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-delete-game')));
    await tester.pumpAndSettle();
    expect(store.games, hasLength(1));
    expect(find.text(S.current.Delete_Game_Failed), findsOneWidget);
    expect(find.byKey(ValueKey('saved-game-${game.id}')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('flipping replay preserves the position and selected move',
      (tester) async {
    await tester.pumpWidget(_app(GameReplayPage(game: _savedGame())));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('replay-next')));
    await tester.tap(find.byKey(const ValueKey('replay-next')));
    await tester.pump();
    final initial = tester.widget<PositionBoard>(find.byType(PositionBoard));
    final fen = chessPositionToFen(initial.board, Player.player2);
    expect(initial.flipped, isFalse);

    await tester.tap(find.byKey(const ValueKey('replay-flip-board')));
    await tester.pump();
    final flipped = tester.widget<PositionBoard>(find.byType(PositionBoard));
    expect(flipped.flipped, isTrue);
    expect(chessPositionToFen(flipped.board, Player.player2), fen);
    expect(find.byKey(const ValueKey('replay-board-1')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('replay-flip-board')));
    await tester.pump();
    expect(tester.widget<PositionBoard>(find.byType(PositionBoard)).flipped,
        isFalse);
    expect(find.byKey(const ValueKey('replay-board-1')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'training progress remains readable on a narrow large-text screen',
      (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_app(
      TrainingHubPage(
        puzzleProgressStore: _PuzzleStore({}),
        openingProgressStore: _OpeningStore({}),
      ),
      textScale: 2,
    ));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('training-openings-button')),
      300,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _solveDaily(WidgetTester tester, DailyPuzzle puzzle) async {
  final move = moveFromUci(puzzle.solution);
  final from = find.byKey(ValueKey('position-tile-${move.from}'));
  await tester.ensureVisible(from);
  await tester.tap(from);
  await tester.pump();
  final destination = find.byKey(ValueKey('position-tile-${move.to}'));
  await tester.ensureVisible(destination);
  await tester.tap(destination);
  await tester.pumpAndSettle();
}

SavedGame _savedGame() => SavedGame.fromPgn(
      '[Result "1-0"]\n\n1. e4 e5 2. Nf3 Nc6 1-0',
      importedAt: DateTime(2026, 10, 23),
    );

Widget _app(Widget home, {double textScale = 1}) => CupertinoApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: child!,
      ),
      home: home,
    );

class _PuzzleStore implements PuzzleLibraryProgressStore {
  final Set<String> ids;
  bool failReads = false;
  _PuzzleStore(this.ids);

  @override
  Future<Set<String>> loadSolvedIds() async {
    if (failReads) throw StateError('unavailable');
    return Set.of(ids);
  }

  @override
  Future<void> markSolved(String puzzleId) async => ids.add(puzzleId);
}

class _OpeningStore implements OpeningProgressStore {
  final Set<String> ids;
  _OpeningStore(this.ids);

  @override
  Future<Set<String>> loadCompletedIds() async => Set.of(ids);

  @override
  Future<void> markCompleted(String openingId) async => ids.add(openingId);
}

class _PendingPuzzleStore implements PuzzleLibraryProgressStore {
  final result = Completer<Set<String>>();
  @override
  Future<Set<String>> loadSolvedIds() => result.future;
  @override
  Future<void> markSolved(String puzzleId) async {}
}

class _PendingOpeningStore implements OpeningProgressStore {
  final result = Completer<Set<String>>();
  @override
  Future<Set<String>> loadCompletedIds() => result.future;
  @override
  Future<void> markCompleted(String openingId) async {}
}

class _HistoryStore implements GameHistoryStore {
  final List<SavedGame> games;
  int deletes = 0;
  bool failDelete = false;
  _HistoryStore(this.games);

  @override
  Future<List<SavedGame>> loadGames() async => List.of(games);

  @override
  Future<void> saveGame(SavedGame game) async => games.add(game);

  @override
  Future<void> deleteGame(String id) async {
    deletes++;
    if (failDelete) throw StateError('unavailable');
    games.removeWhere((game) => game.id == id);
  }
}

class _DailyStore implements PuzzleProgressStore {
  bool failRead = false;
  bool failWrite = false;
  bool saved = false;

  @override
  Future<PuzzleProgress> load(DateTime today) async {
    if (failRead) throw StateError('unavailable');
    return PuzzleProgress(streak: saved ? 1 : 0, solvedToday: saved);
  }

  @override
  Future<PuzzleProgress> markSolved(DateTime today) async {
    if (failWrite) throw StateError('unavailable');
    saved = true;
    return const PuzzleProgress(streak: 1, solvedToday: true);
  }
}
