import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_labels.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_session.dart';
import 'package:chess_room/features/puzzle_library/puzzle_library_page.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';

class DailyPuzzlePage extends StatefulWidget {
  final DailyPuzzle? puzzle;
  final DateTime? today;
  final DateTime Function()? now;
  final PuzzleProgressStore? progressStore;
  final String pieceTheme;

  const DailyPuzzlePage({
    super.key,
    this.puzzle,
    this.today,
    this.now,
    this.progressStore,
    this.pieceTheme = 'Classic',
  });

  @override
  State<DailyPuzzlePage> createState() => _DailyPuzzlePageState();
}

class _DailyPuzzlePageState extends State<DailyPuzzlePage>
    with WidgetsBindingObserver {
  late DateTime _today;
  late DailyPuzzle _puzzle;
  late final PuzzleProgressStore _progressStore;
  late PuzzleSession _session;
  int? _selectedTile;
  int _streak = 0;
  bool _wrongMove = false;
  bool _loading = true;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _progressStore =
        widget.progressStore ?? SharedPreferencesPuzzleProgressStore();
    _resetForDate(widget.today ?? _now);
    _loadProgress();
  }

  DateTime get _now => widget.now?.call() ?? DateTime.now();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshDate();
  }

  bool _refreshDate() {
    if (widget.today != null) return false;
    final current = _now;
    if (current.year == _today.year &&
        current.month == _today.month &&
        current.day == _today.day) {
      return false;
    }
    setState(() => _resetForDate(current));
    _loadProgress();
    return true;
  }

  void _resetForDate(DateTime date) {
    _today = DateTime(date.year, date.month, date.day);
    _puzzle = widget.puzzle ?? puzzleForDate(_today);
    _session =
        PuzzleSession(fen: _puzzle.fen, solutionLine: _puzzle.solutionLine);
    _selectedTile = null;
    _streak = 0;
    _wrongMove = false;
    _loading = true;
    _showHint = false;
  }

  Future<void> _loadProgress() async {
    final session = _session;
    final progress = await _progressStore.load(_today);
    if (!mounted || !identical(_session, session)) return;
    setState(() {
      _streak = progress.streak;
      _loading = false;
      if (progress.solvedToday) session.showCompletedLine();
    });
  }

  Future<void> _onTileTap(int tile) async {
    if (_refreshDate()) return;
    final session = _session;
    final today = _today;
    if (_loading || session.isComplete || session.awaitingReply) return;
    final piece = session.position.board.tiles[tile];
    if (piece?.player == session.player) {
      setState(() {
        _selectedTile = _selectedTile == tile ? null : tile;
        _wrongMove = false;
      });
      return;
    }
    final selected = _selectedTile;
    if (selected == null) return;
    final correct = session.tryMove(selected, tile);
    setState(() {
      _selectedTile = null;
      _wrongMove = !correct;
      _showHint = false;
    });
    if (!correct) return;
    if (session.awaitingReply) {
      // Keep the player's checking move visible before showing the defense.
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted || !identical(_session, session)) return;
      setState(session.playReply);
    }
    if (session.isComplete) {
      final progress = await _progressStore.markSolved(today);
      if (mounted && identical(_session, session)) {
        setState(() => _streak = progress.streak);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final solved = _session.isComplete;
    final lastMove = _session.lastMove;
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
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    _puzzle.mateIn == 1
                        ? strings.Mate_In_One
                        : strings.Mate_In_Two,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x33000000),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.flame, size: 18),
                        const SizedBox(width: 6),
                        Flexible(child: Text(strings.Puzzle_Streak(_streak))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${puzzleDifficultyLabel(strings, _puzzle.difficulty)} · '
                  '${puzzleMotifLabel(strings, _puzzle.motif)}',
                  style: const TextStyle(color: CupertinoColors.systemGrey2),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  solved
                      ? strings.Puzzle_Solved
                      : _session.movesPlayed > 0
                          ? strings.Puzzle_Line_Progress
                          : _puzzle.mateIn == 1
                              ? strings.Puzzle_Instruction
                              : strings.Find_Best_Move,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              PositionBoard(
                key: ValueKey('daily-puzzle-${_puzzle.id}'),
                board: _session.position.board,
                pieceTheme: widget.pieceTheme,
                flipped: _session.player == Player.player2,
                selectedTile: _selectedTile,
                highlightedTiles: _showHint && !solved
                    ? {_session.expectedMove.from}
                    : lastMove == null
                        ? const {}
                        : {lastMove.from, lastMove.to},
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
                    : solved
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
              if (!solved && !_session.awaitingReply)
                CupertinoButton(
                  key: const ValueKey('daily-puzzle-hint'),
                  onPressed: _loading
                      ? null
                      : () => setState(() => _showHint = !_showHint),
                  child: Text(strings.Tip),
                ),
              if (solved) ...[
                const SizedBox(height: 16),
                Text(
                  strings.Puzzle_Why_This_Works,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  puzzleExplanation(strings, _puzzle.motif),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CupertinoButton.filled(
                  key: const ValueKey('daily-puzzle-practice'),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => PuzzleLibraryPage(
                        pieceTheme: widget.pieceTheme,
                      ),
                    ),
                  ),
                  child: Text(strings.Puzzle_Practice_Next),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
