import 'dart:math';

import 'package:chess_room/logic/move_calculation/ai_move_calculation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';

int tipSearchDepth(int currentDifficulty) {
  return max(3, currentDifficulty + 1);
}

Move? calculateTipMove(Map args) {
  return calculateBestMove(
    args['board'],
    args['player'],
    args['searchDepth'],
  );
}
