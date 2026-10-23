import 'dart:async';

import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late _Harness harness;
  setUp(() => harness = _Harness());

  test('startup and recorded completions never request a review themselves',
      () async {
    await harness.qualify();
    expect(harness.client.availabilityCalls, 0);
    expect(harness.client.requestCalls, 0);
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
    expect(harness.client.requestCalls, 1);
  });

  test('requires three completions, distinct days and two days of install age',
      () async {
    await harness.helper.initialize();
    await harness.helper.recordCompletedGame('first');
    harness.clock.now = harness.clock.now.add(const Duration(days: 1));
    await harness.helper.recordCompletedGame('second');
    await harness.helper.recordCompletedPuzzle(harness.clock.now);
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    harness.clock.now = harness.clock.now.add(const Duration(hours: 23));
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    harness.clock.now = harness.clock.now.add(const Duration(hours: 1));
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('fewer than three completions remain ineligible after the age window',
      () async {
    await harness.helper.initialize();
    await harness.helper.recordCompletedGame('first');
    harness.clock.now = harness.clock.now.add(const Duration(days: 5));
    await harness.helper.recordCompletedGame('second');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    await harness.helper.recordCompletedGame('third');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('many completions on one day do not satisfy the distinct-days rule',
      () async {
    await harness.helper.initialize();
    harness.clock.now = harness.clock.now.add(const Duration(days: 2));
    for (var index = 0; index < 6; index++) {
      await harness.helper.recordCompletedGame('game-$index');
    }
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    harness.clock.now = harness.clock.now.add(const Duration(days: 1));
    await harness.helper.recordCompletedGame('another-day');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('game undo, daily revisits and training replays are deduplicated',
      () async {
    final originalDay = harness.clock.now;
    await harness.helper.initialize();
    for (var replay = 0; replay < 3; replay++) {
      await harness.helper.recordCompletedGame('same-game');
      await harness.helper.recordCompletedPuzzle(originalDay);
      await harness.helper.recordCompletedActivity('opening:italian');
    }
    harness.clock.now = harness.clock.now.add(const Duration(days: 2));
    await harness.helper.recordCompletedGame('same-game');
    await harness.helper
        .recordCompletedPuzzle(originalDay.add(const Duration(hours: 3)));
    await harness.helper.recordCompletedActivity('opening:italian');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    // A replay must not move a previously counted activity onto another day.
    await harness.helper.recordCompletedGame('new-game');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('empty activity identifiers cannot manufacture completions', () async {
    await harness.helper.initialize();
    await harness.helper.recordCompletedGame('');
    await harness.helper.recordCompletedActivity('  ');
    harness.clock.now = harness.clock.now.add(const Duration(days: 3));
    await harness.helper.recordCompletedPuzzle(harness.clock.now);
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
  });

  test('cooldown lasts ninety days even when new activities are completed',
      () async {
    await harness.qualify();
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
    await harness.helper.recordCompletedGame('new-after-request');
    harness.clock.now =
        harness.clock.now.add(const Duration(days: 89, hours: 23));
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    harness.clock.now = harness.clock.now.add(const Duration(hours: 1));
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
    expect(harness.client.requestCalls, 2);
  });

  test('limits attempts to three in a rolling year', () async {
    await harness.qualify();
    for (var request = 0; request < 3; request++) {
      if (request > 0) {
        harness.clock.now = harness.clock.now.add(const Duration(days: 90));
        await harness.helper.recordCompletedGame('between-$request');
      }
      expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
          isTrue);
    }
    harness.clock.now = harness.clock.now.add(const Duration(days: 90));
    await harness.helper.recordCompletedGame('fourth');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    // At exactly 365 days, the first attempt leaves the rolling window.
    harness.clock.now = harness.clock.now.add(const Duration(days: 95));
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
    expect(harness.client.requestCalls, 4);
  });

  test('needs a new completion after the previous request', () async {
    await harness.qualify();
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
    harness.clock.now = harness.clock.now.add(const Duration(days: 100));
    await harness.helper.recordCompletedGame('first');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    await harness.helper.recordCompletedActivity('training:new');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('eligibility and cooldown survive helper recreation', () async {
    await harness.qualify();
    final recreated = harness.makeHelper();
    expect(await recreated.maybeRequestReview(isBlocked: () => false), isTrue);
    await harness.helper.recordCompletedGame('new');
    final thirdInstance = harness.makeHelper();
    expect(await thirdInstance.maybeRequestReview(isBlocked: () => false),
        isFalse);
    expect(harness.client.requestCalls, 1);
  });

  test('unavailable review API does not consume a request attempt', () async {
    await harness.qualify();
    harness.client.available = false;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    harness.client.available = true;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
    expect(harness.client.requestCalls, 1);
  });

  test('blocked home exit leaves the request queued without probing native API',
      () async {
    await harness.qualify();
    expect(await harness.helper.maybeRequestReview(isBlocked: () => true),
        isFalse);
    expect(harness.client.availabilityCalls, 0);
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('route change during native availability cancels presentation',
      () async {
    await harness.qualify();
    var blocked = false;
    final gate = Completer<bool>();
    harness.client.availabilityGate = gate;
    final request = harness.helper.maybeRequestReview(isBlocked: () => blocked);
    await harness.client.nextAvailability.future;
    blocked = true;
    gate.complete(true);
    expect(await request, isFalse);
    expect(harness.client.requestCalls, 0);
    blocked = false;
    harness.client.availabilityGate = null;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => blocked),
        isTrue);
  });

  test('route change during persistence cancels and restores eligibility',
      () async {
    await harness.qualify();
    var blocked = false;
    final gate = Completer<void>();
    harness.preferences.writeGate = gate;
    final writeStarted = Completer<void>();
    harness.preferences.nextWriteStarted = writeStarted;
    final request = harness.helper.maybeRequestReview(isBlocked: () => blocked);
    await writeStarted.future;
    blocked = true;
    harness.preferences.writeGate = null;
    gate.complete();
    expect(await request, isFalse);
    expect(harness.client.requestCalls, 0);
    blocked = false;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => blocked),
        isTrue);
  });

  test('simultaneous exit callbacks only request once across instances',
      () async {
    await harness.qualify();
    final other = harness.makeHelper();
    final results = await Future.wait([
      harness.helper.maybeRequestReview(isBlocked: () => false),
      other.maybeRequestReview(isBlocked: () => false),
    ]);
    expect(results.where((attempted) => attempted), hasLength(1));
    expect(harness.client.requestCalls, 1);
  });

  test('a failed storage write prevents an untracked native request', () async {
    await harness.qualify();
    harness.preferences.failWrites = true;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    expect(harness.client.requestCalls, 0);
    harness.preferences.failWrites = false;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('native errors still start the cooldown without escaping to the caller',
      () async {
    await harness.qualify();
    harness.client.throwOnRequest = true;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
    await harness.helper.recordCompletedGame('after-failed-native-request');
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    expect(harness.client.requestCalls, 1);
  });

  test('availability errors do not poison later requests', () async {
    await harness.qualify();
    harness.client.throwOnAvailability = true;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
    harness.client.throwOnAvailability = false;
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('preferences errors do not escape or poison later completion hooks',
      () async {
    var failing = true;
    final helper = InAppReviewHelper(
      client: harness.client,
      now: () => harness.clock.now,
      preferences: () async {
        if (failing) throw StateError('Preferences temporarily unavailable');
        return harness.preferences;
      },
    );
    await helper.initialize();
    await helper.recordCompletedGame('not-stored');
    expect(await helper.maybeRequestReview(isBlocked: () => false), isFalse);
    failing = false;
    await helper.initialize();
    await helper.recordCompletedGame('first');
    harness.clock.now = harness.clock.now.add(const Duration(days: 2));
    await helper.recordCompletedGame('second');
    await helper.recordCompletedPuzzle(harness.clock.now);
    expect(await helper.maybeRequestReview(isBlocked: () => false), isTrue);
  });

  test('damaged storage starts a conservative new eligibility window',
      () async {
    for (final encoded in <Object>[
      5,
      true,
      '{',
      '[]',
      'null',
      '{"version": 99}',
      '{"version": 1, "firstSeenAt": 5, "completions": []}',
    ]) {
      harness.preferences.values[InAppReviewHelper.storageKey] = encoded;
      await harness.helper.initialize();
      expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
          isFalse);
    }
    await harness.qualify();
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
  });

  test('moving the clock backwards cannot bypass a request cooldown', () async {
    await harness.qualify();
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isTrue);
    await harness.helper.recordCompletedGame('new');
    harness.clock.now = harness.clock.now.subtract(const Duration(days: 100));
    expect(await harness.helper.maybeRequestReview(isBlocked: () => false),
        isFalse);
  });
}

class _Harness {
  final clock = _Clock(DateTime(2026, 1, 1, 12));
  final preferences = _MemoryPreferences();
  final client = _FakeReviewClient();
  late final helper = makeHelper();

  InAppReviewHelper makeHelper() => InAppReviewHelper(
        client: client,
        now: () => clock.now,
        preferences: () async => preferences,
      );

  Future<void> qualify() async {
    await helper.initialize();
    await helper.recordCompletedGame('first');
    clock.now = clock.now.add(const Duration(days: 2));
    await helper.recordCompletedGame('second');
    await helper.recordCompletedPuzzle(clock.now);
  }
}

class _Clock {
  DateTime now;
  _Clock(this.now);
}

class _FakeReviewClient implements ReviewClient {
  bool available = true;
  bool throwOnAvailability = false;
  bool throwOnRequest = false;
  int availabilityCalls = 0;
  int requestCalls = 0;
  final nextAvailability = Completer<void>();
  Completer<bool>? availabilityGate;

  @override
  Future<bool> isAvailable() async {
    availabilityCalls++;
    if (!nextAvailability.isCompleted) nextAvailability.complete();
    if (throwOnAvailability) throw StateError('Availability failed');
    final gate = availabilityGate;
    if (gate != null) return gate.future;
    return available;
  }

  @override
  Future<void> requestReview() async {
    requestCalls++;
    if (throwOnRequest) throw StateError('Native request failed');
  }
}

class _MemoryPreferences extends Fake implements SharedPreferences {
  final values = <String, Object>{};
  bool failWrites = false;
  Completer<void>? writeGate;
  Completer<void>? nextWriteStarted;

  @override
  String? getString(String key) => values[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    final gate = writeGate;
    final started = nextWriteStarted;
    nextWriteStarted = null;
    started?.complete();
    if (gate != null) await gate.future;
    if (failWrites) return false;
    values[key] = value;
    return true;
  }
}
