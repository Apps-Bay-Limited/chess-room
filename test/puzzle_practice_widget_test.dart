import 'dart:async';

import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_page.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/puzzle_library/puzzle_library_page.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('multi-move daily puzzle awards streak only after the finish',
      (tester) async {
    _mobileViewport(tester);
    final puzzle = dailyPuzzles.firstWhere((puzzle) => puzzle.mateIn == 2);
    final store = _MemoryDailyStore();
    await tester.pumpWidget(_app(DailyPuzzlePage(
      puzzle: puzzle,
      progressStore: store,
      today: DateTime(2026, 10, 16),
    )));
    await tester.pump();
    expect(find.text('Mate in two'), findsOneWidget);
    final first = moveFromUci(puzzle.solution);
    await _tapMove(tester, first.from, first.to);
    expect(store.calls, 0);
    expect(find.byKey(const ValueKey('correct-move')), findsNothing);
    await tester.pump(const Duration(milliseconds: 500));
    expect(store.calls, 0);
    final finish = moveFromUci(puzzle.solutionLine.last);
    await _tapMove(tester, finish.from, finish.to);
    await tester.pumpAndSettle();
    expect(store.calls, 1);
    expect(find.text('Why this works'), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-puzzle-practice')), findsOneWidget);
  });

  testWidgets('daily puzzle fits a small phone with large Arabic text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final puzzle = dailyPuzzles.firstWhere((puzzle) => puzzle.mateIn == 2);
    await tester.pumpWidget(_app(
      DailyPuzzlePage(puzzle: puzzle, progressStore: _MemoryDailyStore()),
      locale: const Locale('ar'),
      textScale: 2,
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(PositionBoard), findsOneWidget);
  });

  testWidgets('hint highlights a piece without completing the daily puzzle',
      (tester) async {
    _mobileViewport(tester);
    final puzzle = dailyPuzzles.first;
    final store = _MemoryDailyStore();
    await tester.pumpWidget(_app(DailyPuzzlePage(
      puzzle: puzzle,
      progressStore: store,
    )));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('daily-puzzle-hint')));
    await tester.tap(find.byKey(const ValueKey('daily-puzzle-hint')));
    await tester.pump();
    final board = tester.widget<PositionBoard>(find.byType(PositionBoard));
    expect(board.highlightedTiles, {moveFromUci(puzzle.solution).from});
    expect(store.calls, 0);
  });

  testWidgets('completed daily puzzle restores its whole combination',
      (tester) async {
    _mobileViewport(tester);
    final puzzle = dailyPuzzles.firstWhere((puzzle) => puzzle.mateIn == 2);
    final store = _MemoryDailyStore()..solved = true;
    await tester.pumpWidget(_app(DailyPuzzlePage(
      puzzle: puzzle,
      progressStore: store,
    )));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('correct-move')), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-puzzle-hint')), findsNothing);
    expect(store.calls, 0);
  });

  for (final flipped in [false, true]) {
    testWidgets('Arabic keeps chess file geometry correct (flipped=$flipped)',
        (tester) async {
      _mobileViewport(tester);
      await tester.pumpWidget(_app(
        Column(children: [
          const Text('Surrounding text', key: ValueKey('rtl-surrounding-text')),
          SizedBox(
            width: 320,
            height: 320,
            child: PositionBoard(board: ChessBoard.empty(), flipped: flipped),
          ),
        ]),
        locale: const Locale('ar'),
      ));
      await tester.pumpAndSettle();
      final leftTile = flipped ? 63 : 0;
      final rightTile = flipped ? 56 : 7;
      final bottomTile = flipped ? 7 : 56;
      final left =
          tester.getCenter(find.byKey(ValueKey('position-tile-$leftTile')));
      final right =
          tester.getCenter(find.byKey(ValueKey('position-tile-$rightTile')));
      final bottom =
          tester.getCenter(find.byKey(ValueKey('position-tile-$bottomTile')));
      expect(left.dx, lessThan(right.dx));
      expect(left.dy, right.dy);
      expect(left.dy, lessThan(bottom.dy));
      expect(
          Directionality.of(tester
              .element(find.byKey(const ValueKey('rtl-surrounding-text')))),
          TextDirection.rtl);
    });
  }

  testWidgets('resume on a new date refreshes the puzzle and progress',
      (tester) async {
    _mobileViewport(tester);
    var current = DateTime(2026, 10, 16, 23, 59);
    final store = _TrackingDailyStore();
    await tester.pumpWidget(_app(DailyPuzzlePage(
      now: () => current,
      progressStore: store,
    )));
    await tester.pump();
    final original = puzzleForDate(current);
    expect(find.byKey(ValueKey('daily-puzzle-${original.id}')), findsOneWidget);
    current = DateTime(2026, 10, 17, 8);
    _resume(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('daily-puzzle-${puzzleForDate(current).id}')),
        findsOneWidget);
    expect(store.loadedDates, [DateTime(2026, 10, 16), DateTime(2026, 10, 17)]);
    expect(find.byKey(const ValueKey('correct-move')), findsNothing);
  });

  testWidgets('an explicitly supplied date remains fixed after resume',
      (tester) async {
    _mobileViewport(tester);
    var current = DateTime(2026, 10, 16);
    final store = _TrackingDailyStore();
    await tester.pumpWidget(_app(DailyPuzzlePage(
      today: current,
      now: () => current,
      progressStore: store,
    )));
    await tester.pump();
    final original = puzzleForDate(current);
    current = DateTime(2026, 10, 17);
    _resume(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('daily-puzzle-${original.id}')), findsOneWidget);
    expect(store.loadedDates, [DateTime(2026, 10, 16)]);
  });

  testWidgets('an old progress read cannot complete the next date puzzle',
      (tester) async {
    _mobileViewport(tester);
    var current = DateTime(2026, 10, 16);
    final store = _ControlledDailyStore();
    await tester.pumpWidget(_app(DailyPuzzlePage(
      now: () => current,
      progressStore: store,
    )));
    await tester.pump();
    final oldRead = store.loads[current]!;
    current = DateTime(2026, 10, 17);
    _resume(tester);
    await tester.pump();
    store.loads[current]!
        .complete(const PuzzleProgress(streak: 3, solvedToday: false));
    await tester.pump();
    oldRead.complete(const PuzzleProgress(streak: 99, solvedToday: true));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('daily-puzzle-${puzzleForDate(current).id}')),
        findsOneWidget);
    expect(find.byKey(const ValueKey('correct-move')), findsNothing);
    expect(find.textContaining('Streak: 3'), findsOneWidget);
    expect(find.textContaining('99'), findsNothing);
  });

  testWidgets('an old delayed defense cannot move the next date board',
      (tester) async {
    _mobileViewport(tester);
    var current = _dateForMateIn(2);
    final store = _TrackingDailyStore();
    final puzzle = puzzleForDate(current);
    await tester.pumpWidget(_app(DailyPuzzlePage(
      now: () => current,
      progressStore: store,
    )));
    await tester.pump();
    final first = moveFromUci(puzzle.solution);
    await _tapMove(tester, first.from, first.to);
    current = current.add(const Duration(days: 1));
    _resume(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final newPuzzle = puzzleForDate(current);
    final board = tester.widget<PositionBoard>(
        find.byKey(ValueKey('daily-puzzle-${newPuzzle.id}')));
    expect(board.highlightedTiles, isEmpty);
    expect(
        chessPositionToFen(
            board.board, chessPositionFromFen(newPuzzle.fen).activePlayer),
        newPuzzle.fen);
    expect(store.markedDates, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a completed old save cannot replace the new date streak',
      (tester) async {
    _mobileViewport(tester);
    var current = _dateForMateIn(1);
    final oldDate = current;
    final save = Completer<PuzzleProgress>();
    final store = _TrackingDailyStore(save: save);
    final puzzle = puzzleForDate(current);
    await tester.pumpWidget(_app(DailyPuzzlePage(
      now: () => current,
      progressStore: store,
    )));
    await tester.pump();
    final move = moveFromUci(puzzle.solution);
    await _tapMove(tester, move.from, move.to);
    expect(store.markedDates, [oldDate]);
    current = current.add(const Duration(days: 1));
    _resume(tester);
    await tester.pump();
    save.complete(const PuzzleProgress(streak: 99, solvedToday: true));
    await tester.pumpAndSettle();
    expect(find.textContaining('99'), findsNothing);
    expect(find.byKey(const ValueKey('correct-move')), findsNothing);
    expect(store.markedDates, [oldDate]);
  });

  testWidgets('library resumes with an unsolved puzzle in the chosen theme',
      (tester) async {
    _mobileViewport(tester);
    final puzzles = themedPuzzles
        .where((puzzle) => puzzle.theme == PuzzleTheme.fork)
        .toList();
    final store = _MemoryLibraryStore()..ids.add(puzzles.first.id);
    await tester.pumpWidget(_app(PuzzleSessionPage(
      theme: PuzzleTheme.fork,
      progressStore: store,
    )));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('library-puzzle-${puzzles[1].id}')),
        findsOneWidget);
  });
}

void _mobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _tapMove(WidgetTester tester, int from, int to) async {
  await tester.ensureVisible(find.byKey(ValueKey('position-tile-$from')));
  await tester.tap(find.byKey(ValueKey('position-tile-$from')));
  await tester.tap(find.byKey(ValueKey('position-tile-$to')));
  await tester.pump();
}

Widget _app(Widget home, {Locale? locale, double textScale = 1}) =>
    CupertinoApp(
      locale: locale,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: child!,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: home,
    );

class _MemoryDailyStore implements PuzzleProgressStore {
  bool solved = false;
  int calls = 0;
  @override
  Future<PuzzleProgress> load(DateTime today) async =>
      PuzzleProgress(streak: solved ? 1 : 0, solvedToday: solved);
  @override
  Future<PuzzleProgress> markSolved(DateTime today) async {
    calls++;
    solved = true;
    return const PuzzleProgress(streak: 1, solvedToday: true);
  }
}

class _MemoryLibraryStore implements PuzzleLibraryProgressStore {
  final ids = <String>{};
  @override
  Future<Set<String>> loadSolvedIds() async => Set.of(ids);
  @override
  Future<void> markSolved(String puzzleId) async => ids.add(puzzleId);
}

void _resume(WidgetTester tester) {
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
}

DateTime _dateForMateIn(int moves) {
  final first = DateTime(2026, 10, 16);
  for (var offset = 0; offset < dailyPuzzles.length; offset++) {
    final date = first.add(Duration(days: offset));
    if (puzzleForDate(date).mateIn == moves) return date;
  }
  throw StateError('No suitable date');
}

class _TrackingDailyStore implements PuzzleProgressStore {
  final loadedDates = <DateTime>[];
  final markedDates = <DateTime>[];
  final Completer<PuzzleProgress>? save;
  _TrackingDailyStore({this.save});
  @override
  Future<PuzzleProgress> load(DateTime today) async {
    loadedDates.add(today);
    return const PuzzleProgress(streak: 0, solvedToday: false);
  }

  @override
  Future<PuzzleProgress> markSolved(DateTime today) {
    markedDates.add(today);
    return save?.future ??
        Future.value(const PuzzleProgress(streak: 1, solvedToday: true));
  }
}

class _ControlledDailyStore implements PuzzleProgressStore {
  final loads = <DateTime, Completer<PuzzleProgress>>{};
  @override
  Future<PuzzleProgress> load(DateTime today) =>
      (loads[today] = Completer<PuzzleProgress>()).future;
  @override
  Future<PuzzleProgress> markSolved(DateTime today) async =>
      const PuzzleProgress(streak: 1, solvedToday: true);
}
