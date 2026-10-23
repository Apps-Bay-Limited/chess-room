import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/more_apps_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('More Apps row wraps large text and invokes its callback once',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var opened = 0;
    await tester.pumpWidget(CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(2),
          disableAnimations: true,
        ),
        child: child!,
      ),
      home: CupertinoPageScaffold(
        backgroundColor: AppColors.background,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: MoreAppsRow(
              key: const ValueKey('more-app-test-row'),
              appIcon: const ColoredBox(color: AppColors.accent),
              title: 'Classical Music Box and Relaxing Sounds',
              onTap: () => opened++,
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final row = find.byKey(const ValueKey('more-app-test-row'));
    expect(tester.takeException(), isNull);
    expect(tester.getSize(row).height, greaterThan(80));
    await tester.tap(row);
    await tester.pumpAndSettle();
    expect(opened, 1);
    expect(tester.takeException(), isNull);
  });
}
