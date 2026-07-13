import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';

class GameReviewPage extends StatefulWidget {
  final MoveReviewRecord record;
  final String pieceTheme;

  const GameReviewPage({
    super.key,
    required this.record,
    this.pieceTheme = 'Classic',
  });

  @override
  State<GameReviewPage> createState() => _GameReviewPageState();
}

class _GameReviewPageState extends State<GameReviewPage> {
  bool _showBestMove = true;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final position = chessPositionFromFen(widget.record.positionBeforeFen);
    final displayedMove =
        _showBestMove ? widget.record.bestMove : widget.record.playedMove;
    final accent =
        _showBestMove ? CupertinoColors.activeGreen : CupertinoColors.systemRed;

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(strings.Biggest_Mistake),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                strings.Pawns_Lost(
                  widget.record.pawnsLost.toStringAsFixed(1),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              CupertinoSlidingSegmentedControl<bool>(
                groupValue: _showBestMove,
                children: {
                  false: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(strings.Played_Move),
                  ),
                  true: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(strings.Best_Move),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() => _showBestMove = value);
                  }
                },
              ),
              const SizedBox(height: 20),
              PositionBoard(
                key: ValueKey(
                  _showBestMove ? 'review-best-board' : 'review-played-board',
                ),
                board: position.board,
                pieceTheme: widget.pieceTheme,
                flipped: widget.record.player == Player.player2,
                highlightedTiles: {displayedMove.from, displayedMove.to},
                highlightColor: accent.withValues(alpha: 0.65),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0x33000000),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _MoveComparisonRow(
                      label: strings.Played_Move,
                      move: readableMove(widget.record.playedMove),
                      color: CupertinoColors.systemRed,
                    ),
                    const SizedBox(height: 12),
                    _MoveComparisonRow(
                      label: strings.Best_Move,
                      move: readableMove(widget.record.bestMove),
                      color: CupertinoColors.activeGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoveComparisonRow extends StatelessWidget {
  final String label;
  final String move;
  final Color color;

  const _MoveComparisonRow({
    required this.label,
    required this.move,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label)),
        Text(
          move,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
