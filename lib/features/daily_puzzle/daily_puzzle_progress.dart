import 'package:shared_preferences/shared_preferences.dart';

class PuzzleProgress {
  final int streak;
  final bool solvedToday;

  const PuzzleProgress({required this.streak, required this.solvedToday});
}

abstract class PuzzleProgressStore {
  Future<PuzzleProgress> load(DateTime today);

  Future<PuzzleProgress> markSolved(DateTime today);
}

class SharedPreferencesPuzzleProgressStore implements PuzzleProgressStore {
  static const _lastSolvedKey = 'dailyPuzzleLastSolved';
  static const _streakKey = 'dailyPuzzleStreak';

  @override
  Future<PuzzleProgress> load(DateTime today) async {
    final preferences = await SharedPreferences.getInstance();
    final todayKey = _dateKey(today);
    final yesterdayKey = _dateKey(
      DateTime(today.year, today.month, today.day - 1),
    );
    final lastSolved = preferences.getString(_lastSolvedKey);
    final storedStreak = preferences.getInt(_streakKey) ?? 0;
    return PuzzleProgress(
      streak: lastSolved == todayKey || lastSolved == yesterdayKey
          ? storedStreak
          : 0,
      solvedToday: lastSolved == todayKey,
    );
  }

  @override
  Future<PuzzleProgress> markSolved(DateTime today) async {
    final preferences = await SharedPreferences.getInstance();
    final todayKey = _dateKey(today);
    final lastSolved = preferences.getString(_lastSolvedKey);
    var streak = preferences.getInt(_streakKey) ?? 0;

    if (lastSolved != todayKey) {
      final yesterdayKey = _dateKey(
        DateTime(today.year, today.month, today.day - 1),
      );
      streak = lastSolved == yesterdayKey ? streak + 1 : 1;
      await preferences.setString(_lastSolvedKey, todayKey);
      await preferences.setInt(_streakKey, streak);
    }

    return PuzzleProgress(streak: streak, solvedToday: true);
  }
}

String _dateKey(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
