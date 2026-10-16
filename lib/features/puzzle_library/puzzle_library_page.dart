import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_labels.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_session.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flutter/cupertino.dart';

class PuzzleLibraryPage extends StatefulWidget {
  final PuzzleLibraryProgressStore? progressStore;
  final String pieceTheme;

  const PuzzleLibraryPage({
    super.key,
    this.progressStore,
    this.pieceTheme = 'Classic',
  });

  @override
  State<PuzzleLibraryPage> createState() => _PuzzleLibraryPageState();
}

class _PuzzleLibraryPageState extends State<PuzzleLibraryPage> {
  late final PuzzleLibraryProgressStore _store;
  Set<String> _solvedIds = {};

  @override
  void initState() {
    super.initState();
    _store =
        widget.progressStore ?? SharedPreferencesPuzzleLibraryProgressStore();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final solved = await _store.loadSolvedIds();
    if (mounted) setState(() => _solvedIds = solved);
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(strings.Puzzle_Library),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(
              strings.Puzzle_Library_Description,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final theme in PuzzleTheme.values) ...[
              _ThemeCard(
                theme: theme,
                solved: themedPuzzles
                    .where((puzzle) =>
                        puzzle.theme == theme && _solvedIds.contains(puzzle.id))
                    .length,
                total: themedPuzzles
                    .where((puzzle) => puzzle.theme == theme)
                    .length,
                onTap: () async {
                  await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => PuzzleSessionPage(
                        theme: theme,
                        progressStore: _store,
                        pieceTheme: widget.pieceTheme,
                      ),
                    ),
                  );
                  _loadProgress();
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final PuzzleTheme theme;
  final int solved;
  final int total;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.solved,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return CupertinoButton(
      key: ValueKey('puzzle-theme-${theme.name}'),
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: const Color(0x33000000),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Text(_themeEmoji(theme), style: const TextStyle(fontSize: 34)),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _themeName(strings, theme),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                    ),
                  ),
                  Text(
                    strings.Puzzles_Solved(solved, total),
                    style: const TextStyle(color: CupertinoColors.systemGrey2),
                  ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_forward),
          ],
        ),
      ),
    );
  }
}

class PuzzleSessionPage extends StatefulWidget {
  final PuzzleTheme theme;
  final PuzzleLibraryProgressStore progressStore;
  final String pieceTheme;

  const PuzzleSessionPage({
    super.key,
    required this.theme,
    required this.progressStore,
    this.pieceTheme = 'Classic',
  });

  @override
  State<PuzzleSessionPage> createState() => _PuzzleSessionPageState();
}

class _PuzzleSessionPageState extends State<PuzzleSessionPage> {
  List<ThemedPuzzle> _puzzles = [];
  late PuzzleSession _session;
  int _index = 0;
  int? _selectedTile;
  bool _wrong = false;
  bool _showHint = false;

  ThemedPuzzle get _puzzle => _puzzles[_index];

  @override
  void initState() {
    super.initState();
    _loadPuzzles();
  }

  Future<void> _loadPuzzles() async {
    final solved = await widget.progressStore.loadSolvedIds();
    if (!mounted) return;
    final candidates = themedPuzzles
        .where((puzzle) => puzzle.theme == widget.theme)
        .toList(growable: false);
    setState(() {
      // Returning players start with an unsolved position rather than
      // repeatedly solving the first three positions in the same order.
      _puzzles = [
        ...candidates.where((puzzle) => !solved.contains(puzzle.id)),
        ...candidates.where((puzzle) => solved.contains(puzzle.id)),
      ];
      _startPuzzle();
    });
  }

  void _startPuzzle() {
    _session = PuzzleSession(
      fen: _puzzle.fen,
      solutionLine: _puzzle.solutionLine,
      checkmateGoal: _puzzle.motif != PuzzleMotif.fork &&
          _puzzle.motif != PuzzleMotif.promotion,
    );
    _selectedTile = null;
    _wrong = false;
    _showHint = false;
  }

  Future<void> _onTileTap(int tile) async {
    if (_session.isComplete || _session.awaitingReply) return;
    final piece = _session.position.board.tiles[tile];
    if (piece?.player == _session.player) {
      setState(() {
        _selectedTile = _selectedTile == tile ? null : tile;
        _wrong = false;
      });
      return;
    }
    final selected = _selectedTile;
    if (selected == null) return;
    final correct = _session.tryMove(selected, tile);
    setState(() {
      _selectedTile = null;
      _wrong = !correct;
      _showHint = false;
    });
    if (!correct) return;
    if (_session.awaitingReply) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(_session.playReply);
    }
    if (_session.isComplete) {
      await widget.progressStore.markSolved(_puzzle.id);
    }
  }

  void _nextPuzzle() {
    setState(() {
      _index = (_index + 1) % _puzzles.length;
      _startPuzzle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(_themeName(strings, widget.theme)),
      ),
      child: SafeArea(
        child: _puzzles.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : _buildPuzzle(strings),
      ),
    );
  }

  Widget _buildPuzzle(S strings) {
    final solved = _session.isComplete;
    final lastMove = _session.lastMove;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Text(
            strings.Puzzle_Number(_index + 1, _puzzles.length),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            puzzleDifficultyLabel(strings, _puzzle.difficulty),
            style: const TextStyle(color: CupertinoColors.systemGrey2),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(_session.movesPlayed > 0 && !solved
              ? strings.Puzzle_Line_Progress
              : _puzzle.continuation.isNotEmpty
                  ? strings.Mate_In_Two
                  : strings.Find_Best_Move),
          const SizedBox(height: AppSpacing.lg),
          PositionBoard(
            key: ValueKey('library-puzzle-${_puzzle.id}'),
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
          const SizedBox(height: AppSpacing.lg),
          if (_wrong)
            Text(
              strings.Try_Again,
              style: const TextStyle(color: CupertinoColors.systemOrange),
            ),
          if (!solved && !_session.awaitingReply)
            CupertinoButton(
              key: const ValueKey('library-puzzle-hint'),
              onPressed: () => setState(() => _showHint = !_showHint),
              child: Text(strings.Tip),
            ),
          if (solved) ...[
            Text(
              strings.Puzzle_Complete,
              style: const TextStyle(
                color: CupertinoColors.activeGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              strings.Puzzle_Why_This_Works,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              puzzleExplanation(strings, _puzzle.motif),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            CupertinoButton.filled(
              key: const ValueKey('next-library-puzzle'),
              onPressed: _nextPuzzle,
              child: Text(strings.Next_Puzzle),
            ),
          ],
        ],
      ),
    );
  }
}

String _themeName(S strings, PuzzleTheme theme) => switch (theme) {
      PuzzleTheme.checkmate => strings.Theme_Checkmate,
      PuzzleTheme.fork => strings.Theme_Forks,
      PuzzleTheme.promotion => strings.Theme_Promotion,
      PuzzleTheme.queenNet => strings.Theme_Queen_Net,
      PuzzleTheme.backRank => strings.Theme_Back_Rank,
      PuzzleTheme.knightMate => strings.Theme_Knight_Mate,
      PuzzleTheme.rookMate => strings.Theme_Rook_Mate,
      PuzzleTheme.bishopMate => strings.Theme_Bishop_Mate,
    };

String _themeEmoji(PuzzleTheme theme) => switch (theme) {
      PuzzleTheme.checkmate => '♚',
      PuzzleTheme.fork => '♞',
      PuzzleTheme.promotion => '♛',
      PuzzleTheme.queenNet => '♕',
      PuzzleTheme.backRank => '♜',
      PuzzleTheme.knightMate => '♞',
      PuzzleTheme.rookMate => '♖',
      PuzzleTheme.bishopMate => '♗',
    };
