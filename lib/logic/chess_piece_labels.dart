import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';

/// Localized piece names shared by board accessibility and practice explanations.
String chessPieceLabel(S strings, ChessPieceType type, Player player) {
  final white = player == Player.player1;
  return switch (type) {
    ChessPieceType.pawn ||
    ChessPieceType.promotion =>
      white ? strings.Piece_White_Pawn : strings.Piece_Black_Pawn,
    ChessPieceType.rook =>
      white ? strings.Piece_White_Rook : strings.Piece_Black_Rook,
    ChessPieceType.knight =>
      white ? strings.Piece_White_Knight : strings.Piece_Black_Knight,
    ChessPieceType.bishop =>
      white ? strings.Piece_White_Bishop : strings.Piece_Black_Bishop,
    ChessPieceType.queen =>
      white ? strings.Piece_White_Queen : strings.Piece_Black_Queen,
    ChessPieceType.king =>
      white ? strings.Piece_White_King : strings.Piece_Black_King,
  };
}
