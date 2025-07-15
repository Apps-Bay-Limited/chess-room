import 'package:chess_room/views/components/main_menu_view/game_options/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:chess_room/generated/l10n.dart';

class TimeLimitPicker extends StatelessWidget {
  final int selectedTime;
  final ValueChanged<int?> setFunc;

  const TimeLimitPicker({required this.selectedTime, required this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'Time Limit',
      options: {
        0: const Text('None'),
        1: const Text('1 Minute'),
        3: const Text('3 Minutes'),
        5: const Text('5 Minutes'),
        10: const Text('10 Minutes'),
        15: const Text('15 Minutes'),
        30: const Text('30 Minutes'),
      },
      selection: selectedTime,
      setFunc: setFunc,
    );
  }
}
