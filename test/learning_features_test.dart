import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:chess_room/features/puzzle_library/themed_puzzle.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move_meta.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('PGN export and import preserve a complete move sequence', () {
    final board = ChessBoard();
    final moves = ['e2e4', 'e7e5', 'g1f3', 'b8c6', 'f1c4', 'f8c5'];
    final metadata = <MoveMeta>[];
    for (final uci in moves) {
      final move = moveFromUci(uci);
      metadata.add(push(move, board, getMeta: true));
    }

    final pgn = buildPgn(
      moves: metadata,
      playedAt: DateTime(2026, 7, 22),
      result: '*',
    );
    final parsed = parsePgn(pgn);

    expect(parsed.moves.map(moveToUci), moves);
    expect(pgn, contains('1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 *'));
  });

  test('saved game history persists, imports, and deletes PGN games', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SharedPreferencesGameHistoryStore();
    final game = SavedGame.fromPgn(
      '[Result "1-0"]\n\n1. e4 e5 2. Nf3 Nc6 1-0',
      importedAt: DateTime(2026, 7, 22),
    );

    await store.saveGame(game);
    final loaded = await store.loadGames();

    expect(loaded, hasLength(1));
    expect(loaded.single.moves, ['e2e4', 'e7e5', 'g1f3', 'b8c6']);
    expect(loaded.single.result, SavedGameResult.whiteWin);

    await store.deleteGame(game.id);
    expect(await store.loadGames(), isEmpty);
  });

  test('ending a game automatically saves its PGN and replay moves', () async {
    SharedPreferences.setMockInitialValues({});
    final history = _MemoryGameHistoryStore();
    final model = AppModel(gameHistoryStore: history);
    final board = ChessBoard();
    final move = moveFromUci('e2e4');
    model.moveMetaList.add(push(move, board, getMeta: true));
    model.turn = Player.player2;

    model.endGame();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(history.games, hasLength(1));
    expect(history.games.single.moves, ['e2e4']);
    expect(history.games.single.pgn, contains('1. e4 1-0'));
    model.dispose();
  });

  test('PGN import supports standard king-side castling', () {
    final parsed = parsePgn(
      '[Result "*"]\n\n'
      '1. e4 e5 2. Nf3 Nc6 3. Bc4 Nf6 4. O-O *',
    );

    expect(parsed.moves.map(moveToUci).last, 'e1h1');
  });

  test('every themed puzzle starts with a legal solution', () {
    for (final puzzle in themedPuzzles) {
      final position = chessPositionFromFen(puzzle.fen);
      final move = moveFromUci(puzzle.solution);
      final piece = position.board.tiles[move.from];

      expect(piece, isNotNull, reason: puzzle.id);
      expect(piece!.player, position.activePlayer, reason: puzzle.id);
      expect(movesForPiece(piece, position.board), contains(move.to),
          reason: puzzle.id);
    }
  });

  test('every opening course is a legal line from the initial position', () {
    for (final course in openingCourses) {
      final board = ChessBoard();
      var player = Player.player1;
      for (final uci in course.moves) {
        final move = moveFromUci(uci);
        final piece = board.tiles[move.from];
        expect(piece, isNotNull, reason: '${course.id.name}: $uci');
        expect(piece!.player, player, reason: '${course.id.name}: $uci');
        expect(movesForPiece(piece, board), contains(move.to),
            reason: '${course.id.name}: $uci');
        push(move, board);
        player = player == Player.player1 ? Player.player2 : Player.player1;
      }
    }
  });
}

class _MemoryGameHistoryStore implements GameHistoryStore {
  final List<SavedGame> games = [];

  @override
  Future<void> deleteGame(String id) async {
    games.removeWhere((game) => game.id == id);
  }

  @override
  Future<List<SavedGame>> loadGames() async => List.of(games);

  @override
  Future<void> saveGame(SavedGame game) async => games.add(game);
}
