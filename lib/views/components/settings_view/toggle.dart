import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../util/app_design.dart';

class Toggle extends StatelessWidget {
  final String label;
  final String? description;
  final bool toggle;
  final ValueChanged<bool> setFunc;

  const Toggle({
    super.key,
    required this.label,
    this.description,
    required this.toggle,
    required this.setFunc,
  });

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _changeValue(!toggle),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              CupertinoSwitch(
                value: toggle,
                onChanged: _changeValue,
                activeTrackColor: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeValue(bool value) {
    HapticFeedback.selectionClick();
    setFunc(value);
  }
}
