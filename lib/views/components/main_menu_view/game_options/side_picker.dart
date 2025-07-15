import 'package:flutter/cupertino.dart';

import '../../../../generated/l10n.dart';
import 'picker.dart';

enum Player { player1, player2, random }

class SidePicker extends StatelessWidget {
  final Player selectedSide;
  final ValueChanged<Player?> setFunc;

  const SidePicker(this.selectedSide, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<Player>(
      label: S.of(context).Pick_Your_Side,
      options: {
        Player.player1: Text(S.of(context).White),
        Player.player2: Text(S.of(context).Black),
      },
      selection: selectedSide,
      setFunc: setFunc,
    );
  }
}
