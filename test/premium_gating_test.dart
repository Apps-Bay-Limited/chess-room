import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/app_themes.dart';
import 'package:chess_room/util/premium.dart';
import 'package:chess_room/util/premium_purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('PremiumAccess', () {
    const free = PremiumAccess(isPremium: false, usage: PremiumUsage());
    const paid = PremiumAccess(isPremium: true, usage: PremiumUsage());

    test('premium lifts every limit the free tier applies', () {
      expect(paid.canSolveLibraryPuzzle, isTrue);
      expect(paid.canReviewGame, isTrue);
      expect(paid.visibleSavedGameLimit, isNull);
      for (var index = 0; index < 5; index++) {
        expect(paid.isOpeningCourseUnlocked(index), isTrue);
      }
      for (final theme in PIECE_THEMES) {
        expect(paid.isPieceThemeUnlocked(theme), isTrue);
      }
      for (final theme in themeList) {
        expect(paid.isBoardThemeUnlocked(theme.name), isTrue);
      }
    });

    test('the free tier keeps a sample of every gated feature', () {
      expect(free.libraryPuzzlesLeft, PremiumLimits.freeLibraryPuzzlesPerDay);
      expect(free.gameReviewsLeft, PremiumLimits.freeGameReviewsPerDay);
      expect(free.canSolveLibraryPuzzle, isTrue);
      expect(free.canReviewGame, isTrue);
      expect(free.isOpeningCourseUnlocked(0), isTrue);
      expect(free.isOpeningCourseUnlocked(1), isFalse);
      expect(free.visibleSavedGameLimit, PremiumLimits.freeSavedGames);
      expect(free.isPieceThemeUnlocked('Classic'), isTrue);
      expect(free.isPieceThemeUnlocked('Video Chess'), isFalse);
      expect(free.isBoardThemeUnlocked('AppsBay'), isTrue);
      expect(free.isBoardThemeUnlocked('Vaporwave'), isFalse);
    });

    test('a spent allowance reports nothing left without going negative', () {
      const spent = PremiumAccess(
        isPremium: false,
        usage: PremiumUsage(libraryPuzzles: 9, gameReviews: 9),
      );

      expect(spent.libraryPuzzlesLeft, 0);
      expect(spent.gameReviewsLeft, 0);
      expect(spent.canSolveLibraryPuzzle, isFalse);
      expect(spent.canReviewGame, isFalse);
    });

    test('every free theme name matches a theme that ships', () {
      final boardNames = themeList.map((theme) => theme.name).toSet();
      expect(boardNames, containsAll(PremiumLimits.freeBoardThemes));
      expect(PIECE_THEMES.toSet(), containsAll(PremiumLimits.freePieceThemes));
    });
  });

  group('SharedPreferencesPremiumUsageStore', () {
    final today = DateTime(2026, 11, 1);

    test('counts uses within a day and resets on the next one', () async {
      final store = SharedPreferencesPremiumUsageStore();

      expect((await store.load(today)).libraryPuzzles, 0);
      await store.increment(PremiumDailyAllowance.libraryPuzzles, today);
      final after =
          await store.increment(PremiumDailyAllowance.libraryPuzzles, today);

      expect(after.libraryPuzzles, 2);
      expect((await store.load(today)).libraryPuzzles, 2);
      expect((await store.load(DateTime(2026, 11, 2))).libraryPuzzles, 0);
    });

    test('tracks each allowance separately', () async {
      final store = SharedPreferencesPremiumUsageStore();

      await store.increment(PremiumDailyAllowance.gameReviews, today);
      final usage = await store.load(today);

      expect(usage.gameReviews, 1);
      expect(usage.libraryPuzzles, 0);
    });

    test('unreadable counters read as unused', () async {
      SharedPreferences.setMockInitialValues(
          {'premium_daily_usage_v1': 'not json'});

      final usage = await SharedPreferencesPremiumUsageStore().load(today);

      expect(usage.libraryPuzzles, 0);
      expect(usage.gameReviews, 0);
    });
  });

  group('AppModel allowances', () {
    test('a free player spends the daily puzzles and is then refused',
        () async {
      final model = AppModel(premiumUsageStore: _FakeUsageStore());
      addTearDown(model.dispose);
      await model.initialization;

      for (var index = 0; index < PremiumLimits.freeLibraryPuzzlesPerDay;
          index++) {
        expect(await model.consumeLibraryPuzzle(), isTrue,
            reason: 'puzzle ${index + 1} is within the free allowance');
      }

      expect(await model.consumeLibraryPuzzle(), isFalse);
      expect(model.premiumAccess.canSolveLibraryPuzzle, isFalse);
      expect(model.premiumAccess.canReviewGame, isTrue);
    });

    test('a premium player never spends an allowance', () async {
      SharedPreferences.setMockInitialValues({premiumEntitlementKey: true});
      final usageStore = _FakeUsageStore();
      final model = AppModel(premiumUsageStore: usageStore);
      addTearDown(model.dispose);
      await model.purchaseInitialization;
      await model.initialization;

      for (var index = 0; index < 20; index++) {
        expect(await model.consumeLibraryPuzzle(), isTrue);
        expect(await model.consumeGameReview(), isTrue);
      }

      expect(usageStore.increments, 0);
      expect(model.premiumAccess.isPremium, isTrue);
    });

    test('an unwritable counter never blocks practice', () async {
      final model = AppModel(premiumUsageStore: _BrokenUsageStore());
      addTearDown(model.dispose);
      await model.initialization;

      expect(await model.consumeLibraryPuzzle(), isTrue);
      expect(await model.consumeGameReview(), isTrue);
    });

    test('locked themes are refused by the setters', () async {
      final model = AppModel(premiumUsageStore: _FakeUsageStore());
      addTearDown(model.dispose);
      await model.initialization;

      final lockedBoard =
          themeList.indexWhere((theme) => theme.name == 'Vaporwave');
      final lockedPieces = model.pieceThemes.indexOf('Video Chess');
      final freeBoard = themeList.indexWhere((theme) => theme.name == 'Green');

      model.setTheme(lockedBoard);
      model.setPieceTheme(lockedPieces);
      expect(model.themeName, isNot('Vaporwave'));
      expect(model.pieceTheme, isNot('Video Chess'));

      model.setTheme(freeBoard);
      expect(model.themeName, 'Green');
    });
  });
}

class _FakeUsageStore implements PremiumUsageStore {
  PremiumUsage usage = const PremiumUsage();
  int increments = 0;

  @override
  Future<PremiumUsage> load(DateTime day) async => usage;

  @override
  Future<PremiumUsage> increment(
    PremiumDailyAllowance allowance,
    DateTime day,
  ) async {
    increments++;
    usage = switch (allowance) {
      PremiumDailyAllowance.libraryPuzzles =>
        usage.copyWith(libraryPuzzles: usage.libraryPuzzles + 1),
      PremiumDailyAllowance.gameReviews =>
        usage.copyWith(gameReviews: usage.gameReviews + 1),
    };
    return usage;
  }
}

class _BrokenUsageStore implements PremiumUsageStore {
  @override
  Future<PremiumUsage> load(DateTime day) async =>
      throw StateError('storage unavailable');

  @override
  Future<PremiumUsage> increment(
    PremiumDailyAllowance allowance,
    DateTime day,
  ) async =>
      throw StateError('storage unavailable');
}
