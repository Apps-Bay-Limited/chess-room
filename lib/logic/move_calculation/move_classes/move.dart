import 'package:chess_room/logic/chess_piece.dart';

class Move {
  int from;
  int to;
  late ChessPieceType promotionType;

  Move(this.from, this.to, {this.promotionType = ChessPieceType.promotion});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Move && other.from == from && other.to == to;
  }

  @override
  int get hashCode => from.hashCode ^ to.hashCode;
}
