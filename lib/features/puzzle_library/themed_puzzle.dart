import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';

enum PuzzleTheme {
  checkmate,
  fork,
  promotion,
  queenNet,
  backRank,
  knightMate,
  rookMate,
  bishopMate
}

class ThemedPuzzle {
  final String id;
  final PuzzleTheme theme;
  final String fen;
  final String solution;
  final List<String> continuation;
  final PuzzleDifficulty difficulty;
  final PuzzleMotif motif;

  const ThemedPuzzle({
    required this.id,
    required this.theme,
    required this.fen,
    required this.solution,
    this.continuation = const [],
    this.difficulty = PuzzleDifficulty.easy,
    this.motif = PuzzleMotif.queenNet,
  });

  List<String> get solutionLine => [solution, ...continuation];
}

final themedPuzzles = List<ThemedPuzzle>.unmodifiable([
  ..._originalThemedPuzzles,
  for (final puzzle in dailyPuzzles)
    if (!_originalThemedPuzzles.any((original) => original.fen == puzzle.fen))
      ThemedPuzzle(
        id: puzzle.id,
        theme: _themeForMotif(puzzle.motif),
        fen: puzzle.fen,
        solution: puzzle.solution,
        continuation: puzzle.continuation,
        difficulty: puzzle.difficulty,
        motif: puzzle.motif,
      ),
]);

PuzzleTheme _themeForMotif(PuzzleMotif motif) => switch (motif) {
      PuzzleMotif.queenNet => PuzzleTheme.queenNet,
      PuzzleMotif.backRank => PuzzleTheme.backRank,
      PuzzleMotif.knightMate => PuzzleTheme.knightMate,
      PuzzleMotif.rookMate => PuzzleTheme.rookMate,
      PuzzleMotif.bishopMate => PuzzleTheme.bishopMate,
      PuzzleMotif.fork => PuzzleTheme.fork,
      PuzzleMotif.promotion => PuzzleTheme.promotion,
      PuzzleMotif.combination => PuzzleTheme.checkmate,
    };

const _originalThemedPuzzles = <ThemedPuzzle>[
  ThemedPuzzle(
    id: 'mate-queen-g7',
    theme: PuzzleTheme.checkmate,
    fen: '6k1/8/6KQ/8/8/8/8/8 w - - 0 1',
    solution: 'h6g7',
  ),
  ThemedPuzzle(
    id: 'mate-back-rank-e8',
    motif: PuzzleMotif.backRank,
    theme: PuzzleTheme.checkmate,
    fen: '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
    solution: 'e1e8',
  ),
  ThemedPuzzle(
    id: 'mate-black-e1',
    motif: PuzzleMotif.backRank,
    theme: PuzzleTheme.checkmate,
    fen: '4r1k1/8/8/8/8/8/5PPP/6K1 b - - 0 1',
    solution: 'e8e1',
  ),
  ThemedPuzzle(
    id: 'fork-knight-f6',
    theme: PuzzleTheme.fork,
    motif: PuzzleMotif.fork,
    fen: '4k3/7q/8/3N4/8/8/8/4K3 w - - 0 1',
    solution: 'd5f6',
  ),
  ThemedPuzzle(
    id: 'fork-knight-c7',
    theme: PuzzleTheme.fork,
    motif: PuzzleMotif.fork,
    fen: 'r3k3/8/8/1N6/8/8/8/4K3 w - - 0 1',
    solution: 'b5c7',
  ),
  ThemedPuzzle(
    id: 'fork-knight-c6',
    theme: PuzzleTheme.fork,
    motif: PuzzleMotif.fork,
    fen: '1q6/4k3/8/4N3/8/8/8/4K3 w - - 0 1',
    solution: 'e5c6',
  ),
  ThemedPuzzle(
    id: 'promote-white-e8',
    theme: PuzzleTheme.promotion,
    motif: PuzzleMotif.promotion,
    fen: 'k7/4P3/8/8/8/8/8/7K w - - 0 1',
    solution: 'e7e8q',
  ),
  ThemedPuzzle(
    id: 'promote-black-d1',
    theme: PuzzleTheme.promotion,
    motif: PuzzleMotif.promotion,
    fen: '7k/8/8/8/8/8/3p4/K7 b - - 0 1',
    solution: 'd2d1q',
  ),
  ThemedPuzzle(
    id: 'promote-white-b8',
    theme: PuzzleTheme.promotion,
    motif: PuzzleMotif.promotion,
    fen: '7k/1P6/8/8/8/8/8/K7 w - - 0 1',
    solution: 'b7b8q',
  ),
];

abstract class PuzzleLibraryProgressStore {
  Future<Set<String>> loadSolvedIds();

  Future<void> markSolved(String puzzleId);
}

class SharedPreferencesPuzzleLibraryProgressStore
    implements PuzzleLibraryProgressStore {
  static const _key = 'puzzle_library_solved_v1';
  static Future<void> _pendingWrite = Future<void>.value();

  @override
  Future<Set<String>> loadSolvedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_key);
    if (encoded == null) return {};
    try {
      final decoded = jsonDecode(encoded);
      return decoded is List ? decoded.whereType<String>().toSet() : {};
    } on FormatException {
      return {};
    }
  }

  @override
  Future<void> markSolved(String puzzleId) {
    // Serialize updates across store instances so rapid practice sessions cannot
    // overwrite a completion while another read-modify-write is in flight.
    final update = _pendingWrite.then((_) async {
      final solved = (await loadSolvedIds())..add(puzzleId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(solved.toList()..sort()));
    });
    _pendingWrite = update.catchError((Object _) {});
    return update;
  }
}
