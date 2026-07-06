import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../../../util/app_design.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return CupertinoButton(
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
          color: CupertinoColors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(
          icon,
          color: enabled ? CupertinoColors.white : AppColors.disabled,
          size: 22,
        ),
      ),
    );
  }
}
