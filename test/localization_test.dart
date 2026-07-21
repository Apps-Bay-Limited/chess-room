import 'package:chess_room/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('French, Spanish, and Japanese localizations are generated', () async {
    final supportedLanguageCodes = S.delegate.supportedLocales
        .map((locale) => locale.languageCode)
        .toSet();

    expect(supportedLanguageCodes, containsAll({'fr', 'es', 'ja'}));
    expect((await S.load(const Locale('fr'))).Training, 'Entraînement');
    expect((await S.load(const Locale('es'))).Training, 'Entrenamiento');
    expect((await S.load(const Locale('ja'))).Training, 'トレーニング');
  });
}
