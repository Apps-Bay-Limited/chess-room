import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'game_info_and_controls/moves_undo_redo_row.dart';
import 'game_info_and_controls/timers.dart';

class GameInfoAndControls extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  GameInfoAndControls(this.appModel);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height > 700 ? 204 : 134,
      ),
      child: ListView(
        controller: scrollController,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 10),
          MovesUndoRedoRow(appModel),
          SizedBox(height: 10),
          Timers(appModel),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
