import 'package:chess_room/model/app_themes.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('page text remains readable across every selectable theme', () {
    for (final theme in themeList) {
      final originalColors = List<Color>.of(theme.background.colors);
      final page = readablePageGradient(theme.background);
      for (var stop = 0; stop < page.colors.length - 1; stop++) {
        for (var step = 0; step <= 10; step++) {
          final background =
              Color.lerp(page.colors[stop], page.colors[stop + 1], step / 10)!;
          for (final foreground in [
            AppColors.textPrimary,
            AppColors.textSecondary,
            AppColors.accent,
          ]) {
            final contrast = (foreground.computeLuminance() + .05) /
                (background.computeLuminance() + .05);
            expect(contrast, greaterThanOrEqualTo(4.5),
                reason: '${theme.name}, gradient stop $stop, sample $step');
          }
        }
      }
      expect(theme.background.colors, originalColors);
    }
  });

  test('dark default theme retains its original page gradient', () {
    for (final name in ['AppsBay', 'Dark', 'AMOLED']) {
      final gradient =
          themeList.firstWhere((theme) => theme.name == name).background;
      expect(readablePageGradient(gradient), same(gradient));
    }
  });
}
