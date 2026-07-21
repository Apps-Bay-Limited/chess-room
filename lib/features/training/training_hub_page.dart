import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:chess_room/features/opening_trainer/opening_trainer_page.dart';
import 'package:chess_room/features/puzzle_library/puzzle_library_page.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';

class TrainingHubPage extends StatelessWidget {
  final String pieceTheme;
  final PuzzleLibraryProgressStore? puzzleProgressStore;
  final OpeningProgressStore? openingProgressStore;

  const TrainingHubPage({
    super.key,
    this.pieceTheme = 'Classic',
    this.puzzleProgressStore,
    this.openingProgressStore,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(strings.Training),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(
              strings.Training_Description,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: AppSpacing.xl),
            _TrainingCard(
              key: const ValueKey('training-puzzles-button'),
              icon: CupertinoIcons.square_grid_2x2,
              title: strings.Puzzle_Library,
              description: strings.Puzzle_Library_Description,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => PuzzleLibraryPage(
                      pieceTheme: pieceTheme,
                      progressStore: puzzleProgressStore,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _TrainingCard(
              key: const ValueKey('training-openings-button'),
              icon: CupertinoIcons.book,
              title: strings.Opening_Trainer,
              description: strings.Opening_Trainer_Description,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => OpeningTrainerPage(
                      pieceTheme: pieceTheme,
                      progressStore: openingProgressStore,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _TrainingCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
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
            Icon(icon, color: CupertinoColors.white, size: 32),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey2,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              CupertinoIcons.chevron_forward,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }
}
