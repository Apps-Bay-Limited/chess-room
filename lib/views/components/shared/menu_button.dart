import 'package:flutter/cupertino.dart';

import '../../../util/app_design.dart';

/// The single primary-action button style used across menu/setup screens
/// (main menu, single player setup, settings). Keeping one definition
/// ensures every "Start"/"Settings"/"Back"-style button stays identical.
class MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double width;

  const MenuButton({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 260,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          onPressed: onTap,
          minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
          borderRadius: BorderRadius.circular(AppRadius.md),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          color: AppColors.accent,
          disabledColor: AppColors.accent.withValues(alpha: 0.4),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.onAccent,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
