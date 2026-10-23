import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/logic/chess_piece_labels.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/logic/shared_functions.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';

String puzzleDifficultyLabel(S strings, PuzzleDifficulty difficulty) =>
    switch (difficulty) {
      PuzzleDifficulty.easy => strings.Puzzle_Easy,
      PuzzleDifficulty.medium => strings.Puzzle_Medium,
      PuzzleDifficulty.hard => strings.Puzzle_Hard,
    };

String puzzleMotifLabel(S strings, PuzzleMotif motif) => switch (motif) {
      PuzzleMotif.queenNet => strings.Theme_Queen_Net,
      PuzzleMotif.backRank => strings.Theme_Back_Rank,
      PuzzleMotif.knightMate => strings.Theme_Knight_Mate,
      PuzzleMotif.rookMate => strings.Theme_Rook_Mate,
      PuzzleMotif.bishopMate => strings.Theme_Bishop_Mate,
      PuzzleMotif.fork => strings.Theme_Forks,
      PuzzleMotif.promotion => strings.Theme_Promotion,
      PuzzleMotif.combination => strings.Theme_Combination,
    };

String puzzleExplanation(S strings, PuzzleMotif motif) => switch (motif) {
      PuzzleMotif.queenNet => strings.Puzzle_Explain_Queen_Net,
      PuzzleMotif.backRank => strings.Puzzle_Explain_Back_Rank,
      PuzzleMotif.knightMate => strings.Puzzle_Explain_Knight_Mate,
      PuzzleMotif.rookMate => strings.Puzzle_Explain_Rook_Mate,
      PuzzleMotif.bishopMate => strings.Puzzle_Explain_Bishop_Mate,
      PuzzleMotif.fork => strings.Puzzle_Explain_Fork,
      PuzzleMotif.promotion => strings.Puzzle_Explain_Promotion,
      PuzzleMotif.combination => strings.Puzzle_Explain_Combination,
    };

/// Explains an authored example using a fresh board, never the live session.
///
/// Puzzle sessions can accept alternative winning moves, so the displayed line
/// is explicitly an example. Every statement below is checked against that line;
/// malformed or illegal content falls back to the existing motif explanation.
String puzzlePositionExplanation(
  S strings, {
  required String fen,
  required List<String> solutionLine,
  required PuzzleMotif motif,
}) {
  final fallback = puzzleExplanation(strings, motif);
  if (solutionLine.isEmpty) return fallback;
  try {
    return _positionExplanation(strings, fen, solutionLine, motif) ?? fallback;
  } on FormatException {
    return fallback;
  } on RangeError {
    return fallback;
  } on StateError {
    return fallback;
  }
}

String? _positionExplanation(
  S strings,
  String fen,
  List<String> solutionLine,
  PuzzleMotif motif,
) {
  final position = chessPositionFromFen(fen);
  final board = position.board;
  if (board.player1King == null || board.player2King == null) return null;
  var player = position.activePlayer;
  final notation = <String>[];
  final details = <String>[];
  for (var index = 0; index < solutionLine.length; index++) {
    final move = moveFromUci(solutionLine[index]);
    final piece = board.tiles[move.from];
    if (piece == null ||
        piece.player != player ||
        !movesForPiece(piece, board).contains(move.to)) {
      return null;
    }
    // An unpromoted pawn on its last rank is invalid content, even if the UCI
    // parser accepts a four-character move. Do not ask the engine to play it.
    final promotes = piece.type == ChessPieceType.pawn &&
        (move.to ~/ 8 == 0 || move.to ~/ 8 == 7);
    if (promotes && move.promotionType == ChessPieceType.promotion) return null;
    if (!promotes && move.promotionType != ChessPieceType.promotion) {
      return null;
    }
    final originalType = piece.type;
    final meta =
        push(move, board, getMeta: true, promotionType: move.promotionType);
    final defender = oppositePlayer(player);
    meta.isCheck = kingInCheck(defender, board);
    meta.isCheckmate = meta.isCheck && hasNoLegalMoves(defender, board);
    notation.add(moveMetaToSan(meta));
    if (index == 0) {
      details.add(strings.Puzzle_Position_Move(
        chessPieceLabel(strings, originalType, player),
        _coordinate(move.from),
        _coordinate(piece.tile),
      ));
      if (promotes) {
        details.add(strings.Puzzle_Position_Promotion(
          _coordinate(move.to),
          chessPieceLabel(strings, piece.type, player),
        ));
      }
      if (motif == PuzzleMotif.fork && piece.type == ChessPieceType.knight) {
        final king = kingForPlayer(defender, board)!;
        final targets = piecesForPlayer(defender, board)
            .where((target) =>
                target.type != ChessPieceType.king &&
                target.type != ChessPieceType.pawn &&
                _attacksSquare(piece, target.tile, board))
            .toList()
          ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));
        if (_attacksSquare(piece, king.tile, board) && targets.isNotEmpty) {
          final target = targets.first;
          details.add(strings.Puzzle_Position_Fork(
            _coordinate(piece.tile),
            _coordinate(king.tile),
            strings.Piece_On_Square(
              chessPieceLabel(strings, target.type, target.player),
              _coordinate(target.tile),
            ),
          ));
        }
      }
    }
    if (index == solutionLine.length - 1 && meta.isCheckmate) {
      final king = kingForPlayer(defender, board)!;
      details.add(strings.Puzzle_Position_Mate(_coordinate(king.tile)));
      final supporters = piecesForPlayer(player, board).where((support) =>
          support != piece && _attacksSquare(support, piece.tile, board));
      if (supporters.isNotEmpty) {
        final support = supporters.first;
        details.add(strings.Puzzle_Position_Support(
          chessPieceLabel(strings, support.type, support.player),
          _coordinate(support.tile),
          _coordinate(piece.tile),
        ));
      } else {
        // A distant supporting piece often controls an empty square beside the
        // king rather than defending the mating piece itself.
        final escape = _coveredEscape(board, player, king.tile, piece);
        if (escape != null) {
          details.add(strings.Puzzle_Position_Escape(
            chessPieceLabel(strings, escape.$1.type, escape.$1.player),
            _coordinate(escape.$1.tile),
            _coordinate(escape.$2),
          ));
        }
      }
      if (motif == PuzzleMotif.backRank) {
        final pawns = piecesForPlayer(defender, board)
            .where((pawn) =>
                pawn.type == ChessPieceType.pawn &&
                (pawn.tile ~/ 8 - king.tile ~/ 8).abs() <= 1 &&
                (pawn.tile % 8 - king.tile % 8).abs() <= 1)
            .map((pawn) => _coordinate(pawn.tile))
            .toList()
          ..sort();
        if (pawns.isNotEmpty) {
          details.add(strings.Puzzle_Position_Pawns(pawns.join(', ')));
        }
      }
      if (notation.length == 3) {
        details.add(strings.Puzzle_Position_Reply(
            _notation(notation[1]), _notation(notation[2])));
      }
    }
    if (meta.isCheckmate && index != solutionLine.length - 1) return null;
    player = defender;
  }
  return [
    strings.Puzzle_Position_Line(_notation(notation.join(' '))),
    ...details
  ].join('\n\n');
}

// Isolate Latin chess coordinates and notation from surrounding RTL prose.
String _coordinate(int tile) => _notation(squareName(tile));

String _notation(String value) => '\u2066$value\u2069';

(ChessPiece, int)? _coveredEscape(
    ChessBoard board, Player player, int kingTile, ChessPiece matingPiece) {
  for (var row = kingTile ~/ 8 - 1; row <= kingTile ~/ 8 + 1; row++) {
    for (var col = kingTile % 8 - 1; col <= kingTile % 8 + 1; col++) {
      if (row < 0 || row > 7 || col < 0 || col > 7) continue;
      final square = row * 8 + col;
      if (board.tiles[square] != null) continue;
      for (final support in piecesForPlayer(player, board)) {
        if (support != matingPiece && _attacksSquare(support, square, board)) {
          return (support, square);
        }
      }
    }
  }
  return null;
}

/// Geometric attacks include occupied friendly squares and pawn diagonals.
/// Legal move destinations alone cannot identify defended pieces reliably.
bool _attacksSquare(ChessPiece piece, int target, ChessBoard board) {
  final dr = target ~/ 8 - piece.tile ~/ 8;
  final dc = target % 8 - piece.tile % 8;
  if (dr == 0 && dc == 0) return false;
  switch (piece.type) {
    case ChessPieceType.pawn:
      return dr == (piece.player == Player.player1 ? -1 : 1) && dc.abs() == 1;
    case ChessPieceType.knight:
      return (dr.abs() == 1 && dc.abs() == 2) ||
          (dr.abs() == 2 && dc.abs() == 1);
    case ChessPieceType.king:
      return dr.abs() <= 1 && dc.abs() <= 1;
    case ChessPieceType.bishop:
      if (dr.abs() != dc.abs()) return false;
      break;
    case ChessPieceType.rook:
      if (dr != 0 && dc != 0) return false;
      break;
    case ChessPieceType.queen:
      if (dr != 0 && dc != 0 && dr.abs() != dc.abs()) return false;
      break;
    case ChessPieceType.promotion:
      return false;
  }
  final step = dr.sign * 8 + dc.sign;
  for (var tile = piece.tile + step; tile != target; tile += step) {
    if (board.tiles[tile] != null) return false;
  }
  return true;
}
