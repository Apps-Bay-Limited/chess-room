import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/views/components/settings_view/settings_navigation_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Settings exposes Game History and invokes its action',
      (tester) async {
    var historyOpened = false;
    var privacyChoicesOpened = false;

    await tester.pumpWidget(
      CupertinoApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: CupertinoPageScaffold(
          child: SettingsNavigationButtons(
            showPrivacyChoices: true,
            onHowToPlay: () {},
            onGameHistory: () => historyOpened = true,
            onPrivacyChoices: () => privacyChoicesOpened = true,
            onMoreApps: () {},
            onBack: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Game History'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('settings-game-history-button')),
    );
    await tester.pump();

    expect(historyOpened, isTrue);

    expect(find.text('Privacy Choices'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('settings-privacy-choices-button')),
    );
    await tester.pump();

    expect(privacyChoicesOpened, isTrue);
  });
}
