import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';

class GameReviewPage extends StatefulWidget {
  final MoveReviewRecord? record;
  final List<MoveReviewRecord> records;
  final String pieceTheme;

  const GameReviewPage({
    super.key,
    this.record,
    this.records = const [],
    this.pieceTheme = 'Classic',
  }) : assert(record != null || records.length > 0);

  @override
  State<GameReviewPage> createState() => _GameReviewPageState();
}

class _GameReviewPageState extends State<GameReviewPage> {
  bool _showBestMove = true;
  int _recordIndex = 0;

  List<MoveReviewRecord> get _records =>
      widget.records.isNotEmpty ? widget.records : [widget.record!];

  MoveReviewRecord get _record => _records[_recordIndex];

  void _showRecord(int index) {
    setState(() {
      _recordIndex = index.clamp(0, _records.length - 1);
      _showBestMove = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final record = _record;
    final position = chessPositionFromFen(record.positionBeforeFen);
    final displayedMove = _showBestMove ? record.bestMove : record.playedMove;
    final accent =
        _showBestMove ? CupertinoColors.activeGreen : CupertinoColors.systemRed;

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(strings.Full_Game_Review),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                strings.Review_Move_Title(
                  _recordIndex + 1,
                  _records.length,
                  _classification(strings, record.evaluationLoss),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _explanation(strings, record.evaluationLoss),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                strings.Pawns_Lost(record.pawnsLost.toStringAsFixed(1)),
                style: const TextStyle(color: CupertinoColors.systemGrey2),
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
                flipped: record.player == Player.player2,
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
                      move: readableMove(record.playedMove),
                      color: CupertinoColors.systemRed,
                    ),
                    const SizedBox(height: 12),
                    _MoveComparisonRow(
                      label: strings.Best_Move,
                      move: readableMove(record.bestMove),
                      color: CupertinoColors.activeGreen,
                    ),
                  ],
                ),
              ),
              if (_records.length > 1) ...[
                const SizedBox(height: 18),
                _ReviewTimeline(
                  records: _records,
                  selectedIndex: _recordIndex,
                  onSelected: _showRecord,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      key: const ValueKey('review-previous-move'),
                      onPressed: _recordIndex > 0
                          ? () => _showRecord(_recordIndex - 1)
                          : null,
                      child: Text(strings.Previous),
                    ),
                    CupertinoButton(
                      key: const ValueKey('review-next-move'),
                      onPressed: _recordIndex < _records.length - 1
                          ? () => _showRecord(_recordIndex + 1)
                          : null,
                      child: Text(strings.Next),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTimeline extends StatelessWidget {
  final List<MoveReviewRecord> records;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ReviewTimeline({
    required this.records,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: records.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final loss = records[index].evaluationLoss;
          return CupertinoButton(
            key: ValueKey('review-timeline-$index'),
            padding: EdgeInsets.zero,
            onPressed: () => onSelected(index),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: index == selectedIndex
                    ? const Color(0xffCC996F)
                    : _lossColor(loss).withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Color(0xff24201C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

String _classification(S strings, int loss) {
  if (loss >= 300) return strings.Blunder;
  if (loss >= 100) return strings.Mistake;
  if (loss >= 50) return strings.Inaccuracy;
  return strings.Good_Move;
}

String _explanation(S strings, int loss) {
  if (loss >= 300) return strings.Blunder_Explanation;
  if (loss >= 100) return strings.Mistake_Explanation;
  if (loss >= 50) return strings.Inaccuracy_Explanation;
  return strings.Good_Move_Explanation;
}

Color _lossColor(int loss) {
  if (loss >= 300) return CupertinoColors.systemRed;
  if (loss >= 100) return CupertinoColors.systemOrange;
  if (loss >= 50) return CupertinoColors.systemYellow;
  return CupertinoColors.activeGreen;
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
