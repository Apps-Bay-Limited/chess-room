import 'package:flutter/cupertino.dart';

import '../../../../generated/l10n.dart';
import 'picker.dart';

class AIDifficultyPicker extends StatelessWidget {
  final Map<int, Text> difficultyOptions = {
    1: Text('⭐️'),
    3: Text('⭐️⭐️'),
    5: Text('⭐️⭐️⭐️'),
    6: Text('⭐️⭐️⭐️⭐️')
  };

  final int aiDifficulty;
  final Function setFunc;

  AIDifficultyPicker(this.aiDifficulty, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: S.of(context).AI_Difficulty,
      options: difficultyOptions,
      selection: aiDifficulty,
      setFunc: setFunc,
    );
  }
}
