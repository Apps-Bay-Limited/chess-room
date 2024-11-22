import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/chess_view/game_info_and_controls/rounded_alert_button.dart';
import 'package:flutter/cupertino.dart';

class RestartExitButtons extends StatelessWidget {
  final AppModel appModel;

  RestartExitButtons(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoundedAlertButton(
            'Restart',
            onConfirm: () {
              appModel.newGame(context);
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: RoundedAlertButton(
            'Exit',
            onConfirm: () {
              appModel.exitChessView();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
