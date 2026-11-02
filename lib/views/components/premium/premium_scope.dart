import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/premium.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Everything is unlocked when no [AppModel] is in scope. Previews and
/// isolated widget tests mount a single screen without one, and a missing
/// entitlement source must not make a feature look locked.
const PremiumAccess unscopedPremiumAccess =
    PremiumAccess(isPremium: true, usage: PremiumUsage());

/// Reads the entitlement and the day's allowances from the nearest [AppModel].
PremiumAccess premiumAccessOf(BuildContext context, {bool listen = true}) {
  final model = listen
      ? Provider.of<AppModel?>(context)
      : Provider.of<AppModel?>(context, listen: false);
  return model?.premiumAccess ?? unscopedPremiumAccess;
}

/// Spends one of the day's free allowances, returning false when the free tier
/// is out and the paywall should be offered instead.
Future<bool> claimPremiumAllowance(
  BuildContext context,
  PremiumDailyAllowance allowance,
) async {
  final model = Provider.of<AppModel?>(context, listen: false);
  if (model == null) return true;
  return switch (allowance) {
    PremiumDailyAllowance.libraryPuzzles => model.consumeLibraryPuzzle(),
    PremiumDailyAllowance.gameReviews => model.consumeGameReview(),
  };
}
