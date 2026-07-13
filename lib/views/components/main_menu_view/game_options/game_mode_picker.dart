import 'package:flutter/cupertino.dart';

import 'picker.dart';

class GameModePicker extends StatelessWidget {
  final int playerCount;
  final ValueChanged<int?> setFunc;

  const GameModePicker(this.playerCount, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'Game Mode',
      options: {
        1: const Text('Vs AI Player'),
        2: const Text('Two Players'),
      },
      selection: playerCount,
      setFunc: setFunc,
    );
  }
}
