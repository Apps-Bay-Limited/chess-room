import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';

class GameStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Row(
        children: [
          TextRegular(_getStatus(appModel, context)),
          !appModel.gameOver && appModel.playerCount == 1 && appModel.isAIsTurn
              ? CupertinoActivityIndicator(radius: 12)
              : Container()
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  String _getStatus(AppModel appModel, BuildContext context) {
    if (!appModel.gameOver) {
      if (appModel.playerCount == 1) {
        if (appModel.isAIsTurn) {
          return S.of(context).AI_is_thinking;
        } else {
          return S.of(context).Your_Turn;
        }
      } else {
        if (appModel.turn == Player.player1) {
          return 'White\'s turn';
        } else {
          return 'Black\'s turn';
        }
      }
    } else {
      if (appModel.stalemate) {
        return 'Stalemate';
      } else {
        if (appModel.playerCount == 1) {
          if (appModel.isAIsTurn) {
            return S.of(context).You_Win + "!";
          } else {
            return S.of(context).You_Lose + ' :(';
          }
        } else {
          if (appModel.turn == Player.player1) {
            return 'Black wins!';
          } else {
            return 'White wins!';
          }
        }
      }
    }
  }
}
