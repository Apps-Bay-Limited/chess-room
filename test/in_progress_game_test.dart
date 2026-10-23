import 'dart:convert';

import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/model/in_progress_game.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('restores castling rights, piece counters and undo/redo branch', () {
    final board = _play([
      'e2e4',
      'e7e5',
      'g1f3',
      'b8c6',
      'f1e2',
      'g8f6',
      'e1h1',
    ]);
    board.redoStack.add(pop(board));
    final restored = _roundTrip(_snapshot(board, Player.player1)).restore();

    expect(restored.board.moveCount, 6);
    expect(restored.board.player1King!.moveCount, 0);
    expect(restored.board.redoStack, hasLength(1));
    final castle =
        pushMSO(restored.board.redoStack.removeLast(), restored.board);
    expect(castle.kingCastle, isTrue);
    expect(restored.board.player1King!.tile, 62);
    expect(restored.board.tiles[61]!.type, ChessPieceType.rook);
    expect(restored.board.player1King!.moveCount, 1);
    pop(restored.board);
    expect(restored.board.player1King!.tile, 60);
    expect(restored.board.player1King!.moveCount, 0);
  });

  test('restores the en passant opportunity and undo after the capture', () {
    final board = _play(['e2e4', 'a7a6', 'e4e5', 'd7d5']);
    final restored = _roundTrip(_snapshot(board, Player.player1)).restore();
    final pawn = restored.board.tiles[28]!;
    expect(movesForPiece(pawn, restored.board), contains(19));
    push(moveFromUci('e5d6'), restored.board);
    expect(restored.board.tiles[27], isNull);
    final captured =
        _roundTrip(_snapshot(restored.board, Player.player2)).restore().board;
    expect(captured.moveStack.last.enPassant, isTrue);
    pop(captured);
    expect(captured.tiles[27]!.type, ChessPieceType.pawn);
    expect(captured.enPassantPiece, same(captured.tiles[27]));
  });

  test('restores underpromotion and can undo back to a pawn', () {
    final board = _promotionPosition();
    push(moveFromUci('b7a8'), board, promotionType: ChessPieceType.knight);
    final restored = _roundTrip(_snapshot(board, Player.player2)).restore();
    expect(restored.board.tiles[0]!.type, ChessPieceType.knight);
    expect(restored.metadata.last.promotionType, ChessPieceType.knight);
    pop(restored.board);
    expect(restored.board.tiles[9]!.type, ChessPieceType.pawn);
    expect(restored.board.tiles[0]!.type, ChessPieceType.rook);
  });

  test('unfinished promotion restores the decision and retains mover turn', () {
    final board = _promotionPosition();
    push(moveFromUci('b7a8'), board);
    final restored = _roundTrip(_snapshot(board, Player.player1)).restore();
    expect(restored.promotionPending, isTrue);
    expect(restored.board.tiles[0]!.type, ChessPieceType.promotion);
  });

  test('restores redo order with several undone moves', () {
    final board = _play(['e2e4', 'e7e5', 'g1f3', 'b8c6']);
    board.redoStack.add(pop(board));
    board.redoStack.add(pop(board));
    final restored = _roundTrip(_snapshot(board, Player.player1)).restore();
    expect(restored.board.moveCount, 2);
    expect(restored.board.redoStack.last.move, moveFromUci('g1f3'));
    pushMSO(restored.board.redoStack.removeLast(), restored.board);
    expect(restored.board.redoStack.last.move, moveFromUci('b8c6'));
  });

  test('corrupt or illegal saved data is removed without blocking startup',
      () async {
    final prefs = await SharedPreferences.getInstance();
    final store = SharedPreferencesInProgressGameStore();
    for (final encoded in [
      '{broken json',
      jsonEncode({'version': 99}),
      jsonEncode(_snapshot(ChessBoard(), Player.player1).toJson()
        ..['moves'] = [
          {'from': 48, 'to': 0, 'promotion': 'promotion'}
        ]),
      jsonEncode(_snapshot(ChessBoard(), Player.player1).toJson()
        ..['turn'] = 'player2'),
    ]) {
      await prefs.setString(
          SharedPreferencesInProgressGameStore.storageKey, encoded);
      expect(await store.load(), isNull);
      expect(prefs.containsKey(SharedPreferencesInProgressGameStore.storageKey),
          isFalse);
    }
  });

  test('session IDs round-trip without breaking legacy version-one saves',
      () async {
    final original = _snapshot(_play(['e2e4', 'e7e5']), Player.player1);
    final legacyJson = original.toJson()..remove('sessionId');
    final legacy = InProgressGame.fromJson(legacyJson);
    expect(legacy.sessionId, isNull);
    expect(legacy.restore().board.moveCount, 2);

    // A resumed legacy match receives one ID from AppModel. Persisting it must
    // retain that same identity for later resumes and completion deduplication.
    const stableId = 'game-legacy-resume-stable-identity';
    final identified = InProgressGame.fromJson({
      ...legacyJson,
      'sessionId': stableId,
    });
    final store = SharedPreferencesInProgressGameStore();
    await store.save(_roundTrip(identified));
    final firstLoad = (await store.load())!;
    await store.save(_roundTrip(firstLoad));
    final secondLoad = (await store.load())!;
    expect(firstLoad.sessionId, stableId);
    expect(secondLoad.sessionId, stableId);
    expect(secondLoad.restore().board.moveCount, 2);
    expect(chessPositionToFen(secondLoad.restore().board, Player.player1),
        chessPositionToFen(original.restore().board, Player.player1));
  });

  test('storage persists clocks and independent match settings', () async {
    final store = SharedPreferencesInProgressGameStore();
    final saved = _snapshot(_play(['e2e4']), Player.player2);
    await store.save(saved);
    final loaded = (await store.load())!;
    expect(loaded.whiteTimeMs, 120345);
    expect(loaded.blackTimeMs, 234567);
    expect(loaded.aiDifficulty, 5);
    expect(loaded.playerSide, Player.player2);
    await store.clear();
    expect(await store.load(), isNull);
  });
}

ChessBoard _play(List<String> moves) {
  final board = ChessBoard();
  for (final uci in moves) {
    push(moveFromUci(uci), board);
  }
  return board;
}

ChessBoard _promotionPosition() => _play([
      'a2a4',
      'h7h5',
      'a4a5',
      'h5h4',
      'a5a6',
      'h4h3',
      'a6b7',
      'h3g2',
    ]);

InProgressGame _snapshot(ChessBoard board, Player turn) => InProgressGame(
      playerCount: 2,
      aiDifficulty: 5,
      selectedSide: Player.player2,
      playerSide: Player.player2,
      timeLimit: 5,
      turn: turn,
      whiteTimeMs: 120345,
      blackTimeMs: 234567,
      moves: board.moveStack.map(InProgressGame.copyStackMove).toList(),
      redoMoves:
          board.redoStack.reversed.map(InProgressGame.copyStackMove).toList(),
      reviews: const [],
    );

InProgressGame _roundTrip(InProgressGame game) => InProgressGame.fromJson(
      Map<String, Object?>.from(jsonDecode(jsonEncode(game.toJson())) as Map),
    );
