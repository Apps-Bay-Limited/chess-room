import 'dart:async';

import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/in_progress_game.dart';
import 'package:chess_room/views/chess_view.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (_) async => null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global/events'),
      (_) async => null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (call) async {
        if (call.method == 'create') {
          final id = (call.arguments as Map)['playerId'];
          messenger.setMockMethodCallHandler(
            MethodChannel('xyz.luan/audioplayers/events/$id'),
            (_) async => null,
          );
        }
        return null;
      },
    );
  });

  testWidgets('Cancel keeps the match, clocks and unfinished save intact',
      (tester) async {
    final fixture = await _mountGame(tester);
    final originalGame = fixture.model.game;
    final originalSave = fixture.store.saved!.toJson();
    final originalPosition = _position(originalGame!.board);
    final whiteTime = fixture.model.player1TimeLeft;
    final blackTime = fixture.model.player2TimeLeft;
    await _openConfirmation(tester);

    expect(fixture.model.isGamePaused, isTrue);
    expect(fixture.model.timer?.isActive ?? false, isFalse);
    fixture.now = fixture.now.add(const Duration(minutes: 2));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(seconds: 2));
    expect(fixture.model.isGamePaused, isTrue);
    expect(fixture.model.player1TimeLeft, whiteTime);
    expect(fixture.model.player2TimeLeft, blackTime);

    await tester.tap(find.byKey(const ValueKey('cancel-restart-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await fixture.model.saveInProgressGame();

    expect(fixture.model.game, same(originalGame));
    expect(_position(originalGame.board), originalPosition);
    expect(fixture.model.newGameCalls, 0);
    expect(fixture.model.isGamePaused, isFalse);
    expect(fixture.model.timer?.isActive ?? false, isTrue);
    expect(fixture.model.player1TimeLeft, whiteTime);
    expect(fixture.model.player2TimeLeft, blackTime);
    expect(fixture.store.saved!.toJson(), originalSave);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('repeated restart taps show one dialog and confirm restarts once',
      (tester) async {
    final fixture = await _mountGame(tester);
    final originalGame = fixture.model.game;
    final restart = tester.widget<CupertinoButton>(find.descendant(
      of: find.byKey(const ValueKey('restart-game-button')),
      matching: find.byType(CupertinoButton),
    ));
    restart.onPressed!();
    restart.onPressed!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    expect(fixture.model.newGameCalls, 0);

    final confirm = tester.widget<CupertinoDialogAction>(
      find.byKey(const ValueKey('confirm-restart-button')),
    );
    confirm.onPressed!();
    confirm.onPressed!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await fixture.model.saveInProgressGame();

    expect(fixture.model.newGameCalls, 1);
    expect(fixture.model.game, isNot(same(originalGame)));
    expect(fixture.model.game!.board.moveStack, isEmpty);
    expect(fixture.model.player1TimeLeft, const Duration(minutes: 5));
    expect(fixture.model.player2TimeLeft, const Duration(minutes: 5));
    expect(fixture.model.isGamePaused, isFalse);
    expect(fixture.store.saved!.moves, isEmpty);
    expect(find.byType(ChessView), findsOneWidget);
    expect(find.byType(CupertinoAlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a stale confirmation cannot restart a replacement match',
      (tester) async {
    final fixture = await _mountGame(tester);
    await _openConfirmation(tester);
    fixture.model.newGame(fixture.context);
    final replacement = fixture.model.game;
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('confirm-restart-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(fixture.model.game, same(replacement));
    expect(fixture.model.newGameCalls, 1);
    expect(fixture.model.isGamePaused, isFalse);
    expect(fixture.model.timer?.isActive ?? false, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('system Back ignores queued restart confirmation',
      (tester) async {
    final fixture = await _mountGame(tester);
    final originalGame = fixture.model.game;
    await _openConfirmation(tester);
    final confirm = tester.widget<CupertinoDialogAction>(
      find.byKey(const ValueKey('confirm-restart-button')),
    );

    await tester.binding.handlePopRoute();
    confirm.onPressed!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(fixture.model.game, same(originalGame));
    expect(fixture.model.newGameCalls, 0);
    expect(fixture.model.isGamePaused, isFalse);
    expect(fixture.model.timer?.isActive ?? false, isTrue);
    expect(find.byType(ChessView), findsOneWidget);
    expect(find.byType(CupertinoAlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('removing the match route dismisses its pending confirmation',
      (tester) async {
    final fixture = await _mountGame(tester);
    final originalGame = fixture.model.game;
    await _openConfirmation(tester);

    fixture.navigator.currentState!.removeRoute(fixture.route);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(CupertinoAlertDialog), findsNothing);
    expect(find.byType(ChessView), findsNothing);
    expect(fixture.model.game, same(originalGame));
    expect(fixture.model.newGameCalls, 0);
    expect(fixture.model.isGamePaused, isTrue);
    expect(fixture.model.gameInProgress, isFalse);
    expect(fixture.model.timer?.isActive ?? false, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}

Future<void> _openConfirmation(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('restart-game-button')));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
  expect(find.byType(CupertinoAlertDialog), findsOneWidget);
}

List<String?> _position(ChessBoard board) => board.tiles
    .map((piece) => piece == null
        ? null
        : '${piece.player}:${piece.type}:${piece.tile}:${piece.moveCount}')
    .toList();

Future<_Fixture> _mountGame(WidgetTester tester) async {
  await tester.runAsync(() => Flame.images.loadAll([
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
      ]));
  final fixture = _Fixture();
  addTearDown(() {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    fixture.model.dispose();
  });
  await fixture.model.initialization;
  await fixture.model.purchaseInitialization;
  await tester.pumpWidget(
    ChangeNotifierProvider<AppModel>.value(
      value: fixture.model,
      child: CupertinoApp(
        navigatorKey: fixture.navigator,
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(builder: (context) {
          fixture.context = context;
          return const CupertinoPageScaffold(child: SizedBox.expand());
        }),
      ),
    ),
  );
  expect(await fixture.model.resumeGame(fixture.context), isTrue);
  fixture.route = CupertinoPageRoute<void>(
    builder: (_) => ChessView(appModel: fixture.model),
  );
  unawaited(fixture.navigator.currentState!.push(fixture.route));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
  return fixture;
}

class _Fixture {
  DateTime now = DateTime(2026, 10, 16, 12);
  final store = _MemoryStore(_savedGame());
  final navigator = GlobalKey<NavigatorState>();
  late final model = _TrackingAppModel(store: store, now: () => now);
  late BuildContext context;
  late CupertinoPageRoute<void> route;
}

class _TrackingAppModel extends AppModel {
  _TrackingAppModel({
    required InProgressGameStore store,
    required DateTime Function() now,
  }) : super(inProgressGameStore: store, now: now);

  int newGameCalls = 0;

  @override
  void newGame(BuildContext context, {bool notify = true}) {
    newGameCalls++;
    super.newGame(context, notify: notify);
  }
}

InProgressGame _savedGame() {
  final board = ChessBoard();
  push(moveFromUci('e2e4'), board);
  return InProgressGame(
    sessionId: 'restart-confirmation-fixture',
    playerCount: 2,
    aiDifficulty: 3,
    selectedSide: Player.player1,
    playerSide: Player.player1,
    timeLimit: 5,
    turn: Player.player2,
    whiteTimeMs: 234000,
    blackTimeMs: 123000,
    moves: board.moveStack.map(InProgressGame.copyStackMove).toList(),
    redoMoves: const [],
    reviews: const [],
  );
}

class _MemoryStore implements InProgressGameStore {
  _MemoryStore(this.saved);

  InProgressGame? saved;

  @override
  Future<InProgressGame?> load() async => saved;

  @override
  Future<void> save(InProgressGame game) async => saved = game;

  @override
  Future<void> clear() async => saved = null;
}
