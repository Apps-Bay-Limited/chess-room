import 'package:flutter/cupertino.dart';

import '../../../../generated/l10n.dart';
import 'picker.dart';

enum Player { player1, player2, random }

class SidePicker extends StatelessWidget {
  final Map<Player, Text> colorOptions = const <Player, Text>{
    Player.player1: Text('White'),
    Player.player2: Text('Black'),
  };

  final Player playerSide;
  final Function setFunc;

  SidePicker(this.playerSide, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<Player>(
      label: S.of(context).Pick_Your_Side,
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}
