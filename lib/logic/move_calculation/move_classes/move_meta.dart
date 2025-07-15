import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';

import '../../chess_piece.dart';
import 'move.dart';

class MoveMeta {
  Move move;
  Player player;
  ChessPieceType type;
  bool took = false;
  bool isCheck = false;
  bool isCheckmate = false;
  bool isStalemate = false;
  bool promotion = false;
  late ChessPieceType promotionType;
  bool queenCastle = false;
  bool kingCastle = false;
  bool rowIsAmbiguous = false;
  bool colIsAmbiguous = false;

  MoveMeta(this.move, this.player, this.type);
}
