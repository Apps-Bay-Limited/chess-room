import 'dart:async';

import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:chess_room/util/practice_session_scope.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_labels.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_session.dart';
import 'package:chess_room/features/puzzle_library/puzzle_library_page.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/app_page.dart';
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
  bool _progressFailed = false;
  bool _savingProgress = false;
  int _progressReadRevision = 0;

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
    _progressFailed = false;
    _savingProgress = false;
  }

  Future<void> _loadProgress() async {
    final session = _session;
    final revision = ++_progressReadRevision;
    setState(() => _loading = true);
    try {
      final progress = await _progressStore.load(_today);
      if (!mounted ||
          !identical(_session, session) ||
          revision != _progressReadRevision) {
        return;
      }
      setState(() {
        _streak = progress.streak;
        _loading = false;
        _progressFailed = false;
        if (progress.solvedToday) session.showCompletedLine();
      });
    } catch (_) {
      if (!mounted ||
          !identical(_session, session) ||
          revision != _progressReadRevision) {
        return;
      }
      setState(() {
        _loading = false;
        _progressFailed = true;
      });
    }
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
      await _saveCompletion(session, today);
    }
  }

  Future<void> _saveCompletion(PuzzleSession session, DateTime today) async {
    if (_savingProgress) return;
    setState(() => _savingProgress = true);
    try {
      final progress = await _progressStore.markSolved(today);
      if (mounted && identical(_session, session)) {
        setState(() {
          _streak = progress.streak;
          _progressFailed = false;
        });
      }
      unawaited(InAppReviewHelper.shared.recordCompletedPuzzle(today));
    } catch (_) {
      if (mounted && identical(_session, session)) {
        setState(() => _progressFailed = true);
      }
    } finally {
      if (mounted && identical(_session, session)) {
        setState(() => _savingProgress = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final solved = _session.isComplete;
    final lastMove = _session.lastMove;
    return PracticeSessionScope(
        child: AppPage(
      title: strings.Daily_Puzzle,
      leading: CupertinoNavigationBarBackButton(
        key: const ValueKey('daily-puzzle-back-button'),
        color: AppColors.accent,
        onPressed: () => Navigator.maybePop(context),
      ),
      child: AppContent(
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
                  if (!_progressFailed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
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
              if (_progressFailed) ...[
                const SizedBox(height: AppSpacing.md),
                Text(strings.Training_Progress_Unavailable,
                    style: const TextStyle(color: AppColors.textSecondary)),
                CupertinoButton(
                  onPressed: _savingProgress || _loading
                      ? null
                      : () {
                          if (_session.isComplete) {
                            _saveCompletion(_session, _today);
                          } else {
                            _loadProgress();
                          }
                        },
                  child: Text(strings.Retry),
                ),
              ],
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${puzzleDifficultyLabel(strings, _puzzle.difficulty)} · '
                  '${puzzleMotifLabel(strings, _puzzle.motif)}',
                  style: const TextStyle(color: AppColors.textSecondary),
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
                              color: AppColors.success,
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
                  child: Text(strings.Puzzle_Hint),
                ),
              if (solved) ...[
                const SizedBox(height: 16),
                Text(
                  strings.Puzzle_Why_This_Works,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  puzzlePositionExplanation(
                    strings,
                    fen: _puzzle.fen,
                    solutionLine: _puzzle.solutionLine,
                    motif: _puzzle.motif,
                  ),
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
    ));
  }
}
