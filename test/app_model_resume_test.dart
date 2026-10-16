import 'dart:async';

import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/in_progress_game.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers.global'), (_) async => null);
    messenger.setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers.global/events'),
        (_) async => null);
    messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (call) async {
        if (call.method == 'create') {
          final id = (call.arguments as Map)['playerId'];
          messenger.setMockMethodCallHandler(
              MethodChannel('xyz.luan/audioplayers/events/$id'),
              (_) async => null);
        }
        return null;
      },
    );
  });

  test('initialization loads setup preferences and unfinished match', () async {
    SharedPreferences.setMockInitialValues({
      'aiDifficulty': 6,
      'selectedSide': 'player2',
      'timeLimit': 15,
    });
    final model = AppModel(inProgressGameStore: _MemoryStore(_savedGame()));
    await model.initialization;
    expect(model.hasResumableGame, isTrue);
    expect(model.aiDifficulty, 6);
    expect(model.selectedSide, Player.player2);
    expect(model.timeLimit, 15);
    model.dispose();
  });

  testWidgets(
      'resume restores match settings without replacing setup preferences',
      (tester) async {
    await _preloadSprites(tester);
    SharedPreferences.setMockInitialValues({
      'aiDifficulty': 6,
      'selectedSide': 'player2',
      'timeLimit': 15,
    });
    final store = _MemoryStore(_savedGame());
    final model = AppModel(inProgressGameStore: store);
    await model.initialization;
    final context = await _context(tester);
    expect(await model.resumeGame(context), isTrue);
    await tester.pump();
    expect(model.aiDifficulty, 3);
    expect(model.selectedSide, Player.player1);
    expect(model.timeLimit, 5);
    expect(model.game!.board.moveCount, 1);
    expect(model.turn, Player.player2);
    expect(model.player1TimeLeft.inMilliseconds, 123000);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('aiDifficulty'), 6);
    expect(prefs.getInt('timeLimit'), 15);
    expect(prefs.getString('selectedSide'), 'player2');
    model.exitChessView();
    await model.saveInProgressGame();
    model.dispose();
  });

  testWidgets(
      'pause cancels delayed AI and exiting prevents foreground restart',
      (tester) async {
    await _preloadSprites(tester);
    final model = AppModel(inProgressGameStore: _MemoryStore());
    await model.initialization;
    model.setPlayerSide(Player.player2);
    final context = await _context(tester);
    model.newGame(context);
    expect(model.turn, Player.player1);
    expect(model.isAIsTurn, isTrue);
    await model.pauseGame();
    await tester.pump(const Duration(seconds: 1));
    expect(model.game!.board.moveCount, 0);
    expect(model.timer?.isActive ?? false, isFalse);
    model.resumeGameSession();
    expect(model.isGamePaused, isFalse);
    model.exitChessView();
    model.resumeGameSession();
    expect(model.isGamePaused, isTrue);
    await tester.pump(const Duration(seconds: 1));
    expect(model.game!.board.moveCount, 0);
    await model.saveInProgressGame();
    model.dispose();
  });

  testWidgets('quick play restores saved setup after continuing an older match',
      (tester) async {
    await _preloadSprites(tester);
    SharedPreferences.setMockInitialValues({
      'aiDifficulty': 6,
      'selectedSide': 'player2',
      'timeLimit': 15,
    });
    final store = _MemoryStore(_savedGame());
    final model = AppModel(
      inProgressGameStore: store,
      now: () => DateTime(2026, 10, 16),
    );
    await model.initialization;
    final context = await _context(tester);
    await model.resumeGame(context);
    expect(model.aiDifficulty, 3);
    expect(model.selectedSide, Player.player1);
    expect(model.timeLimit, 5);
    model.exitChessView();
    await model.saveInProgressGame();
    final previousClock = model.player1TimeLeft;
    await model.prepareQuickPlay();
    expect(model.playerCount, 1);
    expect(model.aiDifficulty, 6);
    expect(model.selectedSide, Player.player2);
    expect(model.timeLimit, 15);
    expect(model.player1TimeLeft, previousClock);
    expect(store.game!.aiDifficulty, 3);
    expect(store.game!.timeLimit, 5);
    model.newGame(context);
    model.exitChessView();
    await model.saveInProgressGame();
    expect(store.game!.aiDifficulty, 6);
    expect(store.game!.playerSide, Player.player2);
    expect(store.game!.timeLimit, 15);
    expect(model.player1TimeLeft.inMinutes, 15);
    await tester.pump(const Duration(seconds: 1));
    model.dispose();
  });

  testWidgets('undo and redo automatically persist the displayed position',
      (tester) async {
    await _preloadSprites(tester);
    final store = _MemoryStore(_savedGame());
    final model = AppModel(inProgressGameStore: store);
    await model.initialization;
    final context = await _context(tester);
    await model.resumeGame(context);
    model.game!.undoMove();
    await model.saveInProgressGame();
    expect(store.game!.moves, isEmpty);
    expect(store.game!.redoMoves, hasLength(1));
    expect(store.game!.turn, Player.player1);
    expect(store.game!.restore().board.moveCount, 0);
    model.game!.redoMove();
    await model.saveInProgressGame();
    expect(store.game!.moves, hasLength(1));
    expect(store.game!.redoMoves, isEmpty);
    expect(store.game!.turn, Player.player2);
    expect(store.game!.restore().board.moveCount, 1);
    model.exitChessView();
    await model.saveInProgressGame();
    model.dispose();
  });

  testWidgets('queued end-game deletion wins over an unfinished save',
      (tester) async {
    await _preloadSprites(tester);
    final store = _MemoryStore();
    final model = AppModel(inProgressGameStore: store);
    await model.initialization;
    final context = await _context(tester);
    model.setPlayerCount(2);
    store.writeGate = Completer<void>();
    model.newGame(context);
    final saving = model.saveInProgressGame();
    await tester.pump();
    model.endGame();
    expect(model.hasResumableGame, isFalse);
    store.writeGate!.complete();
    await saving;
    await model.discardInProgressGame();
    expect(store.game, isNull);
    expect(store.operations.last, 'clear');
    model.dispose();
  });

  testWidgets(
      'paused clocks exclude background time and silent exit suppresses tip updates',
      (tester) async {
    await _preloadSprites(tester);
    var now = DateTime(2026, 10, 16, 12);
    final model = AppModel(inProgressGameStore: _MemoryStore(), now: () => now);
    await model.initialization;
    final context = await _context(tester);
    model.setPlayerCount(2);
    model.setTimeLimit(5);
    model.newGame(context);
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 100));
    expect(model.player1TimeLeft.inMilliseconds, 299000);
    now = now.add(const Duration(milliseconds: 500));
    await model.pauseGame();
    expect(model.player1TimeLeft.inMilliseconds, 298500);
    now = now.add(const Duration(hours: 2));
    await tester.pump(const Duration(seconds: 10));
    expect(model.player1TimeLeft.inMilliseconds, 298500);
    model.resumeGameSession();
    now = now.add(const Duration(milliseconds: 500));
    model.setTipInProgress(true);
    var notifications = 0;
    model.addListener(() => notifications++);
    model.exitChessView(notify: false);
    expect(model.tipInProgress, isFalse);
    expect(model.player1TimeLeft.inMilliseconds, 298000);
    expect(notifications, 0);
    await model.saveInProgressGame();
    model.dispose();
  });

  testWidgets('setup changes leave the paused match settings and clocks intact',
      (tester) async {
    await _preloadSprites(tester);
    final store = _MemoryStore(_savedGame());
    final model = AppModel(inProgressGameStore: store);
    await model.initialization;
    final context = await _context(tester);
    await model.resumeGame(context);
    model.exitChessView();
    model.setPlayerCount(1);
    model.setAIDifficulty(6);
    model.setPlayerSide(Player.player2);
    model.setTimeLimit(90);
    await model.pauseGame();
    expect(store.game!.playerCount, 2);
    expect(store.game!.aiDifficulty, 3);
    expect(store.game!.selectedSide, Player.player1);
    expect(store.game!.timeLimit, 5);
    expect(store.game!.whiteTimeMs, 123000);
    expect(store.game!.blackTimeMs, lessThanOrEqualTo(234000));
    model.dispose();
  });
}

Future<BuildContext> _context(WidgetTester tester) async {
  late BuildContext result;
  await tester.pumpWidget(CupertinoApp(home: Builder(builder: (context) {
    result = context;
    return const SizedBox();
  })));
  return result;
}

Future<void> _preloadSprites(WidgetTester tester) async {
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
}

InProgressGame _savedGame() {
  final board = ChessBoard();
  push(moveFromUci('e2e4'), board);
  return InProgressGame(
    playerCount: 2,
    aiDifficulty: 3,
    selectedSide: Player.player1,
    playerSide: Player.player1,
    timeLimit: 5,
    turn: Player.player2,
    whiteTimeMs: 123000,
    blackTimeMs: 234000,
    moves: board.moveStack.map(InProgressGame.copyStackMove).toList(),
    redoMoves: const [],
    reviews: const [],
  );
}

class _MemoryStore implements InProgressGameStore {
  InProgressGame? game;
  Completer<void>? writeGate;
  final operations = <String>[];
  _MemoryStore([this.game]);

  @override
  Future<InProgressGame?> load() async => game;

  @override
  Future<void> save(InProgressGame value) async {
    await writeGate?.future;
    operations.add('save');
    game = value;
  }

  @override
  Future<void> clear() async {
    operations.add('clear');
    game = null;
  }
}
