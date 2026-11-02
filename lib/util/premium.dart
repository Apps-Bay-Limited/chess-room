import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// What the one shared premium purchase unlocks, and how much of it a player
/// can use before buying. Every feature stays reachable for free so the paid
/// upgrade widens limits instead of hiding whole screens.
class PremiumLimits {
  const PremiumLimits._();

  static const int freeLibraryPuzzlesPerDay = 3;
  static const int freeGameReviewsPerDay = 3;

  /// Courses are unlocked from the top of [openingCourses], so the free tier
  /// always gets a complete course rather than a truncated one.
  static const int freeOpeningCourses = 1;

  /// Older games stay saved and are only hidden behind the upgrade, so nothing
  /// a free player recorded is ever lost.
  static const int freeSavedGames = 10;

  static const Set<String> freePieceThemes = {
    'Classic',
    'Angular',
    'Letters',
  };

  static const Set<String> freeBoardThemes = {
    'AppsBay',
    'Green',
    'Blue',
    'Red',
    'Dark',
    'Light',
    'Black & White',
  };
}

/// The gated feature a paywall was opened for, so the sheet can lead with the
/// benefit the player just reached for.
enum PremiumFeature {
  libraryPuzzles,
  gameReview,
  openingCourses,
  pieceTheme,
  boardTheme,
  gameHistory,
}

/// The daily allowances a free player has already spent.
class PremiumUsage {
  final int libraryPuzzles;
  final int gameReviews;

  const PremiumUsage({this.libraryPuzzles = 0, this.gameReviews = 0});

  PremiumUsage copyWith({int? libraryPuzzles, int? gameReviews}) {
    return PremiumUsage(
      libraryPuzzles: libraryPuzzles ?? this.libraryPuzzles,
      gameReviews: gameReviews ?? this.gameReviews,
    );
  }
}

enum PremiumDailyAllowance { libraryPuzzles, gameReviews }

abstract class PremiumUsageStore {
  Future<PremiumUsage> load(DateTime day);

  /// Records one use and returns the day's totals including it.
  Future<PremiumUsage> increment(PremiumDailyAllowance allowance, DateTime day);
}

class SharedPreferencesPremiumUsageStore implements PremiumUsageStore {
  static const _key = 'premium_daily_usage_v1';
  static Future<void> _pendingWrite = Future<void>.value();

  @override
  Future<PremiumUsage> load(DateTime day) async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(prefs.getString(_key), day);
  }

  @override
  Future<PremiumUsage> increment(
    PremiumDailyAllowance allowance,
    DateTime day,
  ) {
    // Two practice screens can finish a position at the same time, and each
    // update has to observe the previous one's committed totals.
    final update = _pendingWrite.then((_) async {
      final prefs = await SharedPreferences.getInstance();
      final current = _decode(prefs.getString(_key), day);
      final updated = switch (allowance) {
        PremiumDailyAllowance.libraryPuzzles =>
          current.copyWith(libraryPuzzles: current.libraryPuzzles + 1),
        PremiumDailyAllowance.gameReviews =>
          current.copyWith(gameReviews: current.gameReviews + 1),
      };
      await prefs.setString(
        _key,
        jsonEncode({
          'day': _dayKey(day),
          'libraryPuzzles': updated.libraryPuzzles,
          'gameReviews': updated.gameReviews,
        }),
      );
      return updated;
    });
    _pendingWrite = update.then((_) {}).catchError((Object _) {});
    return update;
  }

  /// Counters recorded on an earlier day read back as unused, which is how the
  /// allowance resets without a scheduled job.
  static PremiumUsage _decode(String? encoded, DateTime day) {
    if (encoded == null || encoded.isEmpty) return const PremiumUsage();
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map || decoded['day'] != _dayKey(day)) {
        return const PremiumUsage();
      }
      final libraryPuzzles = decoded['libraryPuzzles'];
      final gameReviews = decoded['gameReviews'];
      return PremiumUsage(
        libraryPuzzles: libraryPuzzles is int ? max(0, libraryPuzzles) : 0,
        gameReviews: gameReviews is int ? max(0, gameReviews) : 0,
      );
    } on FormatException {
      return const PremiumUsage();
    }
  }
}

String _dayKey(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Answers "may this player use that?" from the entitlement plus the day's
/// spent allowances, so every gated surface asks the question the same way.
class PremiumAccess {
  final bool isPremium;
  final PremiumUsage usage;

  const PremiumAccess({required this.isPremium, required this.usage});

  int get libraryPuzzlesLeft {
    if (isPremium) return -1;
    return max(0, PremiumLimits.freeLibraryPuzzlesPerDay - usage.libraryPuzzles);
  }

  int get gameReviewsLeft {
    if (isPremium) return -1;
    return max(0, PremiumLimits.freeGameReviewsPerDay - usage.gameReviews);
  }

  bool get canSolveLibraryPuzzle => isPremium || libraryPuzzlesLeft > 0;

  bool get canReviewGame => isPremium || gameReviewsLeft > 0;

  bool isOpeningCourseUnlocked(int index) =>
      isPremium || index < PremiumLimits.freeOpeningCourses;

  bool isPieceThemeUnlocked(String pieceTheme) =>
      isPremium || PremiumLimits.freePieceThemes.contains(pieceTheme);

  bool isBoardThemeUnlocked(String themeName) =>
      isPremium || PremiumLimits.freeBoardThemes.contains(themeName);

  /// `null` when the whole archive is readable.
  int? get visibleSavedGameLimit =>
      isPremium ? null : PremiumLimits.freeSavedGames;
}
