import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';

String puzzleDifficultyLabel(S strings, PuzzleDifficulty difficulty) =>
    switch (difficulty) {
      PuzzleDifficulty.easy => strings.Puzzle_Easy,
      PuzzleDifficulty.medium => strings.Puzzle_Medium,
      PuzzleDifficulty.hard => strings.Puzzle_Hard,
    };

String puzzleMotifLabel(S strings, PuzzleMotif motif) => switch (motif) {
      PuzzleMotif.queenNet => strings.Theme_Queen_Net,
      PuzzleMotif.backRank => strings.Theme_Back_Rank,
      PuzzleMotif.knightMate => strings.Theme_Knight_Mate,
      PuzzleMotif.rookMate => strings.Theme_Rook_Mate,
      PuzzleMotif.bishopMate => strings.Theme_Bishop_Mate,
      PuzzleMotif.fork => strings.Theme_Forks,
      PuzzleMotif.promotion => strings.Theme_Promotion,
      PuzzleMotif.combination => strings.Theme_Combination,
    };

String puzzleExplanation(S strings, PuzzleMotif motif) => switch (motif) {
      PuzzleMotif.queenNet => strings.Puzzle_Explain_Queen_Net,
      PuzzleMotif.backRank => strings.Puzzle_Explain_Back_Rank,
      PuzzleMotif.knightMate => strings.Puzzle_Explain_Knight_Mate,
      PuzzleMotif.rookMate => strings.Puzzle_Explain_Rook_Mate,
      PuzzleMotif.bishopMate => strings.Puzzle_Explain_Bishop_Mate,
      PuzzleMotif.fork => strings.Puzzle_Explain_Fork,
      PuzzleMotif.promotion => strings.Puzzle_Explain_Promotion,
      PuzzleMotif.combination => strings.Puzzle_Explain_Combination,
    };
