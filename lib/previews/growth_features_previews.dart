import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_page.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/game_history/game_history_page.dart';
import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/features/game_review/game_review_page.dart';
import 'package:chess_room/features/how_to_play/how_to_play_page.dart';
import 'package:chess_room/features/opening_trainer/opening_trainer_page.dart';
import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:chess_room/features/puzzle_library/puzzle_library_page.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/features/training/training_hub_page.dart';
import 'package:chess_room/features/share_result/result_share_section.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/chess_view/game_tip_button.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/time_limit_picker.dart';
import 'package:chess_room/views/components/shared/menu_button.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:chess_room/views/components/settings_view/settings_navigation_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widget_previews.dart';

@Preview(
  name: 'Daily puzzle board',
  group: 'Growth features',
  size: Size(390, 480),
)
Widget dailyPuzzleBoardPreview() {
  final position = chessPositionFromFen(dailyPuzzles.first.fen);
  return CupertinoApp(
    home: CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Mate in One',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PositionBoard(board: position.board),
            ],
          ),
        ),
      ),
    ),
  );
}

@Preview(
  name: 'Daily puzzle screen',
  group: 'Growth features',
  size: Size(390, 760),
)
Widget dailyPuzzleScreenPreview() {
  return CupertinoApp(
    theme: const CupertinoThemeData(brightness: Brightness.dark),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: DailyPuzzlePage(
      puzzle: dailyPuzzles.first,
      today: DateTime(2026, 7, 13),
      progressStore: PreviewPuzzleProgressStore(),
    ),
  );
}

@Preview(
  name: 'Share result card',
  group: 'Growth features',
  size: Size(360, 480),
)
Widget resultCardPreview() {
  final position = chessPositionFromFen(
    '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
  );
  return CupertinoApp(
    home: CupertinoPageScaffold(
      backgroundColor: const Color(0xff24201C),
      child: Center(
        child: ResultCard(
          board: position.board,
          result: 'White wins!',
          moveCount: '24 moves',
          pieceTheme: 'Classic',
        ),
      ),
    ),
  );
}

@Preview(
  name: 'One-row time picker',
  group: 'Game setup',
  size: Size(390, 180),
)
Widget timeLimitPickerPreview() {
  return _localizedPreview(
    const Padding(
      padding: EdgeInsets.all(24),
      child: TimeLimitPicker(
        selectedTime: 10,
        setFunc: ignoreTimeChangePreview,
      ),
    ),
  );
}

@Preview(
  name: 'Styled game actions',
  group: 'Growth features',
  size: Size(390, 390),
)
Widget styledGameActionsPreview() {
  return CupertinoApp(
    home: CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuButton(label: 'Daily Puzzle', onTap: previewTap),
              const SizedBox(height: 18),
              MenuButton(
                label: 'Review Biggest Mistake',
                onTap: previewTap,
              ),
              const SizedBox(height: 18),
              GameTipButton(label: 'Tip', onTap: previewTap),
              const SizedBox(height: 12),
              const GameTipButton(
                label: 'Tip',
                onTap: null,
                isLoading: true,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@Preview(
  name: 'Settings navigation',
  group: 'Learning features',
  size: Size(390, 420),
)
Widget settingsNavigationPreview() {
  return _localizedPreview(
    SettingsNavigationButtons(
      showPrivacyChoices: true,
      onHowToPlay: previewTap,
      onGameHistory: previewTap,
      onPrivacyChoices: previewTap,
      onMoreApps: previewTap,
      onBack: previewTap,
    ),
  );
}

@Preview(
  name: 'Training hub',
  group: 'Learning features',
  size: Size(390, 760),
)
Widget trainingHubPreview() {
  return _localizedPreview(
    const TrainingHubPage(
      puzzleProgressStore: PreviewPuzzleLibraryStore(),
      openingProgressStore: PreviewOpeningProgressStore(),
    ),
  );
}

@Preview(
  name: 'How to play chess',
  group: 'Learning features',
  size: Size(390, 760),
)
Widget howToPlayPreview() {
  return _localizedPreview(const HowToPlayPage());
}

@Preview(
  name: 'Puzzle library',
  group: 'Learning features',
  size: Size(390, 760),
)
Widget puzzleLibraryPreview() {
  return _localizedPreview(
    const PuzzleLibraryPage(progressStore: PreviewPuzzleLibraryStore()),
  );
}

@Preview(
  name: 'Opening trainer',
  group: 'Learning features',
  size: Size(390, 760),
)
Widget openingTrainerPreview() {
  return _localizedPreview(
    const OpeningTrainerPage(progressStore: PreviewOpeningProgressStore()),
  );
}

@Preview(
  name: 'Game history',
  group: 'Learning features',
  size: Size(390, 760),
)
Widget gameHistoryPreview() {
  return _localizedPreview(
    GameHistoryPage(store: PreviewGameHistoryStore()),
  );
}

@Preview(
  name: 'Full game review',
  group: 'Learning features',
  size: Size(390, 760),
)
Widget fullGameReviewPreview() {
  return _localizedPreview(
    GameReviewPage(
      records: [
        MoveReviewRecord(
          moveIndex: 0,
          player: Player.player1,
          playedMove: moveFromUci('a1a2'),
          bestMove: moveFromUci('a1a8'),
          evaluationLoss: 900,
          positionBeforeFen: 'q6k/8/8/8/8/8/8/Q6K w - - 0 1',
        ),
        MoveReviewRecord(
          moveIndex: 1,
          player: Player.player2,
          playedMove: moveFromUci('a8a7'),
          bestMove: moveFromUci('a8a2'),
          evaluationLoss: 120,
          positionBeforeFen: 'q6k/8/8/8/8/8/Q7/7K b - - 0 1',
        ),
      ],
    ),
  );
}

Widget _localizedPreview(Widget child) {
  return CupertinoApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      child: SafeArea(child: child),
    ),
  );
}

void ignoreTimeChangePreview(int? value) {}

void previewTap() {}

class PreviewPuzzleProgressStore implements PuzzleProgressStore {
  @override
  Future<PuzzleProgress> load(DateTime today) async {
    return const PuzzleProgress(streak: 4, solvedToday: false);
  }

  @override
  Future<PuzzleProgress> markSolved(DateTime today) async {
    return const PuzzleProgress(streak: 5, solvedToday: true);
  }
}

class PreviewPuzzleLibraryStore implements PuzzleLibraryProgressStore {
  const PreviewPuzzleLibraryStore();

  @override
  Future<Set<String>> loadSolvedIds() async => {'mate-queen-g7'};

  @override
  Future<void> markSolved(String puzzleId) async {}
}

class PreviewGameHistoryStore implements GameHistoryStore {
  @override
  Future<List<SavedGame>> loadGames() async => [
        SavedGame.fromPgn(
          '[Result "1-0"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 1-0',
          importedAt: DateTime(2026, 7, 22, 9, 30),
        ),
      ];

  @override
  Future<void> deleteGame(String id) async {}

  @override
  Future<void> saveGame(SavedGame game) async {}
}

class PreviewOpeningProgressStore implements OpeningProgressStore {
  const PreviewOpeningProgressStore();

  @override
  Future<Set<String>> loadCompletedIds() async => {'italian'};

  @override
  Future<void> markCompleted(String openingId) async {}
}
