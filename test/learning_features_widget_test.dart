import 'package:chess_room/features/game_history/game_history_page.dart';
import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/features/game_review/game_review_page.dart';
import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:chess_room/features/opening_trainer/opening_trainer_page.dart';
import 'package:chess_room/features/puzzle_library/puzzle_library_page.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/features/training/training_hub_page.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('training hub opens puzzles and opening practice',
      (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        TrainingHubPage(
          puzzleProgressStore: _MemoryPuzzleLibraryStore(),
          openingProgressStore: _MemoryOpeningStore(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Puzzle Library'), findsOneWidget);
    expect(find.text('Opening Trainer'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('training-puzzles-button')));
    await tester.pumpAndSettle();
    expect(find.text('Knight Forks'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('training-openings-button')));
    await tester.pumpAndSettle();
    expect(find.text('Italian Game'), findsOneWidget);
  });

  testWidgets('puzzle library opens a theme and accepts its solution',
      (tester) async {
    final store = _MemoryPuzzleLibraryStore();
    await tester.pumpWidget(
      _localizedApp(PuzzleLibraryPage(progressStore: store)),
    );
    await tester.pump();

    expect(find.text('Knight Forks'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('puzzle-theme-fork')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('position-tile-27')));
    await tester.tap(find.byKey(const ValueKey('position-tile-21')));
    await tester.pump();

    expect(find.text('Puzzle complete!'), findsOneWidget);
    expect(store.solvedIds, contains('fork-knight-f6'));
  });

  testWidgets('opening trainer advances after the correct move',
      (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        OpeningTrainerPage(progressStore: _MemoryOpeningStore()),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('opening-italian')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Move 1 of 6'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('position-tile-52')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('position-tile-52')));
    await tester.tap(find.byKey(const ValueKey('position-tile-36')));
    await tester.pump();

    expect(find.textContaining('Move 2 of 6'), findsOneWidget);
  });

  testWidgets('full review navigates through every recorded move',
      (tester) async {
    final records = [
      _review(0, 'a1a2', 'a1a8', 900),
      _review(1, 'a8a7', 'a8a2', 120, player: Player.player2),
    ];
    await tester.pumpWidget(_localizedApp(GameReviewPage(records: records)));

    expect(find.textContaining('Move 1 of 2'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const ValueKey('review-next-move')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('review-next-move')));
    await tester.pump();

    expect(find.textContaining('Move 2 of 2'), findsOneWidget);
  });

  testWidgets('game history opens replay and advances the board',
      (tester) async {
    final store = _MemoryHistoryStore([
      SavedGame.fromPgn(
        '[Result "1-0"]\n\n1. e4 e5 2. Nf3 Nc6 1-0',
        importedAt: DateTime(2026, 7, 22),
      ),
    ]);
    await tester.pumpWidget(_localizedApp(GameHistoryPage(store: store)));
    await tester.pump();

    await tester.tap(find.text('Replay'));
    await tester.pumpAndSettle();
    expect(find.text('Move 0 of 4'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('replay-next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('replay-next')));
    await tester.pump();
    expect(find.text('Move 1 of 4'), findsOneWidget);
  });
}

MoveReviewRecord _review(
  int index,
  String played,
  String best,
  int loss, {
  Player player = Player.player1,
}) {
  return MoveReviewRecord(
    moveIndex: index,
    player: player,
    playedMove: moveFromUci(played),
    bestMove: moveFromUci(best),
    evaluationLoss: loss,
    positionBeforeFen: 'q6k/8/8/8/8/8/8/Q6K w - - 0 1',
  );
}

Widget _localizedApp(Widget home) {
  return CupertinoApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: home,
  );
}

class _MemoryPuzzleLibraryStore implements PuzzleLibraryProgressStore {
  final Set<String> solvedIds = {};

  @override
  Future<Set<String>> loadSolvedIds() async => Set.of(solvedIds);

  @override
  Future<void> markSolved(String puzzleId) async => solvedIds.add(puzzleId);
}

class _MemoryOpeningStore implements OpeningProgressStore {
  final Set<String> completedIds = {};

  @override
  Future<Set<String>> loadCompletedIds() async => Set.of(completedIds);

  @override
  Future<void> markCompleted(String openingId) async {
    completedIds.add(openingId);
  }
}

class _MemoryHistoryStore implements GameHistoryStore {
  final List<SavedGame> games;

  _MemoryHistoryStore(this.games);

  @override
  Future<void> deleteGame(String id) async {
    games.removeWhere((game) => game.id == id);
  }

  @override
  Future<List<SavedGame>> loadGames() async => List.of(games);

  @override
  Future<void> saveGame(SavedGame game) async => games.insert(0, game);
}
