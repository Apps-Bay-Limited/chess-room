import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/share_result/result_share_section.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widget_previews.dart';

@Preview(
  name: 'Daily puzzle board',
  group: 'Growth features',
  size: Size(390, 480),
)
Widget dailyPuzzleBoardPreview() {
  final position = chessPositionFromFen(dailyPuzzles.first.fen);
  return CupertinoApp(
    home: CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Mate in One',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PositionBoard(board: position.board),
            ],
          ),
        ),
      ),
    ),
  );
}

@Preview(
  name: 'Share result card',
  group: 'Growth features',
  size: Size(360, 480),
)
Widget resultCardPreview() {
  final position = chessPositionFromFen(
    '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
  );
  return CupertinoApp(
    home: CupertinoPageScaffold(
      backgroundColor: const Color(0xff24201C),
      child: Center(
        child: ResultCard(
          board: position.board,
          result: 'White wins!',
          moveCount: '24 moves',
          pieceTheme: 'Classic',
        ),
      ),
    ),
  );
}
