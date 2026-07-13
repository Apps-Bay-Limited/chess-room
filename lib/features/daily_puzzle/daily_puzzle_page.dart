import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';

class DailyPuzzlePage extends StatefulWidget {
  final DailyPuzzle? puzzle;
  final DateTime? today;
  final PuzzleProgressStore? progressStore;
  final String pieceTheme;

  const DailyPuzzlePage({
    super.key,
    this.puzzle,
    this.today,
    this.progressStore,
    this.pieceTheme = 'Classic',
  });

  @override
  State<DailyPuzzlePage> createState() => _DailyPuzzlePageState();
}

class _DailyPuzzlePageState extends State<DailyPuzzlePage> {
  late final DateTime _today;
  late final DailyPuzzle _puzzle;
  late final PuzzleProgressStore _progressStore;
  late ChessPosition _position;
  int? _selectedTile;
  int _streak = 0;
  bool _solved = false;
  bool _wrongMove = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _today = widget.today ?? DateTime.now();
    _puzzle = widget.puzzle ?? puzzleForDate(_today);
    _progressStore =
        widget.progressStore ?? SharedPreferencesPuzzleProgressStore();
    _position = chessPositionFromFen(_puzzle.fen);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await _progressStore.load(_today);
    if (!mounted) return;
    setState(() {
      _streak = progress.streak;
      _solved = progress.solvedToday;
      _loading = false;
      if (_solved) {
        _applySolution();
      }
    });
  }

  void _onTileTap(int tile) {
    if (_loading || _solved) return;
    final selectedPiece = _position.board.tiles[tile];
    if (_selectedTile == null) {
      if (selectedPiece?.player == _position.activePlayer) {
        setState(() {
          _selectedTile = tile;
          _wrongMove = false;
        });
      }
      return;
    }

    if (_selectedTile == tile) {
      setState(() => _selectedTile = null);
      return;
    }

    final expectedMove = moveFromUci(_puzzle.solution);
    final attemptedMove = Move(_selectedTile!, tile);
    if (attemptedMove == expectedMove) {
      _solve(expectedMove);
    } else {
      setState(() {
        _selectedTile = null;
        _wrongMove = true;
      });
    }
  }

  Future<void> _solve(Move move) async {
    push(move, _position.board);
    setState(() {
      _selectedTile = null;
      _solved = true;
      _wrongMove = false;
    });
    final progress = await _progressStore.markSolved(_today);
    if (!mounted) return;
    setState(() => _streak = progress.streak);
  }

  void _applySolution() {
    final move = moveFromUci(_puzzle.solution);
    if (_position.board.tiles[move.from] != null) {
      push(move, _position.board);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        leading: CupertinoNavigationBarBackButton(
          key: const ValueKey('daily-puzzle-back-button'),
          color: AppColors.accent,
          onPressed: () => Navigator.maybePop(context),
        ),
        middle: Text(strings.Daily_Puzzle),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    strings.Mate_In_One,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x33000000),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('🔥 ${strings.Puzzle_Streak(_streak)}'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _solved ? strings.Puzzle_Solved : strings.Puzzle_Instruction,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              PositionBoard(
                board: _position.board,
                pieceTheme: widget.pieceTheme,
                flipped: _position.activePlayer == Player.player2,
                selectedTile: _selectedTile,
                highlightedTiles: _solved
                    ? {
                        moveFromUci(_puzzle.solution).from,
                        moveFromUci(_puzzle.solution).to,
                      }
                    : const {},
                onTileTap: _onTileTap,
              ),
              const SizedBox(height: 18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _wrongMove
                    ? Text(
                        strings.Try_Again,
                        key: const ValueKey('wrong-move'),
                        style: const TextStyle(
                          color: CupertinoColors.systemOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : _solved
                        ? Text(
                            strings.Correct,
                            key: const ValueKey('correct-move'),
                            style: const TextStyle(
                              color: CupertinoColors.activeGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
