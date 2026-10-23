import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/in_progress_game.dart';
import 'package:chess_room/views/components/main_menu_view/confirm_new_game.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('system Back ignores a queued replace-game confirmation',
      (tester) async {
    final fixture = await _openConfirmation(tester);
    final confirm = tester.widget<CupertinoDialogAction>(
      find.byKey(const ValueKey('confirm-new-game-button')),
    );

    await tester.binding.handlePopRoute();
    confirm.onPressed!();
    await tester.pump(const Duration(milliseconds: 20));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();

    expect(fixture.answers, [false]);
    expect(
        find.byKey(const ValueKey('replacement-setup-page')), findsOneWidget);
    expect(find.byType(CupertinoAlertDialog), findsNothing);
    expect(fixture.model.hasResumableGame, isTrue);
    expect(fixture.model.game, isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('repeated replace-game answers leave the setup route intact',
      (tester) async {
    final fixture = await _openConfirmation(tester);
    final confirm = tester.widget<CupertinoDialogAction>(
      find.byKey(const ValueKey('confirm-new-game-button')),
    );
    final cancel = tester.widget<CupertinoDialogAction>(
      find.byKey(const ValueKey('cancel-new-game-button')),
    );

    confirm.onPressed!();
    confirm.onPressed!();
    cancel.onPressed!();
    await tester.pumpAndSettle();

    expect(fixture.answers, [true]);
    expect(
        find.byKey(const ValueKey('replacement-setup-page')), findsOneWidget);
    expect(find.byType(CupertinoAlertDialog), findsNothing);
    expect(fixture.model.hasResumableGame, isTrue);
    expect(fixture.model.game, isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Future<_Fixture> _openConfirmation(WidgetTester tester) async {
  final fixture = _Fixture();
  addTearDown(fixture.model.dispose);
  await fixture.model.initialization;
  await fixture.model.purchaseInitialization;
  expect(fixture.model.hasResumableGame, isTrue);
  await tester.pumpWidget(CupertinoApp(
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
                builder: (setupContext) => CupertinoPageScaffold(
                  key: const ValueKey('replacement-setup-page'),
                  child: Center(
                    child: CupertinoButton(
                      key: const ValueKey('request-new-game'),
                      onPressed: () async => fixture.answers.add(
                        await confirmNewGame(setupContext, fixture.model),
                      ),
                      child: const Text('Start a new game'),
                    ),
                  ),
                ),
              ),
            ),
            child: const Text('Open setup'),
          ),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('Open setup'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('request-new-game')));
  await tester.pumpAndSettle();
  expect(find.byType(CupertinoAlertDialog), findsOneWidget);
  return fixture;
}

class _Fixture {
  final model = AppModel(inProgressGameStore: _SavedGameStore());
  final answers = <bool>[];
}

class _SavedGameStore implements InProgressGameStore {
  @override
  Future<InProgressGame?> load() async => const InProgressGame(
        sessionId: 'replacement-confirmation-test',
        playerCount: 2,
        aiDifficulty: 3,
        selectedSide: Player.player1,
        playerSide: Player.player1,
        timeLimit: 0,
        turn: Player.player1,
        whiteTimeMs: 0,
        blackTimeMs: 0,
        moves: [],
        redoMoves: [],
        reviews: [],
      );

  @override
  Future<void> save(InProgressGame game) async {}

  @override
  Future<void> clear() async {}
}
