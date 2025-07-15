import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'game_options/ai_difficulty_picker.dart';
import 'game_options/side_picker.dart';
import 'game_options/time_limit_picker.dart';

class GameOptions extends StatelessWidget {
  final AppModel appModel;

  const GameOptions({super.key, required this.appModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      // padding: EdgeInsets.zero,
      // physics: ClampingScrollPhysics(),
      children: [
        // GameModePicker(
        //   appModel.playerCount,
        //   appModel.setPlayerCount,
        // ),
        const SizedBox(height: 20),
        appModel.playerCount == 1
            ? Column(
                children: [
                  AIDifficultyPicker(
                    appModel.aiDifficulty,
                    (value) => appModel.setAIDifficulty(value ?? 1),
                  ),
                  const SizedBox(height: 40),
                  SidePicker(
                    appModel.selectedSide,
                    (value) => appModel.setPlayerSide(value ?? Player.player1),
                  ),
                  const SizedBox(height: 40),
                ],
              )
            : Container(),
        TimeLimitPicker(
          selectedTime: appModel.timeLimit,
          setFunc: (value) => appModel.setTimeLimit(value ?? 0),
        ),
      ],
    );
  }
}
