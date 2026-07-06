import 'package:chess_room/model/app_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:chess_room/logic/chess_game.dart';

class ChessBoardWidget extends StatelessWidget {
  final AppModel appModel;

  const ChessBoardWidget(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: appModel.theme.name != 'Video Chess'
          ? BoxDecoration(
              border: Border.all(
                color: appModel.theme.border,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Color(0x88000000),
                ),
              ],
            )
          : const BoxDecoration(),
      child: ClipRRect(
        borderRadius:
            appModel.theme.name != 'Video Chess' ? BorderRadius.circular(10) : BorderRadius.zero,
        child: Container(
          child: appModel.game != null 
              ? GameWidget(key: ValueKey(appModel.game), game: appModel.game!)
              : const SizedBox(),
          width: MediaQuery.of(context).size.width - 68,
          height: MediaQuery.of(context).size.width - 68,
        ),
      ),
    );
  }
}
