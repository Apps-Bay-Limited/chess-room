import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'game_info_and_controls/moves_undo_redo_row.dart';
import 'game_info_and_controls/timers.dart';

class GameInfoAndControls extends StatefulWidget {
  final AppModel appModel;

  const GameInfoAndControls({super.key, required this.appModel});

  @override
  State<GameInfoAndControls> createState() => _GameInfoAndControlsState();
}

class _GameInfoAndControlsState extends State<GameInfoAndControls> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height > 700 ? 204 : 134,
      ),
      child: ListView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 10),
          MovesUndoRedoRow(widget.appModel),
          const SizedBox(height: 10),
          Timers(widget.appModel),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
