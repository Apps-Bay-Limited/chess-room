import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move_meta.dart';
import 'package:chess_room/logic/shared_functions.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';

const standardStartingFen =
    'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1';

String squareName(int tile) {
  final file = String.fromCharCode(97 + tile % 8);
  final rank = 8 - tile ~/ 8;
  return '$file$rank';
}

int squareFromName(String square) {
  if (!RegExp(r'^[a-h][1-8]$').hasMatch(square)) {
    throw FormatException('Invalid chess square: $square');
  }
  final col = square.codeUnitAt(0) - 97;
  final row = 8 - int.parse(square[1]);
  return row * 8 + col;
}

String moveToUci(Move move) {
  final promotion = switch (move.promotionType) {
    ChessPieceType.queen => 'q',
    ChessPieceType.rook => 'r',
    ChessPieceType.bishop => 'b',
    ChessPieceType.knight => 'n',
    _ => '',
  };
  return '${squareName(move.from)}${squareName(move.to)}$promotion';
}

Move moveFromUci(String uci) {
  if (!RegExp(r'^[a-h][1-8][a-h][1-8][qrbn]?$').hasMatch(uci)) {
    throw FormatException('Invalid UCI move: $uci');
  }
  final promotionType =
      uci.length == 5 ? _promotionType(uci[4]) : ChessPieceType.promotion;
  return Move(
    squareFromName(uci.substring(0, 2)),
    squareFromName(uci.substring(2, 4)),
    promotionType: promotionType,
  );
}

String moveMetaToSan(MoveMeta meta) {
  if (meta.kingCastle) return 'O-O${_checkSuffix(meta)}';
  if (meta.queenCastle) return 'O-O-O${_checkSuffix(meta)}';

  final piece = _pieceLetter(meta.type);
  var ambiguity = '';
  if (meta.rowIsAmbiguous) {
    ambiguity += String.fromCharCode(97 + tileToCol(meta.move.from));
  }
  if (meta.colIsAmbiguous) {
    ambiguity += '${8 - tileToRow(meta.move.from)}';
  }
  final capture = meta.took ? 'x' : '';
  final promotion =
      meta.promotion ? '=${_pieceLetter(meta.promotionType)}' : '';
  return '$piece$ambiguity$capture${squareName(meta.move.to)}$promotion'
      '${_checkSuffix(meta)}';
}

String buildPgn({
  required List<MoveMeta> moves,
  required DateTime playedAt,
  required String result,
  String white = 'White',
  String black = 'Black',
  String initialFen = standardStartingFen,
}) {
  final date = '${playedAt.year.toString().padLeft(4, '0')}.'
      '${playedAt.month.toString().padLeft(2, '0')}.'
      '${playedAt.day.toString().padLeft(2, '0')}';
  final tags = <String>[
    '[Event "Chess Room Game"]',
    '[Site "Chess Room"]',
    '[Date "$date"]',
    '[White "${_escapeTag(white)}"]',
    '[Black "${_escapeTag(black)}"]',
    '[Result "$result"]',
    if (initialFen != standardStartingFen) '[SetUp "1"]',
    if (initialFen != standardStartingFen) '[FEN "${_escapeTag(initialFen)}"]',
  ];
  final notation = StringBuffer();
  for (var index = 0; index < moves.length; index++) {
    if (index.isEven) notation.write('${index ~/ 2 + 1}. ');
    notation.write('${moveMetaToSan(moves[index])} ');
  }
  notation.write(result);
  return '${tags.join('\n')}\n\n${notation.toString().trim()}';
}

class ParsedPgn {
  final String pgn;
  final String initialFen;
  final String result;
  final List<Move> moves;

  const ParsedPgn({
    required this.pgn,
    required this.initialFen,
    required this.result,
    required this.moves,
  });
}

ParsedPgn parsePgn(String source) {
  final trimmed = source.trim();
  if (trimmed.isEmpty) throw const FormatException('PGN is empty.');

  final tags = <String, String>{};
  for (final match
      in RegExp(r'^\[([A-Za-z0-9_]+)\s+"(.*)"\]\s*$', multiLine: true)
          .allMatches(trimmed)) {
    tags[match.group(1)!] = match.group(2)!.replaceAll(r'\"', '"');
  }
  final initialFen = tags['FEN'] ?? standardStartingFen;
  final position = initialFen == standardStartingFen
      ? ChessPosition(ChessBoard(), Player.player1)
      : chessPositionFromFen(initialFen);
  var activePlayer = position.activePlayer;
  var moveText =
      trimmed.replaceAll(RegExp(r'^\s*\[[^\]]+\]\s*$', multiLine: true), ' ');
  moveText = moveText
      .replaceAll(RegExp(r'\{[^}]*\}', dotAll: true), ' ')
      .replaceAll(RegExp(r';[^\n\r]*'), ' ')
      .replaceAll(RegExp(r'\([^()]*\)'), ' ')
      .replaceAll(RegExp(r'\$\d+'), ' ')
      .replaceAll(RegExp(r'\d+\.(\.\.)?'), ' ');

  final moves = <Move>[];
  var result = tags['Result'] ?? '*';
  for (var token in moveText.split(RegExp(r'\s+'))) {
    token = token.trim();
    if (token.isEmpty) continue;
    if (const {'1-0', '0-1', '1/2-1/2', '*'}.contains(token)) {
      result = token;
      continue;
    }
    final move = _moveFromSan(token, position.board, activePlayer);
    push(
      move,
      position.board,
      promotionType: move.promotionType,
    );
    moves.add(move);
    activePlayer = oppositePlayer(activePlayer);
  }
  if (moves.isEmpty) {
    throw const FormatException('PGN does not contain any supported moves.');
  }
  return ParsedPgn(
    pgn: trimmed,
    initialFen: initialFen,
    result: result,
    moves: moves,
  );
}

Move _moveFromSan(String rawToken, ChessBoard board, Player player) {
  final token = rawToken.replaceAll(RegExp(r'[+#?!]+$'), '');
  if (token == 'O-O' || token == '0-0') {
    return _castleMove(board, player, kingSide: true);
  }
  if (token == 'O-O-O' || token == '0-0-0') {
    return _castleMove(board, player, kingSide: false);
  }

  final match = RegExp(
    r'^([KQRBN])?([a-h])?([1-8])?x?([a-h][1-8])(?:=([QRBN]))?$',
  ).firstMatch(token);
  if (match == null) throw FormatException('Unsupported PGN move: $rawToken');
  final expectedType = _pieceType(match.group(1));
  final fromFile = match.group(2);
  final fromRank = match.group(3);
  final destination = squareFromName(match.group(4)!);
  final promotion = match.group(5) == null
      ? ChessPieceType.promotion
      : _pieceType(match.group(5));
  final candidates = <Move>[];
  for (final move in allMoves(player, board, 1)) {
    final piece = board.tiles[move.from];
    if (piece?.type != expectedType || move.to != destination) continue;
    if (fromFile != null && squareName(move.from)[0] != fromFile) continue;
    if (fromRank != null && squareName(move.from)[1] != fromRank) continue;
    candidates.add(
      Move(move.from, move.to, promotionType: promotion),
    );
  }
  if (candidates.length != 1) {
    throw FormatException('Ambiguous or illegal PGN move: $rawToken');
  }
  return candidates.single;
}

Move _castleMove(ChessBoard board, Player player, {required bool kingSide}) {
  final king = player == Player.player1 ? board.player1King : board.player2King;
  if (king == null) {
    throw const FormatException('Cannot castle without a king.');
  }
  final target = (player == Player.player1 ? 56 : 0) + (kingSide ? 7 : 0);
  final legalTargets = movesForPiece(king, board);
  if (!legalTargets.contains(target)) {
    throw const FormatException('Illegal castling move.');
  }
  return Move(king.tile, target);
}

ChessPieceType _pieceType(String? letter) => switch (letter) {
      'K' => ChessPieceType.king,
      'Q' => ChessPieceType.queen,
      'R' => ChessPieceType.rook,
      'B' => ChessPieceType.bishop,
      'N' => ChessPieceType.knight,
      _ => ChessPieceType.pawn,
    };

ChessPieceType _promotionType(String letter) => switch (letter.toLowerCase()) {
      'q' => ChessPieceType.queen,
      'r' => ChessPieceType.rook,
      'b' => ChessPieceType.bishop,
      'n' => ChessPieceType.knight,
      _ => throw FormatException('Invalid promotion: $letter'),
    };

String _pieceLetter(ChessPieceType type) => switch (type) {
      ChessPieceType.king => 'K',
      ChessPieceType.queen => 'Q',
      ChessPieceType.rook => 'R',
      ChessPieceType.bishop => 'B',
      ChessPieceType.knight => 'N',
      _ => '',
    };

String _checkSuffix(MoveMeta meta) => meta.isCheckmate && !meta.isStalemate
    ? '#'
    : meta.isCheck
        ? '+'
        : '';

String _escapeTag(String value) => value.replaceAll('"', r'\"');
