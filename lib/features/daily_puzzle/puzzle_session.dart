import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';
import 'package:chess_room/logic/shared_functions.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';

/// Plays an authored alternating line without counting an opponent's reply as
/// another puzzle. The page controls the brief delay before [playReply].
class PuzzleSession {
  final ChessPosition position;
  final List<String> solutionLine;
  final bool checkmateGoal;
  int _ply = 0;
  Move? lastMove;

  PuzzleSession({
    required String fen,
    required List<String> solutionLine,
    this.checkmateGoal = true,
  })  : position = chessPositionFromFen(fen),
        solutionLine = List.of(solutionLine) {
    assert(solutionLine.isNotEmpty && solutionLine.length.isOdd);
  }

  Player get player => position.activePlayer;
  bool get isComplete => _ply == solutionLine.length;
  bool get awaitingReply => !isComplete && _ply.isOdd;
  int get movesPlayed => (_ply + 1) ~/ 2;
  Move get expectedMove => moveFromUci(solutionLine[_ply]);

  bool tryMove(int from, int to) {
    if (isComplete || awaitingReply) return false;
    final expected = expectedMove;
    if (from == expected.from && to == expected.to) {
      _apply(expected);
      return true;
    }

    // Equivalent winning moves remain correct even when the authored defense
    // creates more than one finish, or another first move also forces mate.
    if (checkmateGoal) {
      final piece = position.board.tiles[from];
      if (piece?.player != player ||
          !movesForPiece(piece!, position.board).contains(to)) {
        return false;
      }
      final alternative = Move(from, to);
      push(alternative, position.board);
      final opponent = oppositePlayer(player);
      final mates = kingInCheck(opponent, position.board) &&
          hasNoLegalMoves(opponent, position.board);
      final continuation = !mates && solutionLine.length - _ply == 3
          ? _forcedMateContinuation()
          : null;
      pop(position.board);
      if (mates) {
        _apply(alternative);
        _ply = solutionLine.length;
        return true;
      }
      if (continuation != null) {
        solutionLine[_ply] = moveToUci(alternative);
        solutionLine.setRange(_ply + 1, _ply + 3, continuation);
        _apply(alternative);
        return true;
      }
    }
    return false;
  }

  /// The attempted first move has already been applied. A move qualifies only
  /// when every legal defense permits a legal checkmate on the next turn.
  List<String>? _forcedMateContinuation() {
    final defender = oppositePlayer(player);
    final replies = allMoves(defender, position.board, 1);
    if (replies.isEmpty) return null;
    List<String>? displayedLine;
    for (final reply in replies) {
      push(reply, position.board, promotionType: reply.promotionType);
      Move? mate;
      for (final candidate in allMoves(player, position.board, 1)) {
        push(candidate, position.board, promotionType: candidate.promotionType);
        final wins = kingInCheck(defender, position.board) &&
            hasNoLegalMoves(defender, position.board);
        pop(position.board);
        if (wins) {
          mate = candidate;
          break;
        }
      }
      pop(position.board);
      if (mate == null) return null;
      displayedLine ??= [moveToUci(reply), moveToUci(mate)];
    }
    return displayedLine;
  }

  void playReply() {
    if (awaitingReply) _apply(expectedMove);
  }

  void showCompletedLine() {
    while (!isComplete) {
      _apply(expectedMove);
    }
  }

  void _apply(Move move) {
    push(move, position.board, promotionType: move.promotionType);
    lastMove = move;
    _ply++;
  }
}
