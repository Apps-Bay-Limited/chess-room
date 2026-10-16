import 'dart:async';

import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/in_progress_game.dart';
import 'package:chess_room/views/chess_view.dart';
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

  testWidgets('disposing a timed game saves silently and cancels the session',
      (tester) async {
    await _preloadSprites(tester);
    var now = DateTime(2026, 10, 16, 12);
    final store = _MemoryStore();
    final model = _TrackingAppModel(store: store, now: () => now);
    addTearDown(model.dispose);
    await model.initialization;
    await model.purchaseInitialization;
    final navigator = GlobalKey<NavigatorState>();
    final context = await _mountLauncher(tester, model, navigator);
    _launchGame(context, model);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    model.setTipInProgress(true);
    await tester.pump();
    var notifications = 0;
    model.addListener(() => notifications++);
    now = now.add(const Duration(milliseconds: 500));

    // Removing the whole Navigator reaches dispose without a pop callback.
    await tester.pumpWidget(const SizedBox());
    await model.saveInProgressGame();

    expect(tester.takeException(), isNull);
    expect(model.exitCalls, 1);
    expect(notifications, 0);
    expect(model.tipInProgress, isFalse);
    expect(model.isGamePaused, isTrue);
    expect(model.gameInProgress, isFalse);
    expect(model.timer?.isActive ?? false, isFalse);
    expect(model.player1TimeLeft.inMilliseconds, 299500);
    expect(store.saved!.whiteTimeMs, 299500);
  });

  testWidgets(
      'pop and disposal exit once after resetting inside the game route',
      (tester) async {
    await _preloadSprites(tester);
    final model = _TrackingAppModel(
      store: _MemoryStore(),
      now: () => DateTime(2026, 10, 16, 12),
    );
    addTearDown(model.dispose);
    await model.initialization;
    await model.purchaseInitialization;
    final navigator = GlobalKey<NavigatorState>();
    final context = await _mountLauncher(tester, model, navigator);
    _launchGame(context, model);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    final originalGame = model.game;

    model.newGame(tester.element(find.byType(ChessView)));
    await tester.pump();
    expect(model.game, isNot(same(originalGame)));
    expect(model.isGamePaused, isFalse);

    navigator.currentState!.pop();
    expect(model.exitCalls, 1);
    expect(model.isGamePaused, isTrue);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(ChessView), findsNothing);
    expect(model.exitCalls, 1);
    expect(model.timer?.isActive ?? false, isFalse);
    expect(tester.takeException(), isNull);
    await model.saveInProgressGame();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
      'outgoing route disposal cannot pause an immediately relaunched game',
      (tester) async {
    await _preloadSprites(tester);
    var now = DateTime(2026, 10, 16, 12);
    final model = _TrackingAppModel(store: _MemoryStore(), now: () => now);
    addTearDown(model.dispose);
    await model.initialization;
    await model.purchaseInitialization;
    final navigator = GlobalKey<NavigatorState>();
    final context = await _mountLauncher(tester, model, navigator);
    _launchGame(context, model);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    final outgoingGame = model.game;

    navigator.currentState!.pop();
    expect(model.exitCalls, 1);
    expect(model.isGamePaused, isTrue);
    // Relaunch before pumping the reverse transition or disposing the old view.
    _launchGame(context, model);
    final newGame = model.game;
    expect(newGame, isNot(same(outgoingGame)));
    await tester.pump();
    now = now.add(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(model.game, same(newGame));
    expect(model.exitCalls, 1);
    expect(model.isGamePaused, isFalse);
    expect(model.gameInProgress, isTrue);
    expect(model.timer?.isActive ?? false, isTrue);
    expect(model.player1TimeLeft.inMilliseconds, 299500);
    expect(tester.takeException(), isNull);

    navigator.currentState!.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(model.exitCalls, 2);
    await model.saveInProgressGame();
    await tester.pumpWidget(const SizedBox());
  });
}

Future<BuildContext> _mountLauncher(
  WidgetTester tester,
  AppModel model,
  GlobalKey<NavigatorState> navigator,
) async {
  late BuildContext launchContext;
  await tester.pumpWidget(
    ChangeNotifierProvider<AppModel>.value(
      value: model,
      child: CupertinoApp(
        navigatorKey: navigator,
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(builder: (context) {
          launchContext = context;
          return const CupertinoPageScaffold(child: SizedBox.expand());
        }),
      ),
    ),
  );
  await tester.pump();
  return launchContext;
}

void _launchGame(BuildContext context, AppModel model) {
  model.setPlayerCount(2);
  model.setTimeLimit(5);
  model.newGame(context, notify: false);
  unawaited(Navigator.of(context).push<void>(
    CupertinoPageRoute(builder: (_) => ChessView(appModel: model)),
  ));
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

class _TrackingAppModel extends AppModel {
  _TrackingAppModel({
    required InProgressGameStore store,
    required DateTime Function() now,
  }) : super(inProgressGameStore: store, now: now);

  int exitCalls = 0;

  @override
  void exitChessView({bool notify = true}) {
    exitCalls++;
    super.exitChessView(notify: notify);
  }
}

class _MemoryStore implements InProgressGameStore {
  InProgressGame? saved;

  @override
  Future<InProgressGame?> load() async => saved;

  @override
  Future<void> save(InProgressGame game) async => saved = game;

  @override
  Future<void> clear() async => saved = null;
}
