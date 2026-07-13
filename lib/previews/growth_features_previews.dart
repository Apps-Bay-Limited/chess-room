import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_page.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/share_result/result_share_section.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/views/components/chess_view/game_tip_button.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/time_limit_picker.dart';
import 'package:chess_room/views/components/shared/menu_button.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
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
