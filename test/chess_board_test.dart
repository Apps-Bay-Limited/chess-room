import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pushMSO (regression for redo crashing on non-promotion moves)', () {
    test('redoing a standard move does not throw', () {
      final board = ChessBoard();

      // A plain pawn push: e2-e3 equivalent (tile 52 -> 44), no promotion.
      push(Move(52, 44), board);
      final mso = pop(board);

      expect(() => pushMSO(mso, board), returnsNormally);
      expect(board.tiles[44], isNotNull);
      expect(board.tiles[52], isNull);
    });

    test('redoing a promotion move still promotes to the right piece', () {
      // Fully controlled minimal position: a lone white pawn one step from
      // promoting, nothing else on the board.
      final board = ChessBoard();
      for (var i = 0; i < 64; i++) {
        board.tiles[i] = null;
      }
      final pawn = ChessPiece(1, ChessPieceType.pawn, Player.player1, 9);
      board.tiles[9] = pawn;
      board.player1Pieces = [pawn];

      push(Move(9, 1), board, promotionType: ChessPieceType.queen);
      final mso = pop(board);

      expect(() => pushMSO(mso, board), returnsNormally);
      expect(board.tiles[1]?.type, ChessPieceType.queen);
    });
  });
}
