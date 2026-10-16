import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_session.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/logic/shared_functions.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('offline daily bank has varied content beyond a weekly rotation', () {
    expect(dailyPuzzles.length, greaterThanOrEqualTo(60));
    expect(dailyPuzzles.map((puzzle) => puzzle.id).toSet().length,
        dailyPuzzles.length);
    expect(dailyPuzzles.map((puzzle) => puzzle.fen).toSet().length,
        dailyPuzzles.length);
    expect(dailyPuzzles.map((puzzle) => puzzle.motif).toSet().length,
        greaterThanOrEqualTo(6));
    expect(dailyPuzzles.map((puzzle) => puzzle.difficulty).toSet(),
        PuzzleDifficulty.values.toSet());
    expect(
        dailyPuzzles.where((puzzle) => puzzle.continuation.isNotEmpty).length,
        greaterThanOrEqualTo(10));
    expect(dailyPuzzles.where((puzzle) => puzzle.fen.contains(' b ')).length,
        greaterThanOrEqualTo(10));
    // Reflections have identical material: require many different material sets
    // as well as different positions so expanding the bank is substantive.
    final material = dailyPuzzles.map((puzzle) {
      final pieces = puzzle.fen
          .split(' ')
          .first
          .replaceAll(RegExp('[^a-zA-Z]'), '')
          .split('')
        ..sort();
      return pieces.join();
    }).toSet();
    expect(material.length, greaterThanOrEqualTo(20));
  });

  test('daily selection does not repeat during the first bank cycle', () {
    final first = DateTime(2026, 1, 1);
    final ids = <String>{};
    for (var day = 0; day < dailyPuzzles.length; day++) {
      ids.add(puzzleForDate(first.add(Duration(days: day))).id);
    }
    expect(ids.length, dailyPuzzles.length);
    expect(puzzleForDate(first).id,
        isNot(puzzleForDate(first.add(const Duration(days: 7))).id));
  });

  for (final puzzle in dailyPuzzles) {
    test('${puzzle.id} is legal and ends with checkmate', () {
      final position = chessPositionFromFen(puzzle.fen);
      expect(kingInCheck(Player.player1, position.board), isFalse);
      expect(kingInCheck(Player.player2, position.board), isFalse);
      var player = position.activePlayer;
      for (final uci in puzzle.solutionLine) {
        final move = moveFromUci(uci);
        final piece = position.board.tiles[move.from];
        expect(piece, isNotNull, reason: uci);
        expect(piece!.player, player, reason: uci);
        expect(movesForPiece(piece, position.board), contains(move.to),
            reason: uci);
        push(move, position.board, promotionType: move.promotionType);
        player = oppositePlayer(player);
      }
      expect(kingInCheck(player, position.board), isTrue);
      expect(hasNoLegalMoves(player, position.board), isTrue);
    });

    if (puzzle.continuation.isNotEmpty) {
      test('${puzzle.id} wins against every legal defensive reply', () {
        final position = chessPositionFromFen(puzzle.fen);
        final attackingPlayer = position.activePlayer;
        final first = moveFromUci(puzzle.solution);
        push(first, position.board, promotionType: first.promotionType);
        final defender = oppositePlayer(attackingPlayer);
        expect(kingInCheck(defender, position.board), isTrue);
        final replies = allMoves(defender, position.board, 1);
        expect(replies, isNotEmpty);
        for (final reply in replies) {
          push(reply, position.board, promotionType: reply.promotionType);
          var hasMate = false;
          for (final finish in allMoves(attackingPlayer, position.board, 1)) {
            push(finish, position.board, promotionType: finish.promotionType);
            final mates = kingInCheck(defender, position.board) &&
                hasNoLegalMoves(defender, position.board);
            pop(position.board);
            if (mates) {
              hasMate = true;
              break;
            }
          }
          expect(hasMate, isTrue,
              reason: '${puzzle.id}: defense ${reply.from}-${reply.to}');
          pop(position.board);
        }
      });
    }
  }

  test('library preserves original IDs and adds the daily compositions', () {
    expect(themedPuzzles.length, greaterThan(dailyPuzzles.length));
    expect(
        themedPuzzles.map((puzzle) => puzzle.id),
        containsAll([
          'mate-queen-g7',
          'fork-knight-f6',
          'promote-white-e8',
          'original-combination-01',
        ]));
    for (final theme in PuzzleTheme.values) {
      expect(
          themedPuzzles.where((puzzle) => puzzle.theme == theme), isNotEmpty);
    }
  });

  test('concurrent library completions retain both solved IDs', () async {
    SharedPreferences.setMockInitialValues({});
    final first = SharedPreferencesPuzzleLibraryProgressStore();
    final second = SharedPreferencesPuzzleLibraryProgressStore();
    await Future.wait([
      first.markSolved('first'),
      second.markSolved('second'),
    ]);
    expect(await first.loadSolvedIds(), {'first', 'second'});
  });

  test('library progress tolerates malformed or wrong-shape stored data',
      () async {
    for (final encoded in ['{', '{}', 'null', '[1, "valid"]']) {
      SharedPreferences.setMockInitialValues({
        'puzzle_library_solved_v1': encoded,
      });
      final store = SharedPreferencesPuzzleLibraryProgressStore();
      expect(await store.loadSolvedIds(),
          encoded.startsWith('[') ? {'valid'} : isEmpty);
    }
  });

  test('session accepts an alternative legal checkmating finish', () {
    // Both Qf8# and Qh7# mate. An authored UCI move is not the only answer.
    final puzzle = dailyPuzzles.firstWhere((puzzle) => puzzle.id == 'queen-f8');
    final session = PuzzleSession(
      fen: puzzle.fen,
      solutionLine: puzzle.solutionLine,
    );
    final alternative = moveFromUci('h6h7');
    expect(session.tryMove(alternative.from, alternative.to), isTrue);
    expect(session.isComplete, isTrue);
    expect(kingInCheck(Player.player2, session.position.board), isTrue);
    expect(hasNoLegalMoves(Player.player2, session.position.board), isTrue);
  });

  test('session rejects mistakes and counts a full combination once', () {
    final puzzle = dailyPuzzles.firstWhere((puzzle) => puzzle.mateIn == 2);
    final session = PuzzleSession(
      fen: puzzle.fen,
      solutionLine: puzzle.solutionLine,
    );
    expect(session.tryMove(0, 0), isFalse);
    expect(session.movesPlayed, 0);
    final first = moveFromUci(puzzle.solution);
    expect(session.tryMove(first.from, first.to), isTrue);
    expect(session.isComplete, isFalse);
    expect(session.awaitingReply, isTrue);
    expect(session.tryMove(first.from, first.to), isFalse);
    session.playReply();
    expect(session.awaitingReply, isFalse);
    final finish = moveFromUci(puzzle.solutionLine.last);
    expect(session.tryMove(finish.from, finish.to), isTrue);
    expect(session.isComplete, isTrue);
    expect(session.movesPlayed, 2);
  });
}
