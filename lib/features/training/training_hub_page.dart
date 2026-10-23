import 'package:chess_room/util/practice_session_scope.dart';
import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:chess_room/features/opening_trainer/opening_trainer_page.dart';
import 'package:chess_room/features/puzzle_library/puzzle_library_page.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/shared/app_page.dart';
import 'package:flutter/cupertino.dart';

class TrainingHubPage extends StatefulWidget {
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
  State<TrainingHubPage> createState() => _TrainingHubPageState();
}

class _TrainingHubPageState extends State<TrainingHubPage> {
  late final PuzzleLibraryProgressStore _puzzleStore;
  late final OpeningProgressStore _openingStore;
  int? _puzzlesSolved;
  int? _openingsCompleted;
  bool _puzzlesLoading = true;
  bool _openingsLoading = true;
  bool _puzzlesFailed = false;
  bool _openingsFailed = false;
  int _puzzleLoadRevision = 0;
  int _openingLoadRevision = 0;

  @override
  void initState() {
    super.initState();
    _puzzleStore = widget.puzzleProgressStore ??
        SharedPreferencesPuzzleLibraryProgressStore();
    _openingStore =
        widget.openingProgressStore ?? SharedPreferencesOpeningProgressStore();
    _loadProgress();
  }

  void _loadProgress() {
    _loadPuzzles();
    _loadOpenings();
  }

  Future<void> _loadPuzzles() async {
    final revision = ++_puzzleLoadRevision;
    setState(() {
      _puzzlesLoading = true;
      _puzzlesFailed = false;
    });
    try {
      final solved = await _puzzleStore.loadSolvedIds();
      if (!mounted || revision != _puzzleLoadRevision) return;
      setState(() {
        // Ignore IDs from removed content or future versions of the catalog.
        _puzzlesSolved =
            themedPuzzles.where((puzzle) => solved.contains(puzzle.id)).length;
        _puzzlesLoading = false;
      });
    } catch (_) {
      if (!mounted || revision != _puzzleLoadRevision) return;
      setState(() {
        _puzzlesFailed = true;
        _puzzlesLoading = false;
      });
    }
  }

  Future<void> _loadOpenings() async {
    final revision = ++_openingLoadRevision;
    setState(() {
      _openingsLoading = true;
      _openingsFailed = false;
    });
    try {
      final completed = await _openingStore.loadCompletedIds();
      if (!mounted || revision != _openingLoadRevision) return;
      setState(() {
        _openingsCompleted = openingCourses
            .where((course) => completed.contains(course.id.name))
            .length;
        _openingsLoading = false;
      });
    } catch (_) {
      if (!mounted || revision != _openingLoadRevision) return;
      setState(() {
        _openingsFailed = true;
        _openingsLoading = false;
      });
    }
  }

  Future<void> _openPractice(Widget page) async {
    await Navigator.push(
      context,
      CupertinoPageRoute<void>(builder: (_) => page),
    );
    if (mounted) _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return PracticeSessionScope(
      child: AppPage(
        title: strings.Training,
        child: AppContent(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text(
                strings.Training_Description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 17,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                key: const ValueKey('training-progress'),
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.Training_Progress,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ProgressRow(
                      key: const ValueKey('training-puzzle-progress'),
                      icon: CupertinoIcons.square_grid_2x2,
                      label: strings.Puzzle_Library,
                      loading: _puzzlesLoading,
                      value: _puzzlesFailed || _puzzlesSolved == null
                          ? null
                          : strings.Puzzles_Completed_Count(
                              _puzzlesSolved!, themedPuzzles.length),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ProgressRow(
                      key: const ValueKey('training-opening-progress'),
                      icon: CupertinoIcons.book,
                      label: strings.Opening_Trainer,
                      loading: _openingsLoading,
                      value: _openingsFailed || _openingsCompleted == null
                          ? null
                          : strings.Openings_Completed_Count(
                              _openingsCompleted!, openingCourses.length),
                    ),
                    if (_puzzlesFailed || _openingsFailed) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        strings.Training_Progress_Unavailable,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      CupertinoButton(
                        key: const ValueKey('training-progress-retry'),
                        padding: EdgeInsets.zero,
                        onPressed: _loadProgress,
                        child: Text(strings.Retry),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _TrainingCard(
                key: const ValueKey('training-puzzles-button'),
                icon: CupertinoIcons.square_grid_2x2,
                title: strings.Puzzle_Library,
                description: strings.Puzzle_Library_Description,
                onTap: () => _openPractice(PuzzleLibraryPage(
                  pieceTheme: widget.pieceTheme,
                  progressStore: _puzzleStore,
                )),
              ),
              const SizedBox(height: AppSpacing.md),
              _TrainingCard(
                key: const ValueKey('training-openings-button'),
                icon: CupertinoIcons.book,
                title: strings.Opening_Trainer,
                description: strings.Opening_Trainer_Description,
                onTap: () => _openPractice(OpeningTrainerPage(
                  pieceTheme: widget.pieceTheme,
                  progressStore: _openingStore,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool loading;
  final String? value;

  const _ProgressRow({
    super.key,
    required this.icon,
    required this.label,
    required this.loading,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.accent),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Semantics(
            label: label,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: loading
                  ? const CupertinoActivityIndicator()
                  : value != null
                      ? Text(value!,
                          style:
                              const TextStyle(color: AppColors.textSecondary))
                      : const Icon(CupertinoIcons.exclamationmark_circle,
                          size: 20, color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
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
          color: AppColors.surface,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 28),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: AppSpacing.xs),
                  Text(description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.4,
                      )),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(CupertinoIcons.chevron_forward,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
