import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/undo_redo_buttons.dart';
import 'package:flutter/cupertino.dart';

class MovesUndoRedoRow extends StatelessWidget {
  final AppModel appModel;

  MovesUndoRedoRow(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // appModel.showMoveHistory ? Expanded(child: MoveList(appModel)) : Container(),
            Expanded(child: UndoRedoButtons(appModel))
            // appModel.allowUndoRedo ? Expanded(child: UndoRedoButtons(appModel)) : Container(),
          ],
        ),
      ],
    );
  }
}
