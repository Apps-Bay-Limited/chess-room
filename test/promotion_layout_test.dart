import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_game.dart';
import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/chess_view/promotion_dialog.dart';
import 'package:chess_room/views/components/chess_view/promotion_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('all promotion choices fit a small dialog at large text sizes',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final model = AppModel();
    addTearDown(model.dispose);
    await model.initialization;
    await model.purchaseInitialization;
    await tester.pumpWidget(CupertinoApp(
      locale: const Locale('ar'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!),
      home: Builder(
          builder: (context) => CupertinoPageScaffold(
                  child: Center(
                child: CupertinoButton(
                    onPressed: () => showCupertinoDialog<void>(
                        context: context,
                        builder: (_) => PromotionDialog(model)),
                    child: const Text('Open')),
              ))),
    ));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(PromotionOption), findsNWidgets(4));
    for (final option in find.byType(PromotionOption).evaluate()) {
      final button = find.descendant(
          of: find.byWidget(option.widget),
          matching: find.byType(CupertinoButton));
      expect(tester.getSize(button).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
    }
    expect(tester.takeException(), isNull);
    await tester.tap(find.descendant(
        of: find.byType(PromotionOption).first,
        matching: find.byType(CupertinoButton)));
    await tester.pumpAndSettle();
    expect(find.byType(PromotionDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final selectedType in PROMOTIONS) {
    testWidgets(
        '${selectedType.name} ignores system back and commits once across queued choices',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final model = _RecordingModel();
      final game = _RecordingGame();
      model.game = game;
      addTearDown(model.dispose);
      await model.initialization;
      await model.purchaseInitialization;
      final observer = _PopObserver();
      await tester.pumpWidget(CupertinoApp(
        navigatorObservers: [observer],
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
            builder: (context) => CupertinoPageScaffold(
                  child: Center(
                      child: CupertinoButton(
                    onPressed: () => Navigator.push<void>(
                      context,
                      CupertinoPageRoute<void>(
                          builder: (gameContext) => CupertinoPageScaffold(
                                  child: Center(
                                      child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Game route'),
                                  CupertinoButton(
                                    onPressed: () => showCupertinoDialog<void>(
                                      context: gameContext,
                                      builder: (_) => PromotionDialog(model),
                                    ),
                                    child: const Text('Promote'),
                                  ),
                                ],
                              )))),
                    ),
                    child: const Text('Open game'),
                  )),
                )),
      ));
      await tester.tap(find.text('Open game'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Promote'));
      await tester.pumpAndSettle();

      // Android's system back uses maybePop; it must not dismiss a required
      // promotion and leave an unfinished pawn move on the board.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(PromotionDialog), findsOneWidget);
      expect(find.text('Game route'), findsOneWidget);
      expect(game.promotions, isEmpty);
      expect(model.updates, 0);
      expect(observer.pops, 0);

      CupertinoButton choice(ChessPieceType type) =>
          tester.widget<CupertinoButton>(find.descendant(
            of: find.byWidgetPredicate((widget) =>
                widget is PromotionOption && widget.promotionType == type),
            matching: find.byType(CupertinoButton),
          ));
      final first = choice(selectedType);
      final second =
          choice(PROMOTIONS.firstWhere((type) => type != selectedType));
      // Invoke queued callbacks before pumping the outgoing route animation.
      first.onPressed!();
      second.onPressed!();
      first.onPressed!();
      await tester.pumpAndSettle();

      expect(game.promotions, [selectedType]);
      expect(model.updates, 1);
      expect(observer.pops, 1);
      expect(find.byType(PromotionDialog), findsNothing);
      expect(find.text('Game route'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

class _RecordingModel extends AppModel {
  int updates = 0;

  @override
  void update() {
    updates++;
    super.update();
  }
}

class _RecordingGame implements ChessGame {
  final List<ChessPieceType> promotions = [];

  @override
  void promote(ChessPieceType type) => promotions.add(type);

  @override
  void cancelAIMove() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PopObserver extends NavigatorObserver {
  int pops = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
    super.didPop(route, previousRoute);
  }
}
