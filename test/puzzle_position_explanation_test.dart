import 'dart:ui';

import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/puzzle_labels.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

String readable(String value) => value.replaceAll(RegExp('[\u2066\u2069]'), '');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late S strings;
  setUp(() async {
    strings = await S.load(const Locale('en'));
  });

  String explain(String id) {
    final puzzle = themedPuzzles.firstWhere((puzzle) => puzzle.id == id);
    return readable(puzzlePositionExplanation(
      strings,
      fen: puzzle.fen,
      solutionLine: puzzle.solutionLine,
      motif: puzzle.motif,
    ));
  }

  test('queen mate names the checking square and its supporting king', () {
    final explanation = explain('mate-queen-g7');
    expect(explanation, contains('One solution: Qg7#.'));
    expect(explanation, contains('White queen: h6 → g7.'));
    expect(explanation, contains('king on g8'));
    expect(explanation, contains('White king on g6 protects g7.'));
  });

  test('black back-rank mate explains the defending pawns accurately', () {
    final explanation = explain('mate-black-e1');
    expect(explanation, contains('One solution: Re1#.'));
    expect(explanation, contains('Black rook: e8 → e1.'));
    expect(explanation, contains('king on g1'));
    expect(explanation, contains('pawns on f2, g2, h2'));
  });

  test('knight fork names both attacked pieces without calling it mate', () {
    final explanation = explain('fork-knight-f6');
    expect(explanation, contains('Nf6+'));
    expect(explanation, contains('king on e8'));
    expect(explanation, contains('Black queen on h7'));
    expect(explanation, isNot(contains('Checkmate')));
  });

  test('promotion handles both sides and names the new piece', () {
    final white = explain('promote-white-e8');
    final black = explain('promote-black-d1');
    expect(white, contains('e8=Q+'));
    expect(white, contains('White pawn: e7 → e8.'));
    expect(white, contains('reaches e8 and becomes White queen.'));
    expect(black, contains('d1=Q+'));
    expect(black, contains('Black pawn: d2 → d1.'));
    expect(black, contains('reaches d1 and becomes Black queen.'));
    expect(black, isNot(contains('Checkmate')));
  });

  test('mate-in-two includes the defensive reply and mating continuation', () {
    final explanation = explain('original-combination-04');
    expect(explanation, contains('One solution: Bd4+ Kh1 Rh3#.'));
    expect(explanation, contains('Black bishop: c3 → d4.'));
    expect(explanation, contains('After Kh1, Rh3# delivers checkmate.'));
  });

  test('an alternate solution is described as an example using its own squares',
      () {
    final puzzle = dailyPuzzles.firstWhere((puzzle) => puzzle.id == 'queen-f8');
    final explanation = readable(puzzlePositionExplanation(
      strings,
      fen: puzzle.fen,
      solutionLine: const ['h6h7'],
      motif: puzzle.motif,
    ));
    expect(explanation, contains('One solution: Qxh7#.'));
    expect(explanation, contains('White queen: h6 → h7.'));
    expect(explanation, isNot(contains('f8')));
  });

  test('invalid content returns the existing safe motif explanation', () {
    final puzzle = dailyPuzzles.first;
    for (final line in <List<String>>[
      [],
      ['broken'],
      ['a1a2'],
      ['g8f8'], // Wrong side to move.
      ['h6g7', 'g8f8'], // Continuation after mate.
    ]) {
      expect(
        puzzlePositionExplanation(strings,
            fen: puzzle.fen, solutionLine: line, motif: puzzle.motif),
        puzzleExplanation(strings, puzzle.motif),
      );
    }
    for (final fen in ['invalid', '8/8/8/8/8/8/8/8 w - - 0 1']) {
      expect(
        puzzlePositionExplanation(strings,
            fen: fen, solutionLine: puzzle.solutionLine, motif: puzzle.motif),
        puzzleExplanation(strings, puzzle.motif),
      );
    }
    final promotion =
        themedPuzzles.firstWhere((puzzle) => puzzle.id == 'promote-white-e8');
    expect(
      puzzlePositionExplanation(strings,
          fen: promotion.fen,
          solutionLine: const ['e7e8'],
          motif: promotion.motif),
      puzzleExplanation(strings, promotion.motif),
    );
  });

  for (final locale in const [
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'HK'),
    Locale('fr'),
    Locale('es'),
    Locale('ja'),
    Locale('ar'),
  ]) {
    test('all published puzzle explanations render in $locale', () async {
      final localized = await S.load(locale);
      for (final puzzle in themedPuzzles) {
        final explanation = readable(puzzlePositionExplanation(
          localized,
          fen: puzzle.fen,
          solutionLine: puzzle.solutionLine,
          motif: puzzle.motif,
        ));
        expect(explanation, isNot(puzzleExplanation(localized, puzzle.motif)),
            reason: '${puzzle.id} fell back to generic text');
        expect(explanation, contains(puzzle.solution.substring(0, 2)),
            reason: puzzle.id);
        expect(explanation, contains(puzzle.solution.substring(2, 4)),
            reason: puzzle.id);
        expect(explanation, isNot(contains('{')),
            reason: '${puzzle.id} has an unexpanded placeholder');
        if (puzzle.motif != PuzzleMotif.fork &&
            puzzle.motif != PuzzleMotif.promotion) {
          expect(explanation, contains('#'), reason: puzzle.id);
        }
      }
    });
  }
}
