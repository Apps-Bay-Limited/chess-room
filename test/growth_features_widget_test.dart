import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_page.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/game_review/game_review_page.dart';
import 'package:chess_room/features/share_result/result_share_section.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('daily puzzle accepts the solution and updates the streak',
      (tester) async {
    final store = _MemoryPuzzleProgressStore();
    await tester.pumpWidget(
      _localizedApp(
        DailyPuzzlePage(
          puzzle: dailyPuzzles.first,
          today: DateTime(2026, 7, 13),
          progressStore: store,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('position-tile-23')));
    await tester.tap(find.byKey(const ValueKey('position-tile-14')));
    await tester.pumpAndSettle();

    expect(find.text('Correct! Checkmate.'), findsOneWidget);
    expect(find.textContaining('Streak: 1'), findsOneWidget);
    expect(store.markSolvedCalls, 1);
  });

  testWidgets('daily puzzle gives feedback for an incorrect move',
      (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        DailyPuzzlePage(
          puzzle: dailyPuzzles.first,
          today: DateTime(2026, 7, 13),
          progressStore: _MemoryPuzzleProgressStore(),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('position-tile-23')));
    await tester.tap(find.byKey(const ValueKey('position-tile-31')));
    await tester.pump();

    expect(find.text('Not quite — try again'), findsOneWidget);
  });

  testWidgets('review toggles between played and best moves', (tester) async {
    final record = MoveReviewRecord(
      moveIndex: 0,
      player: Player.player1,
      playedMove: moveFromUci('a1a2'),
      bestMove: moveFromUci('a1a8'),
      evaluationLoss: 900,
      positionBeforeFen: 'q6k/8/8/8/8/8/8/Q6K w - - 0 1',
    );
    await tester.pumpWidget(
      _localizedApp(GameReviewPage(record: record)),
    );

    expect(find.text('a1 → a8'), findsOneWidget);
    expect(find.text('a1 → a2'), findsOneWidget);
    expect(find.byKey(const ValueKey('review-best-board')), findsOneWidget);
    await tester.tap(find.text('Played').first);
    await tester.pump();

    expect(find.byKey(const ValueKey('review-played-board')), findsOneWidget);
  });

  testWidgets('result card renders the branded result and move count',
      (tester) async {
    final board = chessPositionFromFen(
      '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
    ).board;
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: ResultCard(
            board: board,
            result: 'White wins!',
            moveCount: '24 moves',
            pieceTheme: 'Classic',
          ),
        ),
      ),
    );

    expect(find.text('CHESS ROOM'), findsOneWidget);
    expect(find.text('White wins!'), findsOneWidget);
    expect(find.text('24 moves'), findsOneWidget);
  });
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
    home: home,
  );
}

class _MemoryPuzzleProgressStore implements PuzzleProgressStore {
  int streak = 0;
  bool solved = false;
  int markSolvedCalls = 0;

  @override
  Future<PuzzleProgress> load(DateTime today) async {
    return PuzzleProgress(streak: streak, solvedToday: solved);
  }

  @override
  Future<PuzzleProgress> markSolved(DateTime today) async {
    markSolvedCalls++;
    if (!solved) {
      solved = true;
      streak++;
    }
    return PuzzleProgress(streak: streak, solvedToday: solved);
  }
}
