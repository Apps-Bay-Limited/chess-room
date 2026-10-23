import 'dart:async';

import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:chess_room/util/practice_session_scope.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_labels.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_session.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:chess_room/views/components/shared/app_page.dart';
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
  bool _progressFailed = false;
  int _loadRevision = 0;

  @override
  void initState() {
    super.initState();
    _store =
        widget.progressStore ?? SharedPreferencesPuzzleLibraryProgressStore();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final revision = ++_loadRevision;
    try {
      final solved = await _store.loadSolvedIds();
      if (!mounted || revision != _loadRevision) return;
      setState(() {
        _solvedIds = solved;
        _progressFailed = false;
      });
    } catch (_) {
      if (!mounted || revision != _loadRevision) return;
      setState(() => _progressFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return PracticeSessionScope(
        child: AppPage(
      title: strings.Puzzle_Library,
      child: AppContent(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(
              strings.Puzzle_Library_Description,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (_progressFailed) ...[
              Text(strings.Training_Progress_Unavailable),
              CupertinoButton(
                onPressed: _loadProgress,
                child: Text(strings.Retry),
              ),
            ],
            for (final theme in PuzzleTheme.values) ...[
              _ThemeCard(
                theme: theme,
                solved: _progressFailed
                    ? null
                    : themedPuzzles
                        .where((puzzle) =>
                            puzzle.theme == theme &&
                            _solvedIds.contains(puzzle.id))
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
                  if (mounted) _loadProgress();
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    ));
  }
}

class _ThemeCard extends StatelessWidget {
  final PuzzleTheme theme;
  final int? solved;
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
          color: AppColors.surface,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(_themeIcon(theme), size: 28, color: AppColors.accent),
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    solved == null
                        ? strings.Training_Progress_Unavailable
                        : strings.Puzzles_Solved(solved!, total),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(CupertinoIcons.chevron_forward,
                size: 20, color: AppColors.textSecondary),
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
  bool _progressFailed = false;
  bool _savingProgress = false;
  final Set<String> _pendingCompletions = {};

  ThemedPuzzle get _puzzle => _puzzles[_index];

  @override
  void initState() {
    super.initState();
    _loadPuzzles();
  }

  Future<void> _loadPuzzles() async {
    Set<String> solved = {};
    try {
      solved = await widget.progressStore.loadSolvedIds();
    } catch (_) {
      _progressFailed = true;
    }
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
      if (_puzzles.isNotEmpty) _startPuzzle();
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
    final session = _session;
    final completedId = _puzzle.id;
    if (_savingProgress || session.isComplete || session.awaitingReply) return;
    final piece = session.position.board.tiles[tile];
    if (piece?.player == session.player) {
      setState(() {
        _selectedTile = _selectedTile == tile ? null : tile;
        _wrong = false;
      });
      return;
    }
    final selected = _selectedTile;
    if (selected == null) return;
    final correct = session.tryMove(selected, tile);
    setState(() {
      _selectedTile = null;
      _wrong = !correct;
      _showHint = false;
    });
    if (!correct) return;
    if (session.awaitingReply) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted || !identical(session, _session)) return;
      setState(session.playReply);
    }
    if (session.isComplete) {
      _pendingCompletions.add(completedId);
      await _savePendingCompletions();
    }
  }

  Future<void> _savePendingCompletions() async {
    if (_savingProgress) return;
    setState(() => _savingProgress = true);
    try {
      while (_pendingCompletions.isNotEmpty) {
        final completedId = _pendingCompletions.first;
        await widget.progressStore.markSolved(completedId);
        _pendingCompletions.remove(completedId);
        // Eligibility accounting is independent of the saved practice result.
        unawaited(InAppReviewHelper.shared
            .recordCompletedActivity('puzzle:$completedId')
            .catchError((Object _) {}));
      }
      if (mounted) setState(() => _progressFailed = false);
    } catch (_) {
      if (mounted) setState(() => _progressFailed = true);
    } finally {
      if (mounted) setState(() => _savingProgress = false);
    }
  }

  Future<void> _retryProgress() async {
    if (_savingProgress) return;
    if (_pendingCompletions.isNotEmpty) {
      await _savePendingCompletions();
      return;
    }
    setState(() => _savingProgress = true);
    try {
      // Refresh availability without replacing the player's current position.
      await widget.progressStore.loadSolvedIds();
      if (mounted) setState(() => _progressFailed = false);
    } catch (_) {
      if (mounted) setState(() => _progressFailed = true);
    } finally {
      if (mounted) setState(() => _savingProgress = false);
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
    return PracticeSessionScope(
        child: AppPage(
      title: _themeName(strings, widget.theme),
      child: AppContent(
        child: _puzzles.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : _buildPuzzle(strings),
      ),
    ));
  }

  Widget _buildPuzzle(S strings) {
    final solved = _session.isComplete;
    final lastMove = _session.lastMove;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          if (_progressFailed) ...[
            Text(strings.Training_Progress_Unavailable,
                style: const TextStyle(color: AppColors.textSecondary)),
            CupertinoButton(
              key: const ValueKey('retry-library-progress'),
              onPressed: _savingProgress ? null : _retryProgress,
              child: Text(strings.Retry),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            strings.Puzzle_Number(_index + 1, _puzzles.length),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            puzzleDifficultyLabel(strings, _puzzle.difficulty),
            style: const TextStyle(color: AppColors.textSecondary),
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
            onTileTap: _savingProgress ? null : _onTileTap,
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
              child: Text(strings.Puzzle_Hint),
            ),
          if (solved) ...[
            Text(
              strings.Puzzle_Complete,
              style: const TextStyle(
                color: AppColors.success,
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
              puzzlePositionExplanation(
                strings,
                fen: _puzzle.fen,
                solutionLine: _puzzle.solutionLine,
                motif: _puzzle.motif,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            CupertinoButton.filled(
              key: const ValueKey('next-library-puzzle'),
              onPressed: _savingProgress ? null : _nextPuzzle,
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

IconData _themeIcon(PuzzleTheme theme) => switch (theme) {
      PuzzleTheme.checkmate => CupertinoIcons.flag,
      PuzzleTheme.fork => CupertinoIcons.arrow_branch,
      PuzzleTheme.promotion => CupertinoIcons.arrow_up,
      PuzzleTheme.queenNet => CupertinoIcons.square_grid_2x2,
      PuzzleTheme.backRank => CupertinoIcons.rectangle,
      PuzzleTheme.knightMate => CupertinoIcons.bolt,
      PuzzleTheme.rookMate => CupertinoIcons.arrow_up_right,
      PuzzleTheme.bishopMate => CupertinoIcons.arrow_up_right_square,
    };
