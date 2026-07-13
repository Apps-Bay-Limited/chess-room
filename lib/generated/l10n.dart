// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Vs AI Player`
  String get Vs_AI_Player {
    return Intl.message(
      'Vs AI Player',
      name: 'Vs_AI_Player',
      desc: '',
      args: [],
    );
  }

  /// `Two Players`
  String get Two_Players {
    return Intl.message('Two Players', name: 'Two_Players', desc: '', args: []);
  }

  /// `Settings`
  String get Settings {
    return Intl.message('Settings', name: 'Settings', desc: '', args: []);
  }

  /// `AI Difficulty`
  String get AI_Difficulty {
    return Intl.message(
      'AI Difficulty',
      name: 'AI_Difficulty',
      desc: '',
      args: [],
    );
  }

  /// `Easy`
  String get Easy {
    return Intl.message('Easy', name: 'Easy', desc: '', args: []);
  }

  /// `Medium`
  String get Medium {
    return Intl.message('Medium', name: 'Medium', desc: '', args: []);
  }

  /// `Hard`
  String get Hard {
    return Intl.message('Hard', name: 'Hard', desc: '', args: []);
  }

  /// `Extreme`
  String get Extreme {
    return Intl.message('Extreme', name: 'Extreme', desc: '', args: []);
  }

  /// `Pick Your Side`
  String get Pick_Your_Side {
    return Intl.message(
      'Pick Your Side',
      name: 'Pick_Your_Side',
      desc: '',
      args: [],
    );
  }

  /// `White`
  String get White {
    return Intl.message('White', name: 'White', desc: '', args: []);
  }

  /// `Black`
  String get Black {
    return Intl.message('Black', name: 'Black', desc: '', args: []);
  }

  /// `Time Limit`
  String get Time_Limit {
    return Intl.message('Time Limit', name: 'Time_Limit', desc: '', args: []);
  }

  /// `Start`
  String get Start {
    return Intl.message('Start', name: 'Start', desc: '', args: []);
  }

  /// `Back`
  String get Back {
    return Intl.message('Back', name: 'Back', desc: '', args: []);
  }

  /// `Your Turn`
  String get Your_Turn {
    return Intl.message('Your Turn', name: 'Your_Turn', desc: '', args: []);
  }

  /// `AI is thinking`
  String get AI_is_thinking {
    return Intl.message(
      'AI is thinking',
      name: 'AI_is_thinking',
      desc: '',
      args: [],
    );
  }

  /// `Hints`
  String get Hints {
    return Intl.message('Hints', name: 'Hints', desc: '', args: []);
  }

  /// `Undo/Redo`
  String get Undo {
    return Intl.message('Undo/Redo', name: 'Undo', desc: '', args: []);
  }

  /// `Remove Ads`
  String get Remove_Ads {
    return Intl.message('Remove Ads', name: 'Remove_Ads', desc: '', args: []);
  }

  /// `Remove Ads {price}`
  String Remove_Ads_With_Price(Object price) {
    return Intl.message(
      'Remove Ads $price',
      name: 'Remove_Ads_With_Price',
      desc: '',
      args: [price],
    );
  }

  /// `Remove ads permanently from this app.`
  String get Remove_Ads_Description {
    return Intl.message(
      'Remove ads permanently from this app.',
      name: 'Remove_Ads_Description',
      desc: '',
      args: [],
    );
  }

  /// `Ads are removed on this device.`
  String get Remove_Ads_Purchased {
    return Intl.message(
      'Ads are removed on this device.',
      name: 'Remove_Ads_Purchased',
      desc: '',
      args: [],
    );
  }

  /// `Loading purchase options...`
  String get Remove_Ads_Loading {
    return Intl.message(
      'Loading purchase options...',
      name: 'Remove_Ads_Loading',
      desc: '',
      args: [],
    );
  }

  /// `Remove Ads is currently unavailable.`
  String get Remove_Ads_Unavailable {
    return Intl.message(
      'Remove Ads is currently unavailable.',
      name: 'Remove_Ads_Unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Restore Purchases`
  String get Restore_Purchases {
    return Intl.message(
      'Restore Purchases',
      name: 'Restore_Purchases',
      desc: '',
      args: [],
    );
  }

  /// `Purchase in progress...`
  String get Purchase_In_Progress {
    return Intl.message(
      'Purchase in progress...',
      name: 'Purchase_In_Progress',
      desc: '',
      args: [],
    );
  }

  /// `Purchase is pending approval.`
  String get Purchase_Pending {
    return Intl.message(
      'Purchase is pending approval.',
      name: 'Purchase_Pending',
      desc: '',
      args: [],
    );
  }

  /// `Purchase complete. Ads are removed.`
  String get Purchase_Success {
    return Intl.message(
      'Purchase complete. Ads are removed.',
      name: 'Purchase_Success',
      desc: '',
      args: [],
    );
  }

  /// `Purchase restored. Ads are removed.`
  String get Purchase_Restored {
    return Intl.message(
      'Purchase restored. Ads are removed.',
      name: 'Purchase_Restored',
      desc: '',
      args: [],
    );
  }

  /// `Purchase cancelled.`
  String get Purchase_Cancelled {
    return Intl.message(
      'Purchase cancelled.',
      name: 'Purchase_Cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Purchase failed. Please try again.`
  String get Purchase_Failed {
    return Intl.message(
      'Purchase failed. Please try again.',
      name: 'Purchase_Failed',
      desc: '',
      args: [],
    );
  }

  /// `No previous Remove Ads purchase was found.`
  String get Restore_Not_Found {
    return Intl.message(
      'No previous Remove Ads purchase was found.',
      name: 'Restore_Not_Found',
      desc: '',
      args: [],
    );
  }

  /// `You Lose`
  String get You_Lose {
    return Intl.message('You Lose', name: 'You_Lose', desc: '', args: []);
  }

  /// `You Win`
  String get You_Win {
    return Intl.message('You Win', name: 'You_Win', desc: '', args: []);
  }

  /// `White's turn`
  String get Whites_Turn {
    return Intl.message(
      'White\'s turn',
      name: 'Whites_Turn',
      desc: '',
      args: [],
    );
  }

  /// `Black's turn`
  String get Blacks_Turn {
    return Intl.message(
      'Black\'s turn',
      name: 'Blacks_Turn',
      desc: '',
      args: [],
    );
  }

  /// `Stalemate`
  String get Stalemate {
    return Intl.message('Stalemate', name: 'Stalemate', desc: '', args: []);
  }

  /// `White wins!`
  String get White_Wins {
    return Intl.message('White wins!', name: 'White_Wins', desc: '', args: []);
  }

  /// `Black wins!`
  String get Black_Wins {
    return Intl.message('Black wins!', name: 'Black_Wins', desc: '', args: []);
  }

  /// `More Apps`
  String get More_Apps {
    return Intl.message('More Apps', name: 'More_Apps', desc: '', args: []);
  }

  /// `World Weather Live`
  String get World_Weather_Live {
    return Intl.message(
      'World Weather Live',
      name: 'World_Weather_Live',
      desc: '',
      args: [],
    );
  }

  /// `Image Guru`
  String get Image_Guru {
    return Intl.message('Image Guru', name: 'Image_Guru', desc: '', args: []);
  }

  /// `We Play Piano`
  String get We_Play_Piano {
    return Intl.message(
      'We Play Piano',
      name: 'We_Play_Piano',
      desc: '',
      args: [],
    );
  }

  /// `Mint Translate`
  String get Mint_Translate {
    return Intl.message(
      'Mint Translate',
      name: 'Mint_Translate',
      desc: '',
      args: [],
    );
  }

  /// `Yes Habit`
  String get Yes_Habit {
    return Intl.message('Yes Habit', name: 'Yes_Habit', desc: '', args: []);
  }

  /// `Metronome Go`
  String get Metronome_Go {
    return Intl.message(
      'Metronome Go',
      name: 'Metronome_Go',
      desc: '',
      args: [],
    );
  }

  /// `Instant Face`
  String get Instant_Face {
    return Intl.message(
      'Instant Face',
      name: 'Instant_Face',
      desc: '',
      args: [],
    );
  }

  /// `Classical Music Box`
  String get Classical_Music_Box {
    return Intl.message(
      'Classical Music Box',
      name: 'Classical_Music_Box',
      desc: '',
      args: [],
    );
  }

  /// `Money Tracker`
  String get Money_Tracker {
    return Intl.message(
      'Money Tracker',
      name: 'Money_Tracker',
      desc: '',
      args: [],
    );
  }

  /// `Sudoku Lover`
  String get Sudoku_Lover {
    return Intl.message(
      'Sudoku Lover',
      name: 'Sudoku_Lover',
      desc: '',
      args: [],
    );
  }

  /// `Onlynote`
  String get Onlynote {
    return Intl.message('Onlynote', name: 'Onlynote', desc: '', args: []);
  }

  /// `Novels Hub`
  String get Novels_Hub {
    return Intl.message('Novels Hub', name: 'Novels_Hub', desc: '', args: []);
  }

  /// `Simple Calculator`
  String get Simple_Calculator {
    return Intl.message(
      'Simple Calculator',
      name: 'Simple_Calculator',
      desc: '',
      args: [],
    );
  }

  /// `Shows`
  String get Shows {
    return Intl.message('Shows', name: 'Shows', desc: '', args: []);
  }

  /// `Saving Ambulance`
  String get Saving_Ambulance {
    return Intl.message(
      'Saving Ambulance',
      name: 'Saving_Ambulance',
      desc: '',
      args: [],
    );
  }

  /// `Fling Knife`
  String get Fling_Knife {
    return Intl.message('Fling Knife', name: 'Fling_Knife', desc: '', args: []);
  }

  /// `Minesweeper Go`
  String get Minesweeper_Go {
    return Intl.message(
      'Minesweeper Go',
      name: 'Minesweeper_Go',
      desc: '',
      args: [],
    );
  }

  /// `Falling Block Puzzle`
  String get Falling_Block_Puzzle {
    return Intl.message(
      'Falling Block Puzzle',
      name: 'Falling_Block_Puzzle',
      desc: '',
      args: [],
    );
  }

  /// `Easy Unit`
  String get Easy_Unit {
    return Intl.message('Easy Unit', name: 'Easy_Unit', desc: '', args: []);
  }

  /// `Daily Puzzle`
  String get Daily_Puzzle {
    return Intl.message(
      'Daily Puzzle',
      name: 'Daily_Puzzle',
      desc: '',
      args: [],
    );
  }

  /// `Mate in One`
  String get Mate_In_One {
    return Intl.message('Mate in One', name: 'Mate_In_One', desc: '', args: []);
  }

  /// `White or black to move. Find checkmate in one.`
  String get Puzzle_Instruction {
    return Intl.message(
      'White or black to move. Find checkmate in one.',
      name: 'Puzzle_Instruction',
      desc: '',
      args: [],
    );
  }

  /// `Streak: {count}`
  String Puzzle_Streak(Object count) {
    return Intl.message(
      'Streak: $count',
      name: 'Puzzle_Streak',
      desc: '',
      args: [count],
    );
  }

  /// `Today's puzzle is complete.`
  String get Puzzle_Solved {
    return Intl.message(
      'Today\'s puzzle is complete.',
      name: 'Puzzle_Solved',
      desc: '',
      args: [],
    );
  }

  /// `Not quite — try again`
  String get Try_Again {
    return Intl.message(
      'Not quite — try again',
      name: 'Try_Again',
      desc: '',
      args: [],
    );
  }

  /// `Correct! Checkmate.`
  String get Correct {
    return Intl.message(
      'Correct! Checkmate.',
      name: 'Correct',
      desc: '',
      args: [],
    );
  }

  /// `Review Biggest Mistake`
  String get Review_Game {
    return Intl.message(
      'Review Biggest Mistake',
      name: 'Review_Game',
      desc: '',
      args: [],
    );
  }

  /// `Biggest Mistake`
  String get Biggest_Mistake {
    return Intl.message(
      'Biggest Mistake',
      name: 'Biggest_Mistake',
      desc: '',
      args: [],
    );
  }

  /// `Played`
  String get Played_Move {
    return Intl.message('Played', name: 'Played_Move', desc: '', args: []);
  }

  /// `Best move`
  String get Best_Move {
    return Intl.message('Best move', name: 'Best_Move', desc: '', args: []);
  }

  /// `Lost {value} pawns of evaluation`
  String Pawns_Lost(Object value) {
    return Intl.message(
      'Lost $value pawns of evaluation',
      name: 'Pawns_Lost',
      desc: '',
      args: [value],
    );
  }

  /// `Share Result`
  String get Share_Result {
    return Intl.message(
      'Share Result',
      name: 'Share_Result',
      desc: '',
      args: [],
    );
  }

  /// `Creating result card...`
  String get Sharing_Result {
    return Intl.message(
      'Creating result card...',
      name: 'Sharing_Result',
      desc: '',
      args: [],
    );
  }

  /// `{count} moves`
  String Move_Count(Object count) {
    return Intl.message(
      '$count moves',
      name: 'Move_Count',
      desc: '',
      args: [count],
    );
  }

  /// `Chess Room Result`
  String get Chess_Room_Result {
    return Intl.message(
      'Chess Room Result',
      name: 'Chess_Room_Result',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'HK'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
