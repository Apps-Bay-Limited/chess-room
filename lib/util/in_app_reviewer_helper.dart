import 'dart:convert';

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReviewClient {
  Future<bool> isAvailable();

  Future<void> requestReview();
}

class NativeReviewClient implements ReviewClient {
  final InAppReview _review;

  NativeReviewClient({InAppReview? review})
      : _review = review ?? InAppReview.instance;

  @override
  Future<bool> isAvailable() => _review.isAvailable();

  @override
  Future<void> requestReview() => _review.requestReview();
}

class ReviewRequestPolicy {
  final int minimumCompletedActivities;
  final int minimumDistinctDays;
  final Duration minimumInstallAge;
  final Duration requestCooldown;
  final int maximumAttemptsPerYear;
  final Duration rollingYear;

  const ReviewRequestPolicy({
    this.minimumCompletedActivities = 3,
    this.minimumDistinctDays = 2,
    this.minimumInstallAge = const Duration(days: 2),
    this.requestCooldown = const Duration(days: 90),
    this.maximumAttemptsPerYear = 3,
    this.rollingYear = const Duration(days: 365),
  })  : assert(minimumCompletedActivities > 0),
        assert(minimumDistinctDays > 0),
        assert(maximumAttemptsPerYear > 0);
}

/// Completion events only update eligibility. Call [maybeRequestReview] at a
/// natural return to the home screen, with a live guard for gameplay, practice,
/// purchases, lifecycle state and full-screen ads.
class InAppReviewHelper {
  static const storageKey = 'in_app_review_progress_v1';
  static final shared = InAppReviewHelper();

  // Serializing across helper instances also protects callers that record a
  // completion while another route is considering a request.
  static Future<void> _operations = Future<void>.value();

  final ReviewClient _client;
  final DateTime Function() _now;
  final Future<SharedPreferences> Function() _preferences;
  final ReviewRequestPolicy policy;

  InAppReviewHelper({
    ReviewClient? client,
    DateTime Function()? now,
    Future<SharedPreferences> Function()? preferences,
    this.policy = const ReviewRequestPolicy(),
  })  : _client = client ?? NativeReviewClient(),
        _now = now ?? DateTime.now,
        _preferences = preferences ?? SharedPreferences.getInstance;

  /// Records the first observed installation time without requesting a review.
  /// Existing installations start the age requirement when this policy arrives.
  Future<void> initialize() async {
    await _serialized(() async {
      final preferences = await _preferences();
      final state = _read(preferences, _now());
      return _save(preferences, state);
    });
  }

  /// Use the same stable ID after undo, resume or re-ending the same game.
  Future<void> recordCompletedGame(String uniqueGameId) =>
      _record('game', uniqueGameId);

  /// A daily puzzle can count once for its calendar day, including revisits.
  /// The activity day itself is taken from the clock when completion occurs.
  Future<void> recordCompletedPuzzle(DateTime puzzleDay) =>
      _record('daily', _dateKey(puzzleDay));

  /// Supply a stable, namespaced ID for a training puzzle or opening course.
  /// Replaying the same activity does not increase the completion count.
  Future<void> recordCompletedActivity(String stableId) =>
      _record('activity', stableId);

  Future<void> _record(String kind, String id) async {
    if (id.trim().isEmpty) return;
    final completedAt = _now();
    await _serialized(() async {
      final preferences = await _preferences();
      final state = _read(preferences, completedAt);
      final key = '$kind:$id';
      if (state.completions.containsKey(key)) return true;
      state.completions[key] = _dateKey(completedAt);
      return _save(preferences, state);
    });
  }

  /// Returns true when the native request was attempted. OS quotas may still
  /// prevent a sheet from appearing. Availability failures do not consume quota;
  /// a native request that throws still starts the cooldown to avoid retry loops.
  Future<bool> maybeRequestReview({required bool Function() isBlocked}) =>
      _serialized(() async {
        if (isBlocked()) return false;
        final preferences = await _preferences();
        if (isBlocked()) return false;
        final state = _read(preferences, _now());
        if (!_eligible(state, _now())) return false;
        if (!await _client.isAvailable() || isBlocked()) return false;
        final requestedAt = _now().toUtc();
        if (!_eligible(state, requestedAt)) return false;

        // Persist before invoking the OS, so an interrupted process cannot
        // immediately request again after relaunch.
        final previousCount = state.completionCountAtLastRequest;
        state.attempts.add(requestedAt);
        state.completionCountAtLastRequest = state.completions.length;
        if (!await _save(preferences, state)) return false;
        if (isBlocked()) {
          // The route may change while storage is being written. No native
          // request occurred, so restore eligibility for the next safe exit.
          state.attempts.removeLast();
          state.completionCountAtLastRequest = previousCount;
          await _save(preferences, state);
          return false;
        }
        try {
          await _client.requestReview();
        } catch (_) {
          // An attempted native request remains subject to the same cooldown.
        }
        return true;
      });

  bool _eligible(_ReviewProgress state, DateTime now) {
    if (state.completions.length < policy.minimumCompletedActivities ||
        state.completions.values.toSet().length < policy.minimumDistinctDays ||
        state.completions.length <= state.completionCountAtLastRequest ||
        now.toUtc().difference(state.firstSeenAt) < policy.minimumInstallAge) {
      return false;
    }
    final attempts = state.attempts;
    if (attempts.isNotEmpty) {
      final latest = attempts.reduce((a, b) => a.isAfter(b) ? a : b);
      if (now.toUtc().difference(latest) < policy.requestCooldown) return false;
    }
    final windowStart = now.toUtc().subtract(policy.rollingYear);
    return attempts.where((attempt) => attempt.isAfter(windowStart)).length <
        policy.maximumAttemptsPerYear;
  }

  _ReviewProgress _read(SharedPreferences preferences, DateTime now) {
    try {
      final encoded = preferences.getString(storageKey);
      if (encoded != null) {
        final decoded = jsonDecode(encoded);
        final state = _ReviewProgress.fromJson(decoded);
        if (state != null) return state;
      }
    } on FormatException {
      // Damaged or obsolete storage starts a conservative new age window.
    } on TypeError {
      // Also recover when a damaged preferences value has the wrong type.
    }
    return _ReviewProgress(firstSeenAt: now.toUtc());
  }

  Future<bool> _save(SharedPreferences preferences, _ReviewProgress state) =>
      preferences.setString(storageKey, jsonEncode(state.toJson()));

  Future<bool> _serialized(Future<bool> Function() operation) {
    final result = _operations.then((_) => operation()).catchError(
          (Object _, StackTrace __) => false,
        );
    // Failures in preferences or platform channels must not poison later work
    // or become unhandled errors in fire-and-forget completion hooks.
    _operations = result.then<void>((_) {});
    return result;
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class _ReviewProgress {
  final DateTime firstSeenAt;
  final Map<String, String> completions;
  final List<DateTime> attempts;
  int completionCountAtLastRequest;

  _ReviewProgress({
    required this.firstSeenAt,
    Map<String, String>? completions,
    List<DateTime>? attempts,
    this.completionCountAtLastRequest = 0,
  })  : completions = completions ?? {},
        attempts = attempts ?? [];

  static _ReviewProgress? fromJson(Object? json) {
    if (json is! Map || json['version'] != 1) return null;
    final firstSeen = json['firstSeenAt'];
    final completions = json['completions'];
    final attempts = json['attempts'];
    final previousCount = json['completionCountAtLastRequest'];
    if (firstSeen is! String ||
        completions is! Map ||
        attempts is! List ||
        previousCount is! int ||
        previousCount < 0 ||
        previousCount > completions.length) {
      return null;
    }
    final firstSeenAt = DateTime.tryParse(firstSeen);
    if (firstSeenAt == null) return null;
    final parsedCompletions = <String, String>{};
    for (final entry in completions.entries) {
      if (entry.key is! String ||
          entry.value is! String ||
          !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(entry.value) ||
          DateTime.tryParse(entry.value) == null) {
        return null;
      }
      parsedCompletions[entry.key as String] = entry.value as String;
    }
    final parsedAttempts = <DateTime>[];
    for (final value in attempts) {
      if (value is! String) return null;
      final parsed = DateTime.tryParse(value);
      if (parsed == null) return null;
      parsedAttempts.add(parsed.toUtc());
    }
    return _ReviewProgress(
      firstSeenAt: firstSeenAt.toUtc(),
      completions: parsedCompletions,
      attempts: parsedAttempts,
      completionCountAtLastRequest: previousCount,
    );
  }

  Map<String, Object> toJson() => {
        'version': 1,
        'firstSeenAt': firstSeenAt.toIso8601String(),
        'completions': completions,
        'attempts': attempts.map((time) => time.toIso8601String()).toList(),
        'completionCountAtLastRequest': completionCountAtLastRequest,
      };
}
