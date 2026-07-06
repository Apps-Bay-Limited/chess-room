import 'package:flutter/cupertino.dart';

import '../../../util/app_design.dart';
import '../../btn.dart';

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
    return Btn(
      onTap: onTap,
      height: 60,
      width: width,
      borderRadius: AppRadius.pill,
      color: AppColors.accent,
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.onAccent,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
