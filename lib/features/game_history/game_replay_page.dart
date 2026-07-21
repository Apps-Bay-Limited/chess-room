import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flutter/cupertino.dart';

class GameReplayPage extends StatefulWidget {
  final SavedGame game;
  final String pieceTheme;

  const GameReplayPage({
    super.key,
    required this.game,
    this.pieceTheme = 'Classic',
  });

  @override
  State<GameReplayPage> createState() => _GameReplayPageState();
}

class _GameReplayPageState extends State<GameReplayPage> {
  late ChessPosition _position;
  int _moveIndex = 0;

  @override
  void initState() {
    super.initState();
    _rebuildPosition();
  }

  void _rebuildPosition() {
    _position = widget.game.initialFen == standardStartingFen
        ? ChessPosition(ChessBoard(), Player.player1)
        : chessPositionFromFen(widget.game.initialFen);
    for (var index = 0; index < _moveIndex; index++) {
      final move = moveFromUci(widget.game.moves[index]);
      push(move, _position.board, promotionType: move.promotionType);
    }
  }

  void _goToMove(int index) {
    setState(() {
      _moveIndex = index.clamp(0, widget.game.moves.length);
      _rebuildPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final latestMove =
        _moveIndex == 0 ? null : moveFromUci(widget.game.moves[_moveIndex - 1]);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(strings.Game_Replay),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                strings.Move_Of(_moveIndex, widget.game.moves.length),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PositionBoard(
                key: ValueKey('replay-board-$_moveIndex'),
                board: _position.board,
                pieceTheme: widget.pieceTheme,
                highlightedTiles: latestMove == null
                    ? const {}
                    : {latestMove.from, latestMove.to},
              ),
              const SizedBox(height: AppSpacing.xl),
              if (widget.game.moves.isNotEmpty)
                CupertinoSlider(
                  key: const ValueKey('replay-slider'),
                  value: _moveIndex.toDouble(),
                  min: 0,
                  max: widget.game.moves.length.toDouble(),
                  divisions: widget.game.moves.length,
                  activeColor: AppColors.accent,
                  onChanged: (value) => _goToMove(value.round()),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    key: const ValueKey('replay-previous'),
                    onPressed:
                        _moveIndex > 0 ? () => _goToMove(_moveIndex - 1) : null,
                    child: const Icon(CupertinoIcons.backward_end_fill),
                  ),
                  CupertinoButton(
                    key: const ValueKey('replay-next'),
                    onPressed: _moveIndex < widget.game.moves.length
                        ? () => _goToMove(_moveIndex + 1)
                        : null,
                    child: const Icon(CupertinoIcons.forward_end_fill),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
