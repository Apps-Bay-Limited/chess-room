import 'dart:convert';

import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/main.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/in_progress_game.dart';
import 'package:chess_room/util/ads_manager.dart';
import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:chess_room/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/rounded_icon_button.dart';
import 'package:chess_room/views/components/chess_view/promotion_dialog.dart';
import 'package:chess_room/views/components/chess_view/promotion_option.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'release_smoke_test.dart' show SmokeAppModel;

const _promotionStorageKey = 'release_smoke_promotion_v1';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('native pending promotion restores and supports undo and redo',
      (tester) async {
    final originalAdsDisabled = AdsManager.disableAllAdsForScreenshot;
    AdsManager.disableAllAdsForScreenshot = true;
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    for (var attempt = 0;
        attempt < 20 &&
            tester.view.physicalSize.width > tester.view.physicalSize.height;
        attempt++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(tester.view.physicalSize.width,
        lessThan(tester.view.physicalSize.height));

    final preferences = await SharedPreferences.getInstance();
    final originalReview = preferences.get(InAppReviewHelper.storageKey);
    final originalProbe = preferences.getString(_promotionStorageKey);
    final store = _NativePromotionStore(preferences);
    AppModel? model;
    try {
      // Seed only the probe's isolated key before AppModel begins loading.
      final fixture = _pendingPromotion();
      expect(fixture.restore().promotionPending, isTrue);
      await store.save(fixture);
      final appModel = SmokeAppModel(store);
      model = appModel;
      await appModel.initialization;
      await appModel.purchaseInitialization;
      appModel.pieceTheme = 'Classic';
      appModel.themeName = 'AppsBay';
      appModel.soundEnabled = true;
      appModel.allowUndoRedo = true;
      await Flame.images.loadAll([
        for (final color in ['white', 'black'])
          for (final piece in [
            'pawn',
            'rook',
            'knight',
            'bishop',
            'king',
            'queen'
          ])
            'pieces/classic/${piece}_$color.png',
      ]);
      await tester.pumpWidget(ChangeNotifierProvider<AppModel>.value(
        value: appModel,
        child: const App(initializeServices: false),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(appModel.hasResumableGame, isTrue);

      await _tapVisible(
          tester, find.byKey(const ValueKey('continue-game-button')));
      for (var attempt = 0;
          attempt < 20 && find.byType(PromotionDialog).evaluate().isEmpty;
          attempt++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(PromotionDialog), findsOneWidget);
      expect(appModel.game!.board.tiles[0]!.type, ChessPieceType.promotion);
      expect(appModel.game!.board.moveStack.length, 9);
      expect(appModel.turn, Player.player1);
      expect(appModel.player2TimeLeft.inMilliseconds, fixture.blackTimeMs);

      // A platform Back request must not leave the engine's unfinished pawn
      // move on the board without a choice of promotion piece.
      await tester.binding.handlePopRoute();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(PromotionDialog), findsOneWidget);
      expect(appModel.game!.board.tiles[0]!.type, ChessPieceType.promotion);

      final queenOption = find.byWidgetPredicate((widget) =>
          widget is PromotionOption &&
          widget.promotionType == ChessPieceType.queen);
      expect(queenOption, findsOneWidget);
      await _tapVisible(
          tester,
          find.descendant(
            of: queenOption,
            matching: find.byType(CupertinoButton),
          ));
      expect(find.byType(PromotionDialog), findsNothing);
      expect(appModel.game!.board.tiles[0]!.type, ChessPieceType.queen);
      expect(appModel.game!.board.tiles[0]!.player, Player.player1);
      expect(appModel.turn, Player.player2);
      expect(appModel.game!.board.moveStack.length, 9);
      expect(appModel.moveMetaList.last.promotionType, ChessPieceType.queen);
      await appModel.saveInProgressGame();
      final promoted = (await store.load())!;
      expect(promoted.moves.last.promotionType, ChessPieceType.queen);
      expect(promoted.restore().promotionPending, isFalse);

      await _tapVisible(
          tester,
          find.widgetWithIcon(
              RoundedIconButton, CupertinoIcons.arrow_counterclockwise));
      expect(appModel.game!.board.moveStack.length, 8);
      expect(appModel.game!.board.tiles[9]!.type, ChessPieceType.pawn);
      expect(appModel.game!.board.tiles[0]!.type, ChessPieceType.rook);
      expect(appModel.game!.board.tiles[0]!.player, Player.player2);
      expect(appModel.turn, Player.player1);

      await _tapVisible(
          tester,
          find.widgetWithIcon(
              RoundedIconButton, CupertinoIcons.arrow_clockwise));
      expect(appModel.game!.board.moveStack.length, 9);
      expect(appModel.game!.board.tiles[0]!.type, ChessPieceType.queen);
      expect(appModel.game!.board.tiles[0]!.player, Player.player1);
      expect(appModel.turn, Player.player2);
      expect(find.byType(PromotionDialog), findsNothing);
      await appModel.saveInProgressGame();
      expect(
          (await store.load())!.moves.last.promotionType, ChessPieceType.queen);
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox());
      if (model != null) {
        await model.saveInProgressGame();
        model.dispose();
      }
      // Drain any asynchronous completion accounting before restoring the
      // owner's original review eligibility, including malformed old values.
      await InAppReviewHelper.shared.initialize();
      await _restorePreference(
          preferences, InAppReviewHelper.storageKey, originalReview);
      if (originalProbe == null) {
        await preferences.remove(_promotionStorageKey);
      } else {
        await preferences.setString(_promotionStorageKey, originalProbe);
      }
      AdsManager.disableAllAdsForScreenshot = originalAdsDisabled;
    }
  });
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  expect(finder, findsOneWidget);
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 250));
  await tester.tap(finder);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

InProgressGame _pendingPromotion() {
  final board = ChessBoard();
  for (final uci in [
    'a2a4',
    'h7h5',
    'a4a5',
    'h5h4',
    'a5a6',
    'h4h3',
    'a6b7',
    'h3g2',
    'b7a8',
  ]) {
    // The final pawn remains the engine's pending-promotion type.
    push(moveFromUci(uci), board);
  }
  return InProgressGame(
    sessionId: 'native-promotion-fixture',
    playerCount: 2,
    aiDifficulty: 1,
    selectedSide: Player.player1,
    playerSide: Player.player1,
    timeLimit: 5,
    turn: Player.player1,
    whiteTimeMs: 123000,
    blackTimeMs: 234000,
    moves: board.moveStack.map(InProgressGame.copyStackMove).toList(),
    redoMoves: const [],
    reviews: const [],
  );
}

Future<void> _restorePreference(
    SharedPreferences preferences, String key, Object? value) async {
  if (value == null) {
    await preferences.remove(key);
  } else if (value is String) {
    await preferences.setString(key, value);
  } else if (value is int) {
    await preferences.setInt(key, value);
  } else if (value is bool) {
    await preferences.setBool(key, value);
  } else if (value is double) {
    await preferences.setDouble(key, value);
  } else if (value is List<String>) {
    await preferences.setStringList(key, value);
  }
}

class _NativePromotionStore implements InProgressGameStore {
  final SharedPreferences preferences;

  _NativePromotionStore(this.preferences);

  @override
  Future<InProgressGame?> load() async {
    final encoded = preferences.getString(_promotionStorageKey);
    return encoded == null
        ? null
        : InProgressGame.fromJson(
            Map<String, Object?>.from(jsonDecode(encoded) as Map),
          );
  }

  @override
  Future<void> save(InProgressGame game) async {
    await preferences.setString(
        _promotionStorageKey, jsonEncode(game.toJson()));
  }

  @override
  Future<void> clear() async {
    await preferences.remove(_promotionStorageKey);
  }
}
