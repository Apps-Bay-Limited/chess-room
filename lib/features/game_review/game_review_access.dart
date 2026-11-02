import 'package:chess_room/features/game_review/game_review_page.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/util/premium.dart';
import 'package:chess_room/views/components/premium/premium_paywall.dart';
import 'package:chess_room/views/components/premium/premium_scope.dart';
import 'package:flutter/cupertino.dart';

/// Opens the review screen after spending one of the day's free reviews, or
/// offers the upgrade when the free tier is out. Both the end-of-match button
/// and Game History go through here so one rule governs the limit.
Future<void> openGameReview(
  BuildContext context, {
  required List<MoveReviewRecord> records,
  required String pieceTheme,
}) async {
  if (records.isEmpty) return;

  final granted = await claimPremiumAllowance(
    context,
    PremiumDailyAllowance.gameReviews,
  );
  if (!context.mounted) return;

  if (!granted) {
    await showPremiumPaywall(context, feature: PremiumFeature.gameReview);
    return;
  }

  await Navigator.push(
    context,
    CupertinoPageRoute<void>(
      builder: (_) => GameReviewPage(records: records, pieceTheme: pieceTheme),
    ),
  );
}
