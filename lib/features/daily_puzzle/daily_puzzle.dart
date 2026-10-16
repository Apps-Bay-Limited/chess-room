export 'package:chess_room/logic/chess_notation.dart' show moveFromUci;

part 'daily_puzzle_content.dart';

enum PuzzleDifficulty { easy, medium, hard }

enum PuzzleMotif {
  queenNet,
  backRank,
  knightMate,
  rookMate,
  bishopMate,
  fork,
  promotion,
  combination
}

class DailyPuzzle {
  final String id;
  final String fen;
  final String solution;
  final List<String> continuation;
  final PuzzleDifficulty difficulty;
  final PuzzleMotif motif;

  const DailyPuzzle({
    required this.id,
    required this.fen,
    required this.solution,
    this.continuation = const [],
    this.difficulty = PuzzleDifficulty.easy,
    this.motif = PuzzleMotif.queenNet,
  });

  /// Alternating player and opponent moves. The first move remains available
  /// through [solution] for callers using the original single-move API.
  List<String> get solutionLine => [solution, ...continuation];

  int get mateIn => (solutionLine.length + 1) ~/ 2;
}

const dailyPuzzles = <DailyPuzzle>[
  DailyPuzzle(
    id: 'queen-net-g7',
    fen: '6k1/8/6KQ/8/8/8/8/8 w - - 0 1',
    solution: 'h6g7',
  ),
  DailyPuzzle(
    id: 'back-rank-e8',
    motif: PuzzleMotif.backRank,
    fen: '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
    solution: 'e1e8',
  ),
  DailyPuzzle(
    id: 'queen-f8',
    fen: '7k/7r/6KQ/8/8/8/8/8 w - - 0 1',
    solution: 'h6f8',
  ),
  DailyPuzzle(
    id: 'back-rank-g8',
    motif: PuzzleMotif.backRank,
    fen: 'k7/ppp5/8/8/8/8/8/1K4R1 w - - 0 1',
    solution: 'g1g8',
  ),
  DailyPuzzle(
    id: 'black-back-rank-e1',
    motif: PuzzleMotif.backRank,
    fen: '4r1k1/8/8/8/8/8/5PPP/6K1 b - - 0 1',
    solution: 'e8e1',
  ),
  DailyPuzzle(
    id: 'queen-net-b7',
    fen: 'k7/1b6/1KQ5/8/8/8/8/8 w - - 0 1',
    solution: 'c6b7',
  ),
  DailyPuzzle(
    id: 'black-queen-b2',
    fen: '8/8/8/8/8/1kq5/1B6/K7 b - - 0 1',
    solution: 'c3b2',
  ),
  ..._additionalDailyPuzzles,
];

DailyPuzzle puzzleForDate(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final epoch = DateTime.utc(2024);
  final index = day.difference(epoch).inDays % dailyPuzzles.length;
  return dailyPuzzles[index];
}
