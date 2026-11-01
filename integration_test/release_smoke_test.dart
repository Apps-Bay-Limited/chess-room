import 'dart:convert';
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:chess_room/features/daily_puzzle/daily_puzzle.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_page.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_game.dart';
import 'package:chess_room/main.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/in_progress_game.dart';
import 'package:chess_room/util/ads_manager.dart';
import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:chess_room/util/premium_purchase_service.dart';
import 'package:chess_room/views/chess_view.dart';
import 'package:chess_room/views/components/chess_view/chess_board_widget.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/main_menu_view/home_play_actions.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Native preferences use an isolated key. Never clear the user's saved match.
const smokeStorageKey = 'release_smoke_match_v1';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const phase = String.fromEnvironment('SMOKE_PHASE', defaultValue: 'save');
  const capture = bool.fromEnvironment('CAPTURE_STORE');
  testWidgets('native release smoke: $phase', (tester) async {
    final originalAdsDisabled = AdsManager.disableAllAdsForScreenshot;
    AdsManager.disableAllAdsForScreenshot = true;
    // This harness builds App directly, so repeat main()'s native orientation
    // setup before measuring or tapping the board.
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
        lessThan(tester.view.physicalSize.height),
        reason: 'The native smoke flow uses the app’s portrait layout.');
    final prefs = await SharedPreferences.getInstance();
    final originalOptions = {
      InAppReviewHelper.storageKey: prefs.get(InAppReviewHelper.storageKey),
    };
    final store = SmokeGameStore(prefs);
    final model = SmokeAppModel(store);
    try {
      await model.initialization;
      model.soundEnabled = true;
      model.pieceTheme = 'Classic';
      model.themeName = 'AppsBay';
      await model.purchaseInitialization;
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
      if (phase == 'save') {
        await store.clear();
        await model.discardInProgressGame();
      } else {
        expect(model.hasResumableGame, isTrue,
            reason: 'Run save phase on this same device before restore phase.');
      }
      await tester.pumpWidget(ChangeNotifierProvider<AppModel>.value(
        value: model,
        child: const App(initializeServices: false),
      ));
      await tester.pump(const Duration(seconds: 1));
      if (capture && Platform.isAndroid) {
        await binding.convertFlutterSurfaceToImage();
        await tester.pump();
      }
      if (capture) {
        for (var attempt = 0;
            attempt < 50 &&
                tester
                    .widget<HomePlayActions>(find.byType(HomePlayActions))
                    .isLoading;
            attempt++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(
            tester
                .widget<HomePlayActions>(find.byType(HomePlayActions))
                .isLoading,
            isFalse,
            reason: 'Store captures must show ready Home actions.');
        await tester.pump(const Duration(milliseconds: 300));
        await _captureStore(binding, '01-quick-play');
      }
      if (phase == 'save') {
        await tester.tap(find.byKey(const ValueKey('quick-play-button')));
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(ChessView), findsOneWidget);
        await _tapSquare(tester, 52); // e2
        expect(model.game!.selectedPiece?.tile, 52,
            reason: 'The native board must receive the e2 selection tap.');
        expect(model.game!.validMoves, contains(36));
        await _tapSquare(tester, 36); // e4
        expect(model.game!.board.moveStack, isNotEmpty,
            reason: 'The native board must receive the e4 move tap.');
        for (var attempt = 0;
            attempt < 100 && model.moveMetaList.length < 2;
            attempt++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(model.moveMetaList.length, greaterThanOrEqualTo(2));
        final restart = find.byKey(const ValueKey('restart-game-button'));
        await tester.ensureVisible(restart);
        await tester.pump(const Duration(milliseconds: 250));
        await tester.tap(restart);
        await tester.pump(const Duration(milliseconds: 300));
        final beforeCancel = chessPositionToFen(model.game!.board, model.turn);
        await tester.tap(find.byKey(const ValueKey('cancel-restart-button')));
        await tester.pump(const Duration(milliseconds: 300));
        expect(chessPositionToFen(model.game!.board, model.turn), beforeCancel);
        expect(model.isGamePaused, isFalse);
        await model.pauseGame();
        final time = model.player1TimeLeft;
        binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump(const Duration(seconds: 1));
        expect(model.player1TimeLeft, time);
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pump(const Duration(milliseconds: 100));
        await model.pauseGame();
        await model.saveInProgressGame();
        expect((await store.load())!.moves.length, greaterThanOrEqualTo(2));
        if (capture) {
          await _showGameControls(tester);
          await _captureStore(binding, '02-play-offline');
        }
      } else {
        final saved = await store.load();
        final expected = saved!.restore();
        await tester.tap(find.byKey(const ValueKey('continue-game-button')));
        await tester.pump(const Duration(seconds: 1));
        expect(model.game!.board.moveCount, saved.moves.length);
        expect(model.turn, saved.turn);
        expect(chessPositionToFen(model.game!.board, model.turn),
            chessPositionToFen(expected.board, saved.turn));
        expect(find.byType(ChessView), findsOneWidget);
        await model.pauseGame();
        expect(model.player1TimeLeft.inMilliseconds,
            inInclusiveRange(saved.whiteTimeMs - 3000, saved.whiteTimeMs));
        expect(model.player2TimeLeft.inMilliseconds,
            inInclusiveRange(saved.blackTimeMs - 3000, saved.blackTimeMs));
        if (capture) {
          await _showGameControls(tester);
          await _captureStore(binding, '03-continue-game');
        }
      }
      await tester.pumpWidget(const SizedBox());
      await model.saveInProgressGame();
      final daily = SmokePuzzleStore(prefs);
      await prefs.remove('release_smoke_daily');
      await tester.pumpWidget(CupertinoApp(
        localizationsDelegates: const [],
        home: const SizedBox(),
      ));
      // The app's localization is reused by opening this page from App.
      await tester.pumpWidget(ChangeNotifierProvider<AppModel>.value(
        value: model,
        child: const App(initializeServices: false),
      ));
      await tester.pump(const Duration(milliseconds: 600));
      final context = tester.element(find.byType(App));
      // Use the navigator under App, not its outer provider context.
      final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
      nav.push(CupertinoPageRoute(
          builder: (_) => DailyPuzzlePage(
                puzzle: dailyPuzzles.first,
                today: DateTime(2026, 10, 16),
                progressStore: daily,
              )));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      for (var attempt = 0;
          attempt < 10 && find.byType(PositionBoard).evaluate().isEmpty;
          attempt++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(context.mounted, isTrue);
      expect(find.byType(DailyPuzzlePage), findsOneWidget);
      expect(find.byType(PositionBoard), findsOneWidget);
      await tester.ensureVisible(find.byType(PositionBoard));
      await tester.pump(const Duration(milliseconds: 250));
      if (capture) await _captureStore(binding, '04-daily-practice');
      await _tapPuzzleSquare(tester, 23);
      expect(
          tester.widget<PositionBoard>(find.byType(PositionBoard)).selectedTile,
          23);
      await _tapPuzzleSquare(tester, 14);
      await tester.pump(const Duration(milliseconds: 500));
      expect((await daily.load(DateTime(2026, 10, 16))).solvedToday, isTrue);
      if (capture) {
        final practice = find.byKey(const ValueKey('daily-puzzle-practice'));
        await Scrollable.ensureVisible(tester.element(practice), alignment: 1);
        await tester.pump(const Duration(milliseconds: 300));
        await _captureStore(binding, '05-learn-from-solutions');
      }
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox());
      await model.saveInProgressGame();
      model.dispose();
      // Puzzle completion records review eligibility asynchronously. Drain its
      // serialized queue before restoring the user's original review state.
      await InAppReviewHelper.shared.initialize();
      for (final entry in originalOptions.entries) {
        final value = entry.value;
        if (value == null) {
          await prefs.remove(entry.key);
        } else if (value is int) {
          await prefs.setInt(entry.key, value);
        } else if (value is String) {
          await prefs.setString(entry.key, value);
        } else if (value is bool) {
          await prefs.setBool(entry.key, value);
        } else if (value is double) {
          await prefs.setDouble(entry.key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(entry.key, value);
        }
      }
      AdsManager.disableAllAdsForScreenshot = originalAdsDisabled;
    }
  });
}

Future<void> _showGameControls(WidgetTester tester) async {
  final tip = find.byKey(const ValueKey('game-tip-button'));
  if (tip.evaluate().isNotEmpty) {
    await Scrollable.ensureVisible(tester.element(tip),
        alignment: 1,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd);
  }
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _captureStore(
    IntegrationTestWidgetsFlutterBinding binding, String name) async {
  if (!Platform.isAndroid && !Platform.isIOS) {
    throw UnsupportedError(
        'Native store capture supports Android and iOS only.');
  }
  const channel = MethodChannel('com.appsbay.chess_room/store_capture');
  if (Platform.isAndroid) PlatformDispatcher.instance.scheduleFrame();
  final Object? result;
  try {
    result = await channel.invokeMethod<Object?>('capture');
  } on MissingPluginException {
    throw StateError('Native store capture is unavailable in this build.');
  }
  final List<int> bytes;
  if (result is Uint8List) {
    bytes = result.toList(growable: false);
  } else if (result is List &&
      result.every((byte) => byte is int && byte >= 0 && byte <= 255)) {
    bytes = List<int>.from(result, growable: false);
  } else {
    throw StateError(
        'Native store capture did not return PNG bytes for $name.');
  }
  const pngSignature = [137, 80, 78, 71, 13, 10, 26, 10];
  if (bytes.length < pngSignature.length ||
      !Iterable<int>.generate(pngSignature.length)
          .every((index) => bytes[index] == pngSignature[index])) {
    throw StateError('Native store capture returned an invalid PNG for $name.');
  }
  // Capture is awaited at the live screen state. The host callback only writes
  // these native bytes after the test; it must not take another screenshot.
  binding.reportData ??= <String, dynamic>{};
  binding.reportData!['screenshots'] ??= <dynamic>[];
  (binding.reportData!['screenshots'] as List<dynamic>).add({
    'screenshotName': name,
    'bytes': bytes,
  });
}

Future<void> _tapSquare(WidgetTester tester, int tile) async {
  final game = find.descendant(
    of: find.byType(ChessBoardWidget),
    matching: find.byWidgetPredicate((widget) => widget is GameWidget),
  );
  await tester.ensureVisible(game);
  // A zero-duration scroll still needs a frame before its global coordinates
  // reflect the new offset, and Flame may still be completing its first load.
  await tester.pump(const Duration(milliseconds: 250));
  final chessGame = tester.widget<GameWidget<ChessGame>>(game).game!;
  for (var attempt = 0; attempt < 10 && !chessGame.isAttached; attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(chessGame.isAttached, isTrue,
      reason: 'Flame must finish attaching before native board input.');
  final rect = tester.getRect(game);
  final point = rect.topLeft +
      Offset(
        (tile % 8 + 0.5) * rect.width / 8,
        (tile ~/ 8 + 0.5) * rect.height / 8,
      );
  final viewport =
      Offset.zero & (tester.view.physicalSize / tester.view.devicePixelRatio);
  expect(viewport.contains(point), isTrue,
      reason: 'The board square must be visible in the native viewport.');
  final hits = tester
      .hitTestOnBinding(point)
      .path
      .take(8)
      .map((entry) => entry.target.runtimeType)
      .join(',');
  debugPrint('release-smoke board tap tile=$tile '
      'rect=(${rect.left},${rect.top},${rect.width},${rect.height}) '
      'point=(${point.dx},${point.dy}) '
      'selected=${chessGame.selectedPiece?.tile} '
      'paused=${chessGame.appModel.isGamePaused} hits=$hits');
  await tester.tapAt(point);
  await tester.pump(const Duration(milliseconds: 100));
  debugPrint('release-smoke board result tile=$tile '
      'selected=${chessGame.selectedPiece?.tile} '
      'moves=${chessGame.board.moveCount}');
}

Future<void> _tapPuzzleSquare(WidgetTester tester, int tile) async {
  final board = find.byType(PositionBoard);
  await tester.ensureVisible(board);
  await tester.pump(const Duration(milliseconds: 250));
  final flipped = tester.widget<PositionBoard>(board).flipped;
  final visual = flipped ? 63 - tile : tile;
  final rect = tester.getRect(board);
  final point = rect.topLeft +
      Offset(
        (visual % 8 + 0.5) * rect.width / 8,
        (visual ~/ 8 + 0.5) * rect.height / 8,
      );
  final viewport =
      Offset.zero & (tester.view.physicalSize / tester.view.devicePixelRatio);
  expect(viewport.contains(point), isTrue,
      reason: 'The puzzle square must be visible in the native viewport.');
  debugPrint('release-smoke puzzle tap tile=$tile '
      'rect=(${rect.left},${rect.top},${rect.width},${rect.height}) '
      'point=(${point.dx},${point.dy})');
  await tester.tapAt(point);
  await tester.pump(const Duration(milliseconds: 100));
}

class SmokeGameStore implements InProgressGameStore {
  final SharedPreferences prefs;
  SmokeGameStore(this.prefs);
  @override
  Future<InProgressGame?> load() async {
    final encoded = prefs.getString(smokeStorageKey);
    return encoded == null
        ? null
        : InProgressGame.fromJson(
            Map<String, Object?>.from(jsonDecode(encoded) as Map),
          );
  }

  @override
  Future<void> save(InProgressGame game) async {
    await prefs.setString(smokeStorageKey, jsonEncode(game.toJson()));
  }

  @override
  Future<void> clear() async {
    await prefs.remove(smokeStorageKey);
  }
}

class SmokeHistoryStore implements GameHistoryStore {
  @override
  Future<List<SavedGame>> loadGames() async => [];
  @override
  Future<void> saveGame(SavedGame game) async {}
  @override
  Future<void> deleteGame(String id) async {}
}

class SmokePuzzleStore implements PuzzleProgressStore {
  final SharedPreferences prefs;
  SmokePuzzleStore(this.prefs);
  @override
  Future<PuzzleProgress> load(DateTime today) async => PuzzleProgress(
        streak: prefs.getBool('release_smoke_daily') == true ? 1 : 0,
        solvedToday: prefs.getBool('release_smoke_daily') == true,
      );
  @override
  Future<PuzzleProgress> markSolved(DateTime today) async {
    await prefs.setBool('release_smoke_daily', true);
    return const PuzzleProgress(streak: 1, solvedToday: true);
  }
}

// Purchases are deliberately excluded from unattended tests: validate actual
// restore/entitlement in StoreKit sandbox with the owner's test account.
class UnavailableSmokeStore implements PremiumStore {
  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();
  @override
  Future<bool> isAvailable() async => false;
  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> ids) async =>
      ProductDetailsResponse(productDetails: [], notFoundIDs: ids.toList());
  @override
  Future<bool> buyNonConsumable(ProductDetails product) async => false;
  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}
  @override
  Future<void> restorePurchases() async {}
}

class SmokeAppModel extends AppModel {
  SmokeAppModel(InProgressGameStore store)
      : super(
          inProgressGameStore: store,
          gameHistoryStore: SmokeHistoryStore(),
          purchaseService:
              PremiumPurchaseService(store: UnavailableSmokeStore()),
        );

  @override
  Future<void> prepareQuickPlay() async {
    await initialization;
    playerCount = 1;
    aiDifficulty = 1;
    selectedSide = Player.player1;
    playerSide = Player.player1;
    timeLimit = 5;
  }
}
