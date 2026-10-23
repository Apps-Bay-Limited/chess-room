import 'package:chess_room/model/app_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:chess_room/views/components/shared/board_coordinates.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';

class ChessBoardWidget extends StatelessWidget {
  final AppModel appModel;
  final bool showCoordinates;

  const ChessBoardWidget(this.appModel,
      {super.key, this.showCoordinates = false});

  @override
  Widget build(BuildContext context) {
    // Flame stores its own logical board size at game creation. Scale the whole
    // GameWidget rather than changing that coordinate space on tablets.
    final logicalSize =
        appModel.game?.width ?? MediaQuery.sizeOf(context).width - 68;
    return LayoutBuilder(builder: (context, constraints) {
      final available = constraints.maxWidth.clamp(0.0, 600.0);
      final boardSize = (logicalSize + 2).clamp(0.0, available);
      return BoardCoordinates(
        visible: showCoordinates,
        flipped: appModel.flip &&
            appModel.playingWithAI &&
            appModel.playerSide == Player.player2,
        child: SizedBox(
          width: boardSize,
          height: boardSize,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              decoration: appModel.theme.name != 'Video Chess'
                  ? BoxDecoration(
                      border: Border.all(
                        color: appModel.theme.border.withValues(alpha: 0.5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color(0x44000000),
                        ),
                      ],
                    )
                  : const BoxDecoration(),
              child: ClipRRect(
                borderRadius: appModel.theme.name != 'Video Chess'
                    ? BorderRadius.circular(10)
                    : BorderRadius.zero,
                child: Container(
                  child: appModel.game != null
                      ? GameWidget(
                          key: ValueKey(appModel.game), game: appModel.game!)
                      : const SizedBox(),
                  width: logicalSize,
                  height: logicalSize,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
