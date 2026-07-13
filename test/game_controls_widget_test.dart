import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/chess_view/game_tip_button.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/time_limit_picker.dart';
import 'package:chess_room/views/components/settings_view/toggle.dart';
import 'package:chess_room/views/components/settings_view/toggles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('time limit is a single row and exposes expanded presets',
      (tester) async {
    var selectedTime = 0;
    await tester.pumpWidget(
      _localizedApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: TimeLimitPicker(
                selectedTime: selectedTime,
                setFunc: (value) {
                  setState(() => selectedTime = value ?? 0);
                },
              ),
            );
          },
        ),
      ),
    );

    final labelCenter = tester.getCenter(find.text('Time Limit'));
    final valueCenter = tester.getCenter(find.text('No limit'));
    expect((labelCenter.dy - valueCenter.dy).abs(), lessThan(4));

    await tester.tap(
      find.byKey(const ValueKey('time-limit-picker-button')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoPicker), findsOneWidget);
    expect(timeLimitOptions.length, greaterThan(7));
    expect(timeLimitOptions, containsAll(<int>[2, 20, 45, 60, 90]));

    await tester.drag(
      find.byKey(const ValueKey('time-limit-wheel')),
      const Offset(0, -220),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('time-limit-done-button')));
    await tester.pumpAndSettle();

    expect(selectedTime, greaterThan(0));
  });

  testWidgets('tip button invokes its action', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: GameTipButton(label: 'Tip', onTap: () => taps++),
        ),
      ),
    );

    await tester.tap(find.text('Tip'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('tip button shows progress while the deeper search runs',
      (tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: Center(
          child: GameTipButton(
            label: 'Tip',
            onTap: null,
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.lightbulb_fill), findsNothing);
  });

  testWidgets('tip button can be disabled and persists from settings',
      (tester) async {
    final appModel = AppModel();
    await tester.pumpWidget(_localizedApp(Toggles(appModel)));
    await tester.pump();

    final tipToggle = find.descendant(
      of: find.widgetWithText(Toggle, 'Show Tip Button'),
      matching: find.byType(CupertinoSwitch),
    );
    expect(tipToggle, findsOneWidget);

    await tester.tap(tipToggle);
    await tester.pump();

    final preferences = await SharedPreferences.getInstance();
    expect(appModel.showTipButton, isFalse);
    expect(preferences.getBool('showTipButton'), isFalse);
    appModel.dispose();
  });
}

Widget _localizedApp(Widget home) {
  return CupertinoApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      child: SafeArea(child: home),
    ),
  );
}
