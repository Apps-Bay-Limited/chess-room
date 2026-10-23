import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'game_info_and_controls/moves_undo_redo_row.dart';
import 'game_info_and_controls/timers.dart';

class GameInfoAndControls extends StatelessWidget {
  final AppModel appModel;

  const GameInfoAndControls({super.key, required this.appModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        MovesUndoRedoRow(appModel),
        const SizedBox(height: 10),
        Timers(appModel),
      ],
    );
  }
}
