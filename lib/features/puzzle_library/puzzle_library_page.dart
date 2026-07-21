import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';
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
  late final List<ThemedPuzzle> _puzzles;
  late ChessPosition _position;
  int _index = 0;
  int? _selectedTile;
  bool _solved = false;
  bool _wrong = false;

  ThemedPuzzle get _puzzle => _puzzles[_index];

  @override
  void initState() {
    super.initState();
    _puzzles = themedPuzzles
        .where((puzzle) => puzzle.theme == widget.theme)
        .toList(growable: false);
    _position = chessPositionFromFen(_puzzle.fen);
  }

  void _onTileTap(int tile) {
    if (_solved) return;
    if (_selectedTile == null) {
      final piece = _position.board.tiles[tile];
      if (piece?.player == _position.activePlayer) {
        setState(() {
          _selectedTile = tile;
          _wrong = false;
        });
      }
      return;
    }
    final expected = moveFromUci(_puzzle.solution);
    final attempt = Move(_selectedTile!, tile);
    if (attempt == expected) {
      push(
        expected,
        _position.board,
        promotionType: expected.promotionType,
      );
      widget.progressStore.markSolved(_puzzle.id);
      setState(() {
        _selectedTile = null;
        _solved = true;
        _wrong = false;
      });
    } else {
      setState(() {
        _selectedTile = null;
        _wrong = true;
      });
    }
  }

  void _nextPuzzle() {
    setState(() {
      _index = (_index + 1) % _puzzles.length;
      _position = chessPositionFromFen(_puzzle.fen);
      _selectedTile = null;
      _solved = false;
      _wrong = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final solution = moveFromUci(_puzzle.solution);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(_themeName(strings, widget.theme)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Text(
                strings.Puzzle_Number(_index + 1, _puzzles.length),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(strings.Find_Best_Move),
              const SizedBox(height: AppSpacing.xl),
              PositionBoard(
                key: ValueKey('library-puzzle-${_puzzle.id}'),
                board: _position.board,
                pieceTheme: widget.pieceTheme,
                flipped: _position.activePlayer == Player.player2,
                selectedTile: _selectedTile,
                highlightedTiles:
                    _solved ? {solution.from, solution.to} : const {},
                onTileTap: _onTileTap,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_wrong)
                Text(
                  strings.Try_Again,
                  style: const TextStyle(color: CupertinoColors.systemOrange),
                ),
              if (_solved) ...[
                Text(
                  strings.Puzzle_Complete,
                  style: const TextStyle(
                    color: CupertinoColors.activeGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CupertinoButton.filled(
                  key: const ValueKey('next-library-puzzle'),
                  onPressed: _nextPuzzle,
                  child: Text(strings.Next_Puzzle),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _themeName(S strings, PuzzleTheme theme) => switch (theme) {
      PuzzleTheme.checkmate => strings.Theme_Checkmate,
      PuzzleTheme.fork => strings.Theme_Forks,
      PuzzleTheme.promotion => strings.Theme_Promotion,
    };

String _themeEmoji(PuzzleTheme theme) => switch (theme) {
      PuzzleTheme.checkmate => '♚',
      PuzzleTheme.fork => '♞',
      PuzzleTheme.promotion => '♛',
    };
