import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Castling (regression for inverted _canCastle loop condition)', () {
    test('king can castle kingside once the path is clear and unattacked', () {
      final board = ChessBoard();
      // Clear the knight (62) and bishop (61) between the king (60) and
      // kingside rook (63) so the path is open.
      board.tiles[61] = null;
      board.tiles[62] = null;

      final king = board.player1King!;
      final moves = movesForPiece(king, board);

      expect(moves, contains(63), reason: 'king should be able to castle onto the rook\'s tile');
    });

    test('king cannot castle through an occupied square', () {
      final board = ChessBoard();
      // Only clear the knight (62); leave the bishop (61) in place blocking
      // the path.
      board.tiles[62] = null;

      final king = board.player1King!;
      final moves = movesForPiece(king, board);

      expect(moves, isNot(contains(63)),
          reason: 'castling must not be allowed while a piece blocks the path');
    });

    test('king cannot castle through a square under attack', () {
      // Build a fully controlled minimal position so the attacking piece's
      // line of sight can't be blocked by unrelated standard-setup pieces:
      // white king on e1 (60), white rook on h1 (63), black rook on f8 (5)
      // attacking down the f-file through f1 (61), which the king must
      // pass through to castle.
      final board = ChessBoard();
      for (var i = 0; i < 64; i++) {
        board.tiles[i] = null;
      }

      final king = ChessPiece(1, ChessPieceType.king, Player.player1, 60);
      final rook = ChessPiece(2, ChessPieceType.rook, Player.player1, 63);
      final attacker = ChessPiece(3, ChessPieceType.rook, Player.player2, 5);

      board.tiles[king.tile] = king;
      board.tiles[rook.tile] = rook;
      board.tiles[attacker.tile] = attacker;
      board.player1King = king;
      board.player1Pieces = [king, rook];
      board.player1Rooks = [rook];
      board.player2Pieces = [attacker];

      final moves = movesForPiece(king, board);

      expect(moves, isNot(contains(63)),
          reason: 'castling must not be allowed through an attacked square');
    });
  });
}
