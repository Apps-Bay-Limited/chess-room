import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/logic/shared_functions.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';

class PositionBoard extends StatelessWidget {
  final ChessBoard board;
  final String pieceTheme;
  final bool flipped;
  final int? selectedTile;
  final Set<int> highlightedTiles;
  final Color highlightColor;
  final ValueChanged<int>? onTileTap;

  const PositionBoard({
    super.key,
    required this.board,
    this.pieceTheme = 'Classic',
    this.flipped = false,
    this.selectedTile,
    this.highlightedTiles = const {},
    this.highlightColor = const Color(0x9994C973),
    this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: 64,
          itemBuilder: (context, visualIndex) {
            final tile = flipped ? 63 - visualIndex : visualIndex;
            final row = tile ~/ 8;
            final col = tile % 8;
            final piece = board.tiles[tile];
            final isSelected = selectedTile == tile;
            final isHighlighted = highlightedTiles.contains(tile);
            final baseColor = (row + col).isEven
                ? const Color(0xffe7d4ad)
                : const Color(0xff8b6a42);

            return GestureDetector(
              key: ValueKey('position-tile-$tile'),
              behavior: HitTestBehavior.opaque,
              onTap: onTileTap == null ? null : () => onTileTap!(tile),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xfff1c75b)
                      : isHighlighted
                          ? Color.alphaBlend(highlightColor, baseColor)
                          : baseColor,
                ),
                child: piece == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.all(3),
                        child: Image.asset(
                          'assets/images/pieces/${formatPieceTheme(pieceTheme)}/'
                          '${pieceTypeToString(piece.type)}_'
                          '${piece.player == Player.player1 ? 'white' : 'black'}.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              _fallbackPiece(
                                piece.type,
                                piece.player == Player.player1,
                              ),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String _fallbackPiece(ChessPieceType type, bool white) {
  const whitePieces = ['♙', '♖', '♘', '♗', '♔', '♕', '♙'];
  const blackPieces = ['♟', '♜', '♞', '♝', '♚', '♛', '♟'];
  return (white ? whitePieces : blackPieces)[type.index];
}
