import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../../../util/app_design.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      label: label,
      button: true,
      enabled: enabled,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
        onPressed: enabled
            ? () {
                HapticFeedback.lightImpact();
                onPressed!();
              }
            : null,
        child: Container(
          height: kMinTouchTarget,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            border: Border.all(color: AppColors.divider, width: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(
            icon,
            color: enabled ? AppColors.textPrimary : AppColors.disabled,
            size: 22,
          ),
        ),
      ),
    );
  }
}
