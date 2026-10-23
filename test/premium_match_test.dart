import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_game.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/chess_view.dart';
import 'package:chess_room/views/components/chess_view/chess_board_widget.dart';
import 'package:chess_room/views/components/chess_view/game_info_and_controls/timer_widget.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/board_coordinates.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final channel in [
      'xyz.luan/audioplayers.global',
      'xyz.luan/audioplayers.global/events'
    ]) {
      messenger.setMockMethodCallHandler(
          MethodChannel(channel), (_) async => null);
    }
    messenger.setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers'), (call) async {
      if (call.method == 'create') {
        final id = (call.arguments as Map)['playerId'];
        messenger.setMockMethodCallHandler(
            MethodChannel('xyz.luan/audioplayers/events/$id'),
            (_) async => null);
      }
      return null;
    });
  });

  for (final size in [const Size(375, 667), const Size(1024, 1366)]) {
    testWidgets(
        'scaled match board keeps e2-e4 input and coordinate toggle at $size',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
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
      final model = AppModel(now: () => DateTime(2026, 10, 23, 12));
      addTearDown(model.dispose);
      await model.initialization;
      await model.purchaseInitialization;
      model.soundEnabled = false;
      late BuildContext launchContext;
      final captureKey = GlobalKey();
      await tester.pumpWidget(ChangeNotifierProvider.value(
          value: model,
          child: _app(Builder(builder: (context) {
            launchContext = context;
            return const CupertinoPageScaffold(child: SizedBox.expand());
          }))));
      model.setPlayerCount(2);
      model.setTimeLimit(5);
      model.newGame(launchContext, notify: false);
      unawaited(Navigator.of(launchContext).push<void>(CupertinoPageRoute(
          builder: (_) => RepaintBoundary(
              key: captureKey, child: ChessView(appModel: model)))));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
      final game = model.game!;
      final before = chessPositionToFen(game.board, model.turn);
      await tester.tap(find.byKey(const ValueKey('board-coordinates-button')));
      await tester.pump();
      expect(
          tester
              .widget<BoardCoordinates>(find.byType(BoardCoordinates))
              .visible,
          isTrue);
      expect(chessPositionToFen(game.board, model.turn), before);
      await tester.ensureVisible(find.byType(ChessBoardWidget));
      await tester.pump();
      await _tapSquare(tester, 52);
      expect(game.selectedPiece?.tile, 52);
      await _tapSquare(tester, 36);
      expect(game.board.tiles[52], isNull);
      expect(game.board.tiles[36]?.player, Player.player1);
      expect(model.turn, Player.player2);
      expect(tester.getRect(find.byType(ChessBoardWidget)).width,
          lessThanOrEqualTo(600));
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('CAPTURE_UX')) {
        await _capture(tester, captureKey,
            size.width == 375 ? 'match-phone' : 'match-tablet');
      }
      await tester.pumpWidget(const SizedBox());
      await model.saveInProgressGame();
    });
  }

  testWidgets(
      'clock labels and board square semantics fit Arabic with large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    final position = chessPositionFromFen('6k1/8/6KQ/8/8/8/8/8 w - - 0 1');
    await tester.pumpWidget(_app(
        Builder(
            builder: (context) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(2)),
                  child: CupertinoPageScaffold(
                      child: SafeArea(
                          child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(children: [
                          Row(children: [
                            TimerWidget(
                                timeLeft: const Duration(minutes: 90),
                                color: CupertinoColors.white,
                                label: S.of(context).Clock_White,
                                isActive: true,
                                activeLabel: S.of(context).Clock_Active),
                            const SizedBox(width: 8),
                            TimerWidget(
                                timeLeft: const Duration(minutes: 90),
                                color: CupertinoColors.black,
                                label: S.of(context).Clock_Black),
                          ]),
                          const SizedBox(height: 24),
                          PositionBoard(
                              board: position.board, onTileTap: (_) {}),
                        ])),
                  ))),
                )),
        locale: const Locale('ar')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.bySemanticsLabel(RegExp('h6')), findsOneWidget);
    semantics.dispose();
    expect(
        tester
            .getSemantics(find.byKey(const ValueKey('position-tile-23')))
            .label,
        contains('h6'));
  });
}

Widget _app(Widget home, {Locale locale = const Locale('en')}) => CupertinoApp(
      locale: locale,
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: home,
    );

Future<void> _tapSquare(WidgetTester tester, int tile) async {
  final bounds = tester.getRect(find.byType(GameWidget<ChessGame>));
  final size = bounds.width / 8;
  await tester.tapAt(
      bounds.topLeft + Offset((tile % 8 + .5) * size, (tile ~/ 8 + .5) * size));
  await tester.pump(const Duration(milliseconds: 200));
}

Future<void> _capture(WidgetTester tester, GlobalKey key, String name) async {
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final snapshot = await boundary.toImage(pixelRatio: 1);
    final bytes = await snapshot.toByteData(format: ui.ImageByteFormat.png);
    await File('/private/tmp/chess-room-$name.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
    snapshot.dispose();
  });
}
