import 'package:flutter/cupertino.dart';

import '../../shared/text_variable.dart';

class Picker<T extends Object> extends StatelessWidget {
  final String label;
  final Map<T, Text> options;
  final T selection;
  final ValueChanged<T?> setFunc;

  const Picker({
    super.key,
    required this.label,
    required this.options,
    required this.selection,
    required this.setFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextRegular(label),
        const SizedBox(height: 10),
        Container(
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                textStyle: const TextStyle(fontFamily: 'Jura', fontSize: 8),
              ),
            ),
            child: CupertinoSlidingSegmentedControl<T>(
              children: options,
              groupValue: selection,
              onValueChanged: setFunc,
              thumbColor: const Color(0x88FFFFFF),
              backgroundColor: const Color(0x20000000),
            ),
          ),
          width: double.infinity,
        )
      ],
    );
  }
}
