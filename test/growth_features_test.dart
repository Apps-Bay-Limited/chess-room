import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_tip.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('daily puzzles', () {
    for (final puzzle in dailyPuzzles) {
      test('${puzzle.id} has a legal checkmating solution', () {
        final position = chessPositionFromFen(puzzle.fen);
        final move = moveFromUci(puzzle.solution);
        final piece = position.board.tiles[move.from];

        expect(piece, isNotNull);
        expect(piece!.player, position.activePlayer);
        expect(movesForPiece(piece, position.board), contains(move.to));

        push(move, position.board);
        final opponent = position.activePlayer == Player.player1
            ? Player.player2
            : Player.player1;
        expect(kingInCheck(opponent, position.board), isTrue);
        expect(hasNoLegalMoves(opponent, position.board), isTrue);
      });
    }

    test('puzzle selection is stable for a calendar date', () {
      final morning = DateTime(2026, 7, 13, 8);
      final evening = DateTime(2026, 7, 13, 22);

      expect(puzzleForDate(morning).id, puzzleForDate(evening).id);
    });
  });

  group('daily puzzle streak', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('increments on consecutive days and does not double count', () async {
      final store = SharedPreferencesPuzzleProgressStore();

      final first = await store.markSolved(DateTime(2026, 7, 12));
      final duplicate = await store.markSolved(DateTime(2026, 7, 12));
      final second = await store.markSolved(DateTime(2026, 7, 13));

      expect(first.streak, 1);
      expect(duplicate.streak, 1);
      expect(second.streak, 2);
      expect(second.solvedToday, isTrue);
    });

    test('resets after a missed day', () async {
      final store = SharedPreferencesPuzzleProgressStore();
      await store.markSolved(DateTime(2026, 7, 10));

      final progress = await store.markSolved(DateTime(2026, 7, 13));

      expect(progress.streak, 1);
    });
  });

  test('review finds a materially better move', () {
    final position = chessPositionFromFen(
      'q6k/8/8/8/8/8/8/Q6K w - - 0 1',
    );
    final played = moveFromUci('a1a2');

    final review = MoveReviewRecord.analyze(
      board: position.board,
      playedMove: played,
      player: Player.player1,
      moveIndex: 0,
    );

    expect(readableMove(review.bestMove), 'a1 → a8');
    expect(review.evaluationLoss, greaterThanOrEqualTo(800));
    expect(
      chessPositionToFen(position.board, Player.player1),
      'q6k/8/8/8/8/8/8/Q6K w - - 0 1',
    );
  });

  test('tip searches deeper than every selectable AI difficulty', () {
    for (final difficulty in <int>[1, 3, 5, 6]) {
      expect(tipSearchDepth(difficulty), greaterThan(difficulty));
    }
  });

  test('tip uses the alpha-beta engine to select its move', () {
    final position = chessPositionFromFen(
      'q6k/8/8/8/8/8/8/Q6K w - - 0 1',
    );

    final tip = calculateTipMove({
      'board': position.board,
      'player': Player.player1,
      'searchDepth': 3,
    });

    expect(tip, isNotNull);
    expect(readableMove(tip!), 'a1 → a8');
  });

  test('deeper tip finds a checkmate missed by the old one-ply hint', () {
    final puzzle = dailyPuzzles.firstWhere(
      (candidate) => candidate.id == 'back-rank-e8',
    );
    final position = chessPositionFromFen(puzzle.fen);
    final oldTip = allMoves(
      position.activePlayer,
      position.board,
      1,
    ).first;
    final deeperTip = calculateTipMove({
      'board': position.board,
      'player': position.activePlayer,
      'searchDepth': 3,
    });

    expect(oldTip, isNot(moveFromUci(puzzle.solution)));
    expect(deeperTip, moveFromUci(puzzle.solution));
  });
}
