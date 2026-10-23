import 'dart:async';

import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:chess_room/features/opening_trainer/opening_trainer_page.dart';
import 'package:chess_room/features/puzzle_library/puzzle_library_page.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
      'opening and library retries recover while review accounting is blocked',
      (tester) async {
    final reviewGate = await _holdReviewAccounting();
    try {
      final store = _OpeningStore();
      await tester.pumpWidget(_app(OpeningSessionPage(
        course: const OpeningCourse(id: OpeningId.italian, moves: ['e2e4']),
        progressStore: store,
      )));
      await tester.pumpAndSettle();
      await _move(tester, 52, 36);
      expect(find.text(S.current.Opening_Complete), findsOneWidget);
      expect(
          find.text(S.current.Training_Progress_Unavailable), findsOneWidget);
      expect(store.completed, isEmpty);
      final before = _boardFen(tester);
      store.failWrites = false;
      final retry = find.byKey(const ValueKey('retry-opening-completion'));
      await tester.ensureVisible(retry);
      final button = tester.widget<CupertinoButton>(retry);
      button.onPressed!();
      button.onPressed!();
      await tester.pumpAndSettle();
      expect(store.completed, {'italian'});
      expect(store.attempts, 2);
      expect(_boardFen(tester), before);
      expect(find.text(S.current.Training_Progress_Unavailable), findsNothing);
      expect(
          tester
              .widget<CupertinoButton>(
                  find.byKey(const ValueKey('restart-opening')))
              .onPressed,
          isNotNull);
      expect(tester.takeException(), isNull);
    } finally {
      await reviewGate.release(tester);
    }
    await tester.pumpWidget(const SizedBox.shrink());
    final libraryReviewGate = await _holdReviewAccounting();
    try {
      final store = _LibraryStore();
      await tester.pumpWidget(_app(PuzzleSessionPage(
        theme: PuzzleTheme.fork,
        progressStore: store,
      )));
      await tester.pumpAndSettle();
      await _move(tester, 27, 21);
      expect(find.text(S.current.Puzzle_Complete), findsOneWidget);
      expect(
          find.text(S.current.Training_Progress_Unavailable), findsOneWidget);
      expect(store.solved, isEmpty);

      final next = find.byKey(const ValueKey('next-library-puzzle'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('library-puzzle-fork-knight-c7')),
          findsOneWidget);
      final before = _boardFen(tester);
      store.failWrites = false;
      final retry = find.byKey(const ValueKey('retry-library-progress'));
      await tester.ensureVisible(retry);
      final button = tester.widget<CupertinoButton>(retry);
      button.onPressed!();
      button.onPressed!();
      await tester.pumpAndSettle();
      expect(store.solved, {'fork-knight-f6'});
      expect(store.attempts, 2);
      expect(_boardFen(tester), before);
      expect(find.byKey(const ValueKey('library-puzzle-fork-knight-c7')),
          findsOneWidget);
      expect(find.text(S.current.Training_Progress_Unavailable), findsNothing);
      expect(tester.takeException(), isNull);
    } finally {
      await libraryReviewGate.release(tester);
    }
  });

  testWidgets('library pauses puzzle input until a progress retry finishes',
      (tester) async {
    final store = _PendingReadLibraryStore();
    await tester.pumpWidget(_app(PuzzleSessionPage(
      theme: PuzzleTheme.fork,
      progressStore: store,
    )));
    await tester.pumpAndSettle();
    final originalBoard =
        tester.widget<PositionBoard>(find.byType(PositionBoard));
    final retainedTap = originalBoard.onTileTap!;
    final before = _boardFen(tester);
    final retry = find.byKey(const ValueKey('retry-library-progress'));
    await tester.ensureVisible(retry);
    await tester.tap(retry);
    await tester.pump();
    expect(tester.widget<PositionBoard>(find.byType(PositionBoard)).onTileTap,
        isNull);
    retainedTap(27);
    retainedTap(21);
    await tester.pump();
    expect(_boardFen(tester), before);
    expect(store.solved, isEmpty);

    store.retryRead.complete({});
    await tester.pumpAndSettle();
    await _move(tester, 27, 21);
    expect(store.solved, {'fork-knight-f6'});
    expect(find.text(S.current.Puzzle_Complete), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<_ReviewAccountingGate> _holdReviewAccounting() async =>
    _ReviewAccountingGate(await SharedPreferences.getInstance());

class _ReviewAccountingGate {
  final SharedPreferences _preferences;
  final _gate = Completer<SharedPreferences>();

  _ReviewAccountingGate(this._preferences) {
    unawaited(InAppReviewHelper(preferences: () => _gate.future).initialize());
  }

  Future<void> release(WidgetTester tester) async {
    _gate.complete(_preferences);
    var drained = false;
    final drain = InAppReviewHelper.shared.initialize().then<void>((_) {
      drained = true;
    });
    // Release and drain in the WidgetTester's FakeAsync zone. Awaiting these
    // queued futures from addTearDown cannot advance that zone's microtasks.
    for (var attempt = 0; attempt < 20 && !drained; attempt++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
    }
    expect(drained, isTrue, reason: 'Review accounting queue did not drain.');
    await drain;
  }
}

Future<void> _move(WidgetTester tester, int from, int to) async {
  final source = find.byKey(ValueKey('position-tile-$from'));
  await tester.ensureVisible(source);
  await tester.tap(source);
  await tester.tap(find.byKey(ValueKey('position-tile-$to')));
  await tester.pumpAndSettle();
}

String _boardFen(WidgetTester tester) => chessPositionToFen(
    tester.widget<PositionBoard>(find.byType(PositionBoard)).board,
    Player.player1);

Widget _app(Widget home) => CupertinoApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: home,
    );

class _OpeningStore implements OpeningProgressStore {
  final Set<String> completed = {};
  bool failWrites = true;
  int attempts = 0;

  @override
  Future<Set<String>> loadCompletedIds() async => Set.of(completed);

  @override
  Future<void> markCompleted(String openingId) async {
    attempts++;
    if (failWrites) throw StateError('unavailable');
    completed.add(openingId);
  }
}

class _LibraryStore implements PuzzleLibraryProgressStore {
  final Set<String> solved = {};
  bool failWrites = true;
  int attempts = 0;

  @override
  Future<Set<String>> loadSolvedIds() async => Set.of(solved);

  @override
  Future<void> markSolved(String puzzleId) async {
    attempts++;
    if (failWrites) throw StateError('unavailable');
    solved.add(puzzleId);
  }
}

class _PendingReadLibraryStore implements PuzzleLibraryProgressStore {
  final retryRead = Completer<Set<String>>();
  final Set<String> solved = {};
  int reads = 0;

  @override
  Future<Set<String>> loadSolvedIds() async {
    reads++;
    if (reads == 1) throw StateError('unavailable');
    return retryRead.future;
  }

  @override
  Future<void> markSolved(String puzzleId) async => solved.add(puzzleId);
}
