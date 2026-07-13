import 'dart:math';

import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';

class MoveReviewRecord {
  final int moveIndex;
  final Player player;
  final Move playedMove;
  final Move bestMove;
  final int evaluationLoss;
  final String positionBeforeFen;

  const MoveReviewRecord({
    required this.moveIndex,
    required this.player,
    required this.playedMove,
    required this.bestMove,
    required this.evaluationLoss,
    required this.positionBeforeFen,
  });

  double get pawnsLost => evaluationLoss / 100;

  static MoveReviewRecord analyze({
    required ChessBoard board,
    required Move playedMove,
    required Player player,
    required int moveIndex,
  }) {
    final positionBefore = chessPositionToFen(board, player);
    final candidates = allMoves(player, board, 1);
    final bestMove = candidates.isEmpty ? playedMove : candidates.first;
    final bestEvaluation = _evaluationAfter(board, bestMove);
    final playedEvaluation = _evaluationAfter(board, playedMove);
    final rawLoss = player == Player.player1
        ? bestEvaluation - playedEvaluation
        : playedEvaluation - bestEvaluation;

    return MoveReviewRecord(
      moveIndex: moveIndex,
      player: player,
      playedMove: _copyMove(playedMove),
      bestMove: _copyMove(bestMove),
      evaluationLoss: max(0, rawLoss),
      positionBeforeFen: positionBefore,
    );
  }

  static int _evaluationAfter(ChessBoard board, Move move) {
    push(move, board, promotionType: move.promotionType);
    final evaluation = boardValue(board);
    pop(board);
    return evaluation;
  }

  static Move _copyMove(Move move) =>
      Move(move.from, move.to, promotionType: move.promotionType);
}

String tileName(int tile) {
  final file = String.fromCharCode(97 + tile % 8);
  final rank = 8 - tile ~/ 8;
  return '$file$rank';
}

String readableMove(Move move) =>
    '${tileName(move.from)} → ${tileName(move.to)}';
