import 'package:chess_room/util/ads_manager.dart';
import 'package:chess_room/util/practice_session_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nested manual sessions release independently and idempotently', () {
    expect(AdsManager.isPracticeInProgress, isFalse);
    final releaseParent = AdsManager.beginPracticeSession();
    final releaseChild = AdsManager.beginPracticeSession();
    addTearDown(releaseParent);
    addTearDown(releaseChild);
    expect(AdsManager.practiceSessionCount.value, 2);
    releaseChild();
    releaseChild();
    expect(AdsManager.practiceSessionCount.value, 1);
    expect(AdsManager.isPracticeInProgress, isTrue);
    releaseParent();
    expect(AdsManager.isPracticeInProgress, isFalse);
    expect(AdsManager.practiceSessionCount.value, 0);
  });

  testWidgets('direct-entry scope protects practice until disposal',
      (tester) async {
    await tester.pumpWidget(const PracticeSessionScope(child: SizedBox()));
    expect(AdsManager.isPracticeInProgress, isTrue);
    expect(AdsManager.practiceSessionCount.value, 1);
    await tester.pumpWidget(const SizedBox());
    expect(AdsManager.isPracticeInProgress, isFalse);
  });

  testWidgets(
      'rebuilds keep a scope and nested disposal keeps parent protected',
      (tester) async {
    var nested = true;
    late StateSetter rebuild;
    await tester.pumpWidget(StatefulBuilder(builder: (context, setState) {
      rebuild = setState;
      return PracticeSessionScope(
        child: nested
            ? const PracticeSessionScope(child: SizedBox())
            : const SizedBox(),
      );
    }));
    expect(AdsManager.practiceSessionCount.value, 2);
    rebuild(() {});
    await tester.pump();
    expect(AdsManager.practiceSessionCount.value, 2);
    rebuild(() => nested = false);
    await tester.pump();
    expect(AdsManager.practiceSessionCount.value, 1);
    expect(AdsManager.isPracticeInProgress, isTrue);
    await tester.pumpWidget(const SizedBox());
    expect(AdsManager.isPracticeInProgress, isFalse);
  });
}
