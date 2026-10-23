import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/chess_view/game_info_and_controls/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';

class Timers extends StatelessWidget {
  final AppModel appModel;

  Timers(this.appModel);

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    String label(Player side) {
      final sideName =
          side == Player.player1 ? strings.Clock_White : strings.Clock_Black;
      if (!appModel.playingWithAI || appModel.playerSide == side) {
        return sideName;
      }
      final difficulty = switch (appModel.aiDifficulty) {
        1 => strings.Easy,
        5 => strings.Hard,
        6 => strings.Extreme,
        _ => strings.Medium,
      };
      return '$sideName · ${strings.AI_Difficulty}: $difficulty';
    }

    return appModel.timeLimit != 0
        ? Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TimerWidget(
                      timeLeft: appModel.player1TimeLeft,
                      color: Colors.white,
                      label: label(Player.player1),
                      isActive:
                          !appModel.gameOver && appModel.turn == Player.player1,
                      activeLabel: strings.Clock_Active,
                    ),
                    SizedBox(width: 10),
                    TimerWidget(
                      timeLeft: appModel.player2TimeLeft,
                      color: Colors.black,
                      label: label(Player.player2),
                      isActive:
                          !appModel.gameOver && appModel.turn == Player.player2,
                      activeLabel: strings.Clock_Active,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
            ],
          )
        : Container();
  }
}
