export 'package:chess_room/logic/chess_notation.dart' show moveFromUci;

class DailyPuzzle {
  final String id;
  final String fen;
  final String solution;

  const DailyPuzzle({
    required this.id,
    required this.fen,
    required this.solution,
  });
}

const dailyPuzzles = <DailyPuzzle>[
  DailyPuzzle(
    id: 'queen-net-g7',
    fen: '6k1/8/6KQ/8/8/8/8/8 w - - 0 1',
    solution: 'h6g7',
  ),
  DailyPuzzle(
    id: 'back-rank-e8',
    fen: '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
    solution: 'e1e8',
  ),
  DailyPuzzle(
    id: 'queen-f8',
    fen: '7k/8/6KQ/8/8/8/8/8 w - - 0 1',
    solution: 'h6f8',
  ),
  DailyPuzzle(
    id: 'back-rank-g8',
    fen: 'k7/ppp5/8/8/8/8/8/1K4R1 w - - 0 1',
    solution: 'g1g8',
  ),
  DailyPuzzle(
    id: 'black-back-rank-e1',
    fen: '4r1k1/8/8/8/8/8/5PPP/6K1 b - - 0 1',
    solution: 'e8e1',
  ),
  DailyPuzzle(
    id: 'queen-net-b7',
    fen: 'k7/8/1KQ5/8/8/8/8/8 w - - 0 1',
    solution: 'c6b7',
  ),
  DailyPuzzle(
    id: 'black-queen-b2',
    fen: '8/8/8/8/8/1kq5/8/K7 b - - 0 1',
    solution: 'c3b2',
  ),
];

DailyPuzzle puzzleForDate(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final epoch = DateTime.utc(2024);
  final index = day.difference(epoch).inDays % dailyPuzzles.length;
  return dailyPuzzles[index];
}
