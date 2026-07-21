import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum PuzzleTheme { checkmate, fork, promotion }

class ThemedPuzzle {
  final String id;
  final PuzzleTheme theme;
  final String fen;
  final String solution;

  const ThemedPuzzle({
    required this.id,
    required this.theme,
    required this.fen,
    required this.solution,
  });
}

const themedPuzzles = <ThemedPuzzle>[
  ThemedPuzzle(
    id: 'mate-queen-g7',
    theme: PuzzleTheme.checkmate,
    fen: '6k1/8/6KQ/8/8/8/8/8 w - - 0 1',
    solution: 'h6g7',
  ),
  ThemedPuzzle(
    id: 'mate-back-rank-e8',
    theme: PuzzleTheme.checkmate,
    fen: '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
    solution: 'e1e8',
  ),
  ThemedPuzzle(
    id: 'mate-black-e1',
    theme: PuzzleTheme.checkmate,
    fen: '4r1k1/8/8/8/8/8/5PPP/6K1 b - - 0 1',
    solution: 'e8e1',
  ),
  ThemedPuzzle(
    id: 'fork-knight-f6',
    theme: PuzzleTheme.fork,
    fen: '4k3/7q/8/3N4/8/8/8/4K3 w - - 0 1',
    solution: 'd5f6',
  ),
  ThemedPuzzle(
    id: 'fork-knight-c7',
    theme: PuzzleTheme.fork,
    fen: 'r3k3/8/8/1N6/8/8/8/4K3 w - - 0 1',
    solution: 'b5c7',
  ),
  ThemedPuzzle(
    id: 'fork-knight-c6',
    theme: PuzzleTheme.fork,
    fen: '1q6/4k3/8/4N3/8/8/8/4K3 w - - 0 1',
    solution: 'e5c6',
  ),
  ThemedPuzzle(
    id: 'promote-white-e8',
    theme: PuzzleTheme.promotion,
    fen: 'k7/4P3/8/8/8/8/8/7K w - - 0 1',
    solution: 'e7e8q',
  ),
  ThemedPuzzle(
    id: 'promote-black-d1',
    theme: PuzzleTheme.promotion,
    fen: '7k/8/8/8/8/8/3p4/K7 b - - 0 1',
    solution: 'd2d1q',
  ),
  ThemedPuzzle(
    id: 'promote-white-b8',
    theme: PuzzleTheme.promotion,
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

  @override
  Future<Set<String>> loadSolvedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_key);
    if (encoded == null) return {};
    try {
      return (jsonDecode(encoded) as List).cast<String>().toSet();
    } on FormatException {
      return {};
    }
  }

  @override
  Future<void> markSolved(String puzzleId) async {
    final solved = (await loadSolvedIds())..add(puzzleId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(solved.toList()..sort()));
  }
}
