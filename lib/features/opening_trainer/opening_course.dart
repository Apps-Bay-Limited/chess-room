import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum OpeningId { italian, ruyLopez, queensGambit, sicilian, london }

class OpeningCourse {
  final OpeningId id;
  final List<String> moves;

  const OpeningCourse({required this.id, required this.moves});
}

const openingCourses = <OpeningCourse>[
  OpeningCourse(
    id: OpeningId.italian,
    moves: ['e2e4', 'e7e5', 'g1f3', 'b8c6', 'f1c4', 'f8c5'],
  ),
  OpeningCourse(
    id: OpeningId.ruyLopez,
    moves: ['e2e4', 'e7e5', 'g1f3', 'b8c6', 'f1b5', 'a7a6'],
  ),
  OpeningCourse(
    id: OpeningId.queensGambit,
    moves: ['d2d4', 'd7d5', 'c2c4', 'e7e6', 'b1c3', 'g8f6'],
  ),
  OpeningCourse(
    id: OpeningId.sicilian,
    moves: ['e2e4', 'c7c5', 'g1f3', 'd7d6', 'd2d4', 'c5d4'],
  ),
  OpeningCourse(
    id: OpeningId.london,
    moves: ['d2d4', 'd7d5', 'g1f3', 'g8f6', 'c1f4', 'e7e6'],
  ),
];

abstract class OpeningProgressStore {
  Future<Set<String>> loadCompletedIds();

  Future<void> markCompleted(String openingId);
}

class SharedPreferencesOpeningProgressStore implements OpeningProgressStore {
  static const _key = 'opening_trainer_completed_v1';

  @override
  Future<Set<String>> loadCompletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_key);
    if (encoded == null) return {};
    try {
      return (jsonDecode(encoded) as List).cast<String>().toSet();
    } on FormatException {
      return {};
    }
  }

  @override
  Future<void> markCompleted(String openingId) async {
    final completed = (await loadCompletedIds())..add(openingId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(completed.toList()..sort()));
  }
}
