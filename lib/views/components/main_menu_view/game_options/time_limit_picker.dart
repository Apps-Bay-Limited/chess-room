import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const timeLimitOptions = <int>[0, 1, 2, 3, 5, 10, 15, 20, 30, 45, 60, 90];

class TimeLimitPicker extends StatelessWidget {
  final int selectedTime;
  final ValueChanged<int?> setFunc;

  const TimeLimitPicker({
    super.key,
    required this.selectedTime,
    required this.setFunc,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Container(
      height: 60,
      padding: const EdgeInsets.only(left: 16, right: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(child: TextDefault(strings.Time_Limit)),
          CupertinoButton(
            key: const ValueKey('time-limit-picker-button'),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            onPressed: () => _showPicker(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeLimitLabel(strings, selectedTime),
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: AppColors.accent,
                  size: 17,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final strings = S.of(context);
    final initialIndex = timeLimitOptions.indexOf(selectedTime);
    var pendingTime = initialIndex < 0 ? 0 : selectedTime;
    HapticFeedback.selectionClick();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 340,
          color: const Color(0xff24201C),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(
                  height: 52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        onPressed: () => Navigator.pop(popupContext),
                        child: Text(strings.Cancel),
                      ),
                      Text(
                        strings.Time_Limit,
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      CupertinoButton(
                        key: const ValueKey('time-limit-done-button'),
                        onPressed: () {
                          setFunc(pendingTime);
                          Navigator.pop(popupContext);
                        },
                        child: Text(
                          strings.Done,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    key: const ValueKey('time-limit-wheel'),
                    scrollController: FixedExtentScrollController(
                      initialItem: initialIndex < 0 ? 0 : initialIndex,
                    ),
                    itemExtent: 44,
                    useMagnifier: true,
                    magnification: 1.08,
                    onSelectedItemChanged: (index) {
                      pendingTime = timeLimitOptions[index];
                      HapticFeedback.selectionClick();
                    },
                    children: [
                      for (final minutes in timeLimitOptions)
                        Center(
                          child: Text(
                            timeLimitLabel(strings, minutes),
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String timeLimitLabel(S strings, int minutes) {
  return minutes == 0 ? strings.No_Limit : strings.Minute_Count(minutes);
}
