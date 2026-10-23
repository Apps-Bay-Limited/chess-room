import 'dart:ui' show FontFeature;
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';

class TimerWidget extends StatelessWidget {
  final Duration timeLeft;
  final Color color;
  final String? label;
  final bool isActive;
  final String? activeLabel;

  const TimerWidget(
      {super.key,
      required this.timeLeft,
      required this.color,
      this.label,
      this.isActive = false,
      this.activeLabel});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: [
          if (label != null) label!,
          if (isActive && activeLabel != null) activeLabel!,
          _durationToString(timeLeft)
        ].join(', '),
        excludeSemantics: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
                color: isActive ? AppColors.accent : AppColors.divider),
            borderRadius: BorderRadius.circular(AppRadius.md),
            color: isActive ? AppColors.surfaceRaised : AppColors.surface,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (label != null) ...[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.textSecondary, width: 0.5))),
                const SizedBox(width: 8),
                Flexible(
                    child: Text(label!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary))),
              ]),
              const SizedBox(height: 4),
            ],
            SizedBox(
                width: double.infinity,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(_durationToString(timeLeft),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            color: isActive
                                ? AppColors.accent
                                : AppColors.textPrimary)))),
            if (isActive && activeLabel != null)
              Text(activeLabel!,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.accent)),
          ]),
        ),
      ),
    );
  }

  String _durationToString(Duration duration) {
    if (duration.inHours > 0) {
      String hours = duration.inHours.toString();
      String minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    } else if (duration.inMinutes > 0) {
      String minutes = duration.inMinutes.toString();
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      String seconds = duration.inSeconds.toString();
      return '$seconds';
    }
  }
}
