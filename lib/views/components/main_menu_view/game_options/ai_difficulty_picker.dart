import 'package:flutter/cupertino.dart';

import '../../../../generated/l10n.dart';
import 'picker.dart';

class AIDifficultyPicker extends StatelessWidget {
  final Map<int, Text> difficultyOptions = {
    1: const Text('⭐️'),
    3: const Text('⭐️⭐️'),
    5: const Text('⭐️⭐️⭐️'),
    6: const Text('⭐️⭐️⭐️⭐️')
  };

  final int aiDifficulty;
  final ValueChanged<int?> setFunc;

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
