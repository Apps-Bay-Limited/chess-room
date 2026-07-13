import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/btn.dart';
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
    return Btn(
      onTap: onTap,
      width: 150,
      height: kMinTouchTarget,
      borderRadius: AppRadius.pill,
      color: CupertinoColors.white.withValues(alpha: 0.12),
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
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
