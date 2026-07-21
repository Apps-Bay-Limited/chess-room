import 'package:chess_room/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('additional localizations are generated', () async {
    final supportedLanguageCodes = S.delegate.supportedLocales
        .map((locale) => locale.languageCode)
        .toSet();

    expect(supportedLanguageCodes, containsAll({'ar', 'fr', 'es', 'ja'}));
    expect((await S.load(const Locale('ar'))).Training, 'التدريب');
    expect((await S.load(const Locale('fr'))).Training, 'Entraînement');
    expect((await S.load(const Locale('es'))).Training, 'Entrenamiento');
    expect((await S.load(const Locale('ja'))).Training, 'トレーニング');
  });

  testWidgets('Arabic localization renders right-to-left', (tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        locale: const Locale('ar'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Text(S.of(context).Training),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final trainingText = find.text('التدريب');
    expect(trainingText, findsOneWidget);
    expect(
      Directionality.of(tester.element(trainingText)),
      TextDirection.rtl,
    );
  });
}
