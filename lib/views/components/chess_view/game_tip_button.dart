import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';

class GameTipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const GameTipButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      borderRadius: BorderRadius.circular(AppRadius.md),
      color: AppColors.surfaceRaised,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            const CupertinoActivityIndicator(color: AppColors.accent)
          else
            const Icon(
              CupertinoIcons.lightbulb_fill,
              size: 19,
              color: AppColors.accent,
            ),
          const SizedBox(width: 8),
          Flexible(
              child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          )),
        ],
      ),
    );
  }
}
