import 'package:chess_room/features/how_to_play/how_to_play_page.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('chess guide explains pieces and special moves', (tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const HowToPlayPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('How to Play Chess'), findsOneWidget);
    expect(find.text('How the pieces move'), findsOneWidget);
    expect(find.textContaining('King —'), findsOneWidget);

    final specialMoves = find.byKey(
      const ValueKey('how-to-play-special-moves'),
    );
    await tester.scrollUntilVisible(specialMoves, 400);
    expect(specialMoves, findsOneWidget);
    expect(find.textContaining('Castling —'), findsOneWidget);
    expect(find.textContaining('Promotion —'), findsOneWidget);
  });
}
