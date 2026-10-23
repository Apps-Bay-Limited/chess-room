import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../shared/text_variable.dart';
import 'package:chess_room/util/app_design.dart';

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (final option in options.entries)
              Semantics(
                selected: option.key == selection,
                child: CupertinoButton(
                  minimumSize: const Size(96, kMinTouchTarget),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: option.key == selection
                      ? AppColors.accent
                      : AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  onPressed: () {
                    if (option.key != selection) {
                      HapticFeedback.selectionClick();
                    }
                    setFunc(option.key);
                  },
                  child: DefaultTextStyle.merge(
                      style: TextStyle(
                          color: option.key == selection
                              ? AppColors.onAccent
                              : AppColors.textPrimary,
                          fontSize: 16),
                      child: option.value),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
