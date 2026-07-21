import 'dart:convert';

import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SavedGameResult { whiteWin, blackWin, draw, unfinished }

class SavedGame {
  final String id;
  final DateTime playedAt;
  final SavedGameResult result;
  final String pgn;
  final String initialFen;
  final List<String> moves;
  final List<MoveReviewRecord> reviews;

  const SavedGame({
    required this.id,
    required this.playedAt,
    required this.result,
    required this.pgn,
    required this.initialFen,
    required this.moves,
    required this.reviews,
  });

  factory SavedGame.fromPgn(String pgn, {DateTime? importedAt}) {
    final parsed = parsePgn(pgn);
    final playedAt = importedAt ?? DateTime.now();
    return SavedGame(
      id: 'import-${playedAt.microsecondsSinceEpoch}',
      playedAt: playedAt,
      result: savedGameResultFromPgn(parsed.result),
      pgn: parsed.pgn,
      initialFen: parsed.initialFen,
      moves: parsed.moves.map(moveToUci).toList(growable: false),
      reviews: const [],
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'playedAt': playedAt.toIso8601String(),
        'result': result.name,
        'pgn': pgn,
        'initialFen': initialFen,
        'moves': moves,
        'reviews': reviews.map((review) => review.toJson()).toList(),
      };

  factory SavedGame.fromJson(Map<String, Object?> json) => SavedGame(
        id: json['id']! as String,
        playedAt: DateTime.parse(json['playedAt']! as String),
        result: SavedGameResult.values.byName(json['result']! as String),
        pgn: json['pgn']! as String,
        initialFen: json['initialFen'] as String? ?? standardStartingFen,
        moves: (json['moves']! as List).cast<String>(),
        reviews: ((json['reviews'] as List?) ?? const [])
            .map((value) => MoveReviewRecord.fromJson(
                  Map<String, Object?>.from(value as Map),
                ))
            .toList(growable: false),
      );
}

SavedGameResult savedGameResultFromPgn(String result) => switch (result) {
      '1-0' => SavedGameResult.whiteWin,
      '0-1' => SavedGameResult.blackWin,
      '1/2-1/2' => SavedGameResult.draw,
      _ => SavedGameResult.unfinished,
    };

String savedGameResultToPgn(SavedGameResult result) => switch (result) {
      SavedGameResult.whiteWin => '1-0',
      SavedGameResult.blackWin => '0-1',
      SavedGameResult.draw => '1/2-1/2',
      SavedGameResult.unfinished => '*',
    };

abstract class GameHistoryStore {
  Future<List<SavedGame>> loadGames();

  Future<void> saveGame(SavedGame game);

  Future<void> deleteGame(String id);
}

class SharedPreferencesGameHistoryStore implements GameHistoryStore {
  static const _key = 'saved_game_history_v1';
  static const _maximumGames = 100;

  @override
  Future<List<SavedGame>> loadGames() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_key);
    if (encoded == null || encoded.isEmpty) return [];
    try {
      return (jsonDecode(encoded) as List)
          .map((value) => SavedGame.fromJson(
                Map<String, Object?>.from(value as Map),
              ))
          .toList(growable: false);
    } on FormatException {
      return [];
    }
  }

  @override
  Future<void> saveGame(SavedGame game) async {
    final games =
        (await loadGames()).where((item) => item.id != game.id).toList();
    games.insert(0, game);
    if (games.length > _maximumGames) {
      games.removeRange(_maximumGames, games.length);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(games.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteGame(String id) async {
    final games = (await loadGames()).where((game) => game.id != id).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(games.map((item) => item.toJson()).toList()),
    );
  }
}
