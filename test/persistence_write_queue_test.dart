import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('concurrent opening completions retain both IDs across store instances',
      () async {
    final first = SharedPreferencesOpeningProgressStore();
    final second = SharedPreferencesOpeningProgressStore();
    await Future.wait([
      first.markCompleted('italian'),
      second.markCompleted('london'),
    ]);
    expect(await first.loadCompletedIds(), {'italian', 'london'});
  });

  test('concurrent history saves retain both games across store instances',
      () async {
    final first = SharedPreferencesGameHistoryStore();
    final second = SharedPreferencesGameHistoryStore();
    final firstGame = _game(1);
    final secondGame = _game(2);
    await Future.wait([
      first.saveGame(firstGame),
      second.saveGame(secondGame),
    ]);
    expect((await first.loadGames()).map((game) => game.id),
        [secondGame.id, firstGame.id]);
  });

  test('overlapping history save and delete preserve the newly saved game',
      () async {
    final first = SharedPreferencesGameHistoryStore();
    final second = SharedPreferencesGameHistoryStore();
    final previousGame = _game(1);
    final newGame = _game(2);
    await first.saveGame(previousGame);
    await Future.wait([
      first.saveGame(newGame),
      second.deleteGame(previousGame.id),
    ]);
    expect((await first.loadGames()).map((game) => game.id), [newGame.id]);
  });

  test('a failed history mutation does not block the next valid mutation',
      () async {
    SharedPreferences.setMockInitialValues({'saved_game_history_v1': '{}'});
    final first = SharedPreferencesGameHistoryStore();
    await expectLater(first.saveGame(_game(1)), throwsA(isA<TypeError>()));
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('saved_game_history_v1'), '{}');

    // Simulate a successful retry after the underlying data is repaired.
    SharedPreferences.setMockInitialValues({});
    final second = SharedPreferencesGameHistoryStore();
    final game = _game(2);
    await second.saveGame(game);
    expect((await second.loadGames()).single.id, game.id);
  });
}

SavedGame _game(int day) => SavedGame.fromPgn(
      '[Result "1-0"]\n\n1. e4 e5 2. Nf3 Nc6 1-0',
      importedAt: DateTime(2026, 10, day),
    );
