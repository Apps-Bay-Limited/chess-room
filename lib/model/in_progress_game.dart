import 'dart:convert';

import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move_meta.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move_stack_object.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Replays from the standard starting position so piece move counts, castling,
/// en passant and undo information are retained. FEN alone loses that state in
/// this engine.
class InProgressGame {
  final String? sessionId;
  final int playerCount;
  final int aiDifficulty;
  final Player selectedSide;
  final Player playerSide;
  final int timeLimit;
  final Player turn;
  final int whiteTimeMs;
  final int blackTimeMs;
  final List<Move> moves;
  final List<Move> redoMoves;
  final List<MoveReviewRecord> reviews;

  const InProgressGame({
    this.sessionId,
    required this.playerCount,
    required this.aiDifficulty,
    required this.selectedSide,
    required this.playerSide,
    required this.timeLimit,
    required this.turn,
    required this.whiteTimeMs,
    required this.blackTimeMs,
    required this.moves,
    required this.redoMoves,
    required this.reviews,
  });

  static Move copyStackMove(MoveStackObject entry) => Move(
        entry.move.from,
        entry.move.to,
        promotionType:
            entry.promotion ? entry.promotionType : ChessPieceType.promotion,
      );

  Map<String, Object?> toJson() => {
        'version': 1,
        'sessionId': sessionId,
        'playerCount': playerCount,
        'aiDifficulty': aiDifficulty,
        'selectedSide': selectedSide.name,
        'playerSide': playerSide.name,
        'timeLimit': timeLimit,
        'turn': turn.name,
        'whiteTimeMs': whiteTimeMs,
        'blackTimeMs': blackTimeMs,
        'moves': moves.map(_encodeMove).toList(),
        'redoMoves': redoMoves.map(_encodeMove).toList(),
        'reviews': reviews.map((review) => review.toJson()).toList(),
      };

  factory InProgressGame.fromJson(Map<String, Object?> json) {
    if (json['version'] != 1) {
      throw const FormatException('Unsupported unfinished game version.');
    }
    final game = InProgressGame(
      sessionId: json['sessionId'] as String?,
      playerCount: json['playerCount']! as int,
      aiDifficulty: json['aiDifficulty']! as int,
      selectedSide: Player.values.byName(json['selectedSide']! as String),
      playerSide: Player.values.byName(json['playerSide']! as String),
      timeLimit: json['timeLimit']! as int,
      turn: Player.values.byName(json['turn']! as String),
      whiteTimeMs: json['whiteTimeMs']! as int,
      blackTimeMs: json['blackTimeMs']! as int,
      moves: (json['moves']! as List).map(_decodeMove).toList(),
      redoMoves: (json['redoMoves']! as List).map(_decodeMove).toList(),
      reviews: (json['reviews']! as List)
          .map((value) => MoveReviewRecord.fromJson(
                Map<String, Object?>.from(value as Map),
              ))
          .toList(),
    );
    if ((game.playerCount != 1 && game.playerCount != 2) ||
        !const [1, 3, 5, 6].contains(game.aiDifficulty) ||
        game.playerSide == Player.random ||
        game.turn == Player.random ||
        game.timeLimit < 0 ||
        game.timeLimit > 90 ||
        game.whiteTimeMs < 0 ||
        game.blackTimeMs < 0 ||
        (game.timeLimit > 0 &&
            (game.whiteTimeMs == 0 || game.blackTimeMs == 0)) ||
        game.moves.length + game.redoMoves.length > 5000 ||
        game.reviews.length > game.moves.length) {
      throw const FormatException('Invalid unfinished game settings.');
    }
    return game;
  }

  RestoredGame restore() {
    final board = ChessBoard();
    final metadata = <MoveMeta>[];
    var player = Player.player1;
    for (final move in [...moves, ...redoMoves]) {
      final piece = board.tiles[move.from];
      if (piece == null ||
          piece.player != player ||
          !movesForPiece(piece, board).contains(move.to)) {
        throw const FormatException('Invalid unfinished game move.');
      }
      final meta =
          push(move, board, getMeta: true, promotionType: move.promotionType);
      player = player == Player.player1 ? Player.player2 : Player.player1;
      meta.isCheck = kingInCheck(player, board);
      metadata.add(meta);
    }
    for (var index = 0; index < redoMoves.length; index++) {
      board.redoStack.add(pop(board));
      metadata.removeLast();
    }
    final promotionPending = board.moveStack.isNotEmpty &&
        board.moveStack.last.movedPiece.type == ChessPieceType.promotion;
    final expectedTurn = moves.length.isEven ? Player.player1 : Player.player2;
    if (turn !=
        (promotionPending
            ? (expectedTurn == Player.player1 ? Player.player2 : Player.player1)
            : expectedTurn)) {
      throw const FormatException('Invalid unfinished game turn.');
    }
    return RestoredGame(board, metadata, promotionPending);
  }
}

class RestoredGame {
  final ChessBoard board;
  final List<MoveMeta> metadata;
  final bool promotionPending;

  const RestoredGame(this.board, this.metadata, this.promotionPending);
}

Map<String, Object> _encodeMove(Move move) => {
      'from': move.from,
      'to': move.to,
      'promotion': move.promotionType.name,
    };

Move _decodeMove(Object? value) {
  final json = Map<String, Object?>.from(value as Map);
  final from = json['from']! as int;
  final to = json['to']! as int;
  final type = ChessPieceType.values.byName(json['promotion']! as String);
  if (from < 0 ||
      from > 63 ||
      to < 0 ||
      to > 63 ||
      from == to ||
      type == ChessPieceType.king ||
      type == ChessPieceType.pawn) {
    throw const FormatException('Invalid unfinished game square.');
  }
  return Move(from, to, promotionType: type);
}

abstract class InProgressGameStore {
  Future<InProgressGame?> load();
  Future<void> save(InProgressGame game);
  Future<void> clear();
}

class SharedPreferencesInProgressGameStore implements InProgressGameStore {
  static const storageKey = 'in_progress_game_v1';

  @override
  Future<InProgressGame?> load() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final encoded = prefs.getString(storageKey);
      if (encoded == null) return null;
      final saved = InProgressGame.fromJson(
          Map<String, Object?>.from(jsonDecode(encoded) as Map));
      saved.restore();
      return saved;
    } catch (_) {
      await prefs.remove(storageKey);
      return null;
    }
  }

  @override
  Future<void> save(InProgressGame game) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(game.toJson()));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }
}
