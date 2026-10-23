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

  /// `Set Up AI Game`
  String get Vs_AI_Player {
    return Intl.message(
      'Set Up AI Game',
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

  /// `Privacy Choices`
  String get Privacy_Choices {
    return Intl.message(
      'Privacy Choices',
      name: 'Privacy_Choices',
      desc: '',
      args: [],
    );
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

  /// `No limit`
  String get No_Limit {
    return Intl.message('No limit', name: 'No_Limit', desc: '', args: []);
  }

  /// `{count} min`
  String Minute_Count(Object count) {
    return Intl.message(
      '$count min',
      name: 'Minute_Count',
      desc: '',
      args: [count],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message('Cancel', name: 'Cancel', desc: '', args: []);
  }

  /// `Done`
  String get Done {
    return Intl.message('Done', name: 'Done', desc: '', args: []);
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

  /// `Legal moves`
  String get Hints {
    return Intl.message('Legal moves', name: 'Hints', desc: '', args: []);
  }

  /// `Suggest a move`
  String get Tip {
    return Intl.message('Suggest a move', name: 'Tip', desc: '', args: []);
  }

  /// `Move suggestion button`
  String get Tip_Button {
    return Intl.message(
      'Move suggestion button',
      name: 'Tip_Button',
      desc: '',
      args: [],
    );
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

  /// `Review Game`
  String get Review_Game {
    return Intl.message('Review Game', name: 'Review_Game', desc: '', args: []);
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

  /// `Game History`
  String get Game_History {
    return Intl.message(
      'Game History',
      name: 'Game_History',
      desc: '',
      args: [],
    );
  }

  /// `Completed and imported games will appear here.`
  String get No_Saved_Games {
    return Intl.message(
      'Completed and imported games will appear here.',
      name: 'No_Saved_Games',
      desc: '',
      args: [],
    );
  }

  /// `Import PGN`
  String get Import_PGN {
    return Intl.message('Import PGN', name: 'Import_PGN', desc: '', args: []);
  }

  /// `Paste a PGN game`
  String get Paste_PGN {
    return Intl.message(
      'Paste a PGN game',
      name: 'Paste_PGN',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get Import {
    return Intl.message('Import', name: 'Import', desc: '', args: []);
  }

  /// `PGN imported successfully.`
  String get PGN_Imported {
    return Intl.message(
      'PGN imported successfully.',
      name: 'PGN_Imported',
      desc: '',
      args: [],
    );
  }

  /// `This PGN could not be imported.`
  String get PGN_Invalid {
    return Intl.message(
      'This PGN could not be imported.',
      name: 'PGN_Invalid',
      desc: '',
      args: [],
    );
  }

  /// `PGN copied to the clipboard.`
  String get PGN_Copied {
    return Intl.message(
      'PGN copied to the clipboard.',
      name: 'PGN_Copied',
      desc: '',
      args: [],
    );
  }

  /// `Copy PGN`
  String get Export_PGN {
    return Intl.message('Copy PGN', name: 'Export_PGN', desc: '', args: []);
  }

  /// `Replay`
  String get Replay {
    return Intl.message('Replay', name: 'Replay', desc: '', args: []);
  }

  /// `Game Replay`
  String get Game_Replay {
    return Intl.message('Game Replay', name: 'Game_Replay', desc: '', args: []);
  }

  /// `Move {current} of {total}`
  String Move_Of(Object current, Object total) {
    return Intl.message(
      'Move $current of $total',
      name: 'Move_Of',
      desc: '',
      args: [current, total],
    );
  }

  /// `Draw`
  String get Draw {
    return Intl.message('Draw', name: 'Draw', desc: '', args: []);
  }

  /// `Unfinished game`
  String get Unfinished {
    return Intl.message(
      'Unfinished game',
      name: 'Unfinished',
      desc: '',
      args: [],
    );
  }

  /// `Full Game Review`
  String get Full_Game_Review {
    return Intl.message(
      'Full Game Review',
      name: 'Full_Game_Review',
      desc: '',
      args: [],
    );
  }

  /// `Move {current} of {total}: {classification}`
  String Review_Move_Title(
    Object current,
    Object total,
    Object classification,
  ) {
    return Intl.message(
      'Move $current of $total: $classification',
      name: 'Review_Move_Title',
      desc: '',
      args: [current, total, classification],
    );
  }

  /// `Previous`
  String get Previous {
    return Intl.message('Previous', name: 'Previous', desc: '', args: []);
  }

  /// `Next`
  String get Next {
    return Intl.message('Next', name: 'Next', desc: '', args: []);
  }

  /// `Blunder`
  String get Blunder {
    return Intl.message('Blunder', name: 'Blunder', desc: '', args: []);
  }

  /// `Mistake`
  String get Mistake {
    return Intl.message('Mistake', name: 'Mistake', desc: '', args: []);
  }

  /// `Inaccuracy`
  String get Inaccuracy {
    return Intl.message('Inaccuracy', name: 'Inaccuracy', desc: '', args: []);
  }

  /// `Good move`
  String get Good_Move {
    return Intl.message('Good move', name: 'Good_Move', desc: '', args: []);
  }

  /// `This move loses significant material or allows a decisive attack.`
  String get Blunder_Explanation {
    return Intl.message(
      'This move loses significant material or allows a decisive attack.',
      name: 'Blunder_Explanation',
      desc: '',
      args: [],
    );
  }

  /// `A stronger move would have preserved a much better position.`
  String get Mistake_Explanation {
    return Intl.message(
      'A stronger move would have preserved a much better position.',
      name: 'Mistake_Explanation',
      desc: '',
      args: [],
    );
  }

  /// `This move gives away a small part of the position's advantage.`
  String get Inaccuracy_Explanation {
    return Intl.message(
      'This move gives away a small part of the position\'s advantage.',
      name: 'Inaccuracy_Explanation',
      desc: '',
      args: [],
    );
  }

  /// `This move stays close to the engine's best choice.`
  String get Good_Move_Explanation {
    return Intl.message(
      'This move stays close to the engine\'s best choice.',
      name: 'Good_Move_Explanation',
      desc: '',
      args: [],
    );
  }

  /// `Puzzle Library`
  String get Puzzle_Library {
    return Intl.message(
      'Puzzle Library',
      name: 'Puzzle_Library',
      desc: '',
      args: [],
    );
  }

  /// `Practice focused themes at your own pace. Progress is saved on this device.`
  String get Puzzle_Library_Description {
    return Intl.message(
      'Practice focused themes at your own pace. Progress is saved on this device.',
      name: 'Puzzle_Library_Description',
      desc: '',
      args: [],
    );
  }

  /// `Checkmate`
  String get Theme_Checkmate {
    return Intl.message(
      'Checkmate',
      name: 'Theme_Checkmate',
      desc: '',
      args: [],
    );
  }

  /// `Knight Forks`
  String get Theme_Forks {
    return Intl.message(
      'Knight Forks',
      name: 'Theme_Forks',
      desc: '',
      args: [],
    );
  }

  /// `Pawn Promotion`
  String get Theme_Promotion {
    return Intl.message(
      'Pawn Promotion',
      name: 'Theme_Promotion',
      desc: '',
      args: [],
    );
  }

  /// `{solved} of {total} solved`
  String Puzzles_Solved(Object solved, Object total) {
    return Intl.message(
      '$solved of $total solved',
      name: 'Puzzles_Solved',
      desc: '',
      args: [solved, total],
    );
  }

  /// `Puzzle {current} of {total}`
  String Puzzle_Number(Object current, Object total) {
    return Intl.message(
      'Puzzle $current of $total',
      name: 'Puzzle_Number',
      desc: '',
      args: [current, total],
    );
  }

  /// `Find the best move.`
  String get Find_Best_Move {
    return Intl.message(
      'Find the best move.',
      name: 'Find_Best_Move',
      desc: '',
      args: [],
    );
  }

  /// `Puzzle complete!`
  String get Puzzle_Complete {
    return Intl.message(
      'Puzzle complete!',
      name: 'Puzzle_Complete',
      desc: '',
      args: [],
    );
  }

  /// `Next Puzzle`
  String get Next_Puzzle {
    return Intl.message('Next Puzzle', name: 'Next_Puzzle', desc: '', args: []);
  }

  /// `Opening Trainer`
  String get Opening_Trainer {
    return Intl.message(
      'Opening Trainer',
      name: 'Opening_Trainer',
      desc: '',
      args: [],
    );
  }

  /// `Learn the ideas and first moves of five dependable openings.`
  String get Opening_Trainer_Description {
    return Intl.message(
      'Learn the ideas and first moves of five dependable openings.',
      name: 'Opening_Trainer_Description',
      desc: '',
      args: [],
    );
  }

  /// `Line complete! You played every move correctly.`
  String get Opening_Complete {
    return Intl.message(
      'Line complete! You played every move correctly.',
      name: 'Opening_Complete',
      desc: '',
      args: [],
    );
  }

  /// `Move {current} of {total}: play for {side}`
  String Opening_Move_Prompt(Object current, Object total, Object side) {
    return Intl.message(
      'Move $current of $total: play for $side',
      name: 'Opening_Move_Prompt',
      desc: '',
      args: [current, total, side],
    );
  }

  /// `That move is outside this training line. Try again.`
  String get Opening_Try_Again {
    return Intl.message(
      'That move is outside this training line. Try again.',
      name: 'Opening_Try_Again',
      desc: '',
      args: [],
    );
  }

  /// `Practice Again`
  String get Practice_Again {
    return Intl.message(
      'Practice Again',
      name: 'Practice_Again',
      desc: '',
      args: [],
    );
  }

  /// `Italian Game`
  String get Opening_Italian {
    return Intl.message(
      'Italian Game',
      name: 'Opening_Italian',
      desc: '',
      args: [],
    );
  }

  /// `Develop quickly and pressure the vulnerable f7 square.`
  String get Opening_Italian_Description {
    return Intl.message(
      'Develop quickly and pressure the vulnerable f7 square.',
      name: 'Opening_Italian_Description',
      desc: '',
      args: [],
    );
  }

  /// `Ruy Lopez`
  String get Opening_Ruy_Lopez {
    return Intl.message(
      'Ruy Lopez',
      name: 'Opening_Ruy_Lopez',
      desc: '',
      args: [],
    );
  }

  /// `Challenge Black's central defender with an early bishop pin.`
  String get Opening_Ruy_Lopez_Description {
    return Intl.message(
      'Challenge Black\'s central defender with an early bishop pin.',
      name: 'Opening_Ruy_Lopez_Description',
      desc: '',
      args: [],
    );
  }

  /// `Queen's Gambit`
  String get Opening_Queens_Gambit {
    return Intl.message(
      'Queen\'s Gambit',
      name: 'Opening_Queens_Gambit',
      desc: '',
      args: [],
    );
  }

  /// `Offer a wing pawn to build lasting central control.`
  String get Opening_Queens_Gambit_Description {
    return Intl.message(
      'Offer a wing pawn to build lasting central control.',
      name: 'Opening_Queens_Gambit_Description',
      desc: '',
      args: [],
    );
  }

  /// `Sicilian Defense`
  String get Opening_Sicilian {
    return Intl.message(
      'Sicilian Defense',
      name: 'Opening_Sicilian',
      desc: '',
      args: [],
    );
  }

  /// `Create an unbalanced fight against White's king-pawn opening.`
  String get Opening_Sicilian_Description {
    return Intl.message(
      'Create an unbalanced fight against White\'s king-pawn opening.',
      name: 'Opening_Sicilian_Description',
      desc: '',
      args: [],
    );
  }

  /// `London System`
  String get Opening_London {
    return Intl.message(
      'London System',
      name: 'Opening_London',
      desc: '',
      args: [],
    );
  }

  /// `Build a reliable setup with the dark-squared bishop outside the pawn chain.`
  String get Opening_London_Description {
    return Intl.message(
      'Build a reliable setup with the dark-squared bishop outside the pawn chain.',
      name: 'Opening_London_Description',
      desc: '',
      args: [],
    );
  }

  /// `Training`
  String get Training {
    return Intl.message('Training', name: 'Training', desc: '', args: []);
  }

  /// `Choose a focused puzzle session or learn a dependable opening line.`
  String get Training_Description {
    return Intl.message(
      'Choose a focused puzzle session or learn a dependable opening line.',
      name: 'Training_Description',
      desc: '',
      args: [],
    );
  }

  /// `How to Play Chess`
  String get How_To_Play_Chess {
    return Intl.message(
      'How to Play Chess',
      name: 'How_To_Play_Chess',
      desc: '',
      args: [],
    );
  }

  /// `Learn the essential rules, then use Training to practice your tactics and openings.`
  String get How_To_Play_Intro {
    return Intl.message(
      'Learn the essential rules, then use Training to practice your tactics and openings.',
      name: 'How_To_Play_Intro',
      desc: '',
      args: [],
    );
  }

  /// `The goal`
  String get Chess_Goal_Title {
    return Intl.message(
      'The goal',
      name: 'Chess_Goal_Title',
      desc: '',
      args: [],
    );
  }

  /// `Checkmate the opposing king. Checkmate means the king is under attack and has no legal way to escape.`
  String get Chess_Goal_Body {
    return Intl.message(
      'Checkmate the opposing king. Checkmate means the king is under attack and has no legal way to escape.',
      name: 'Chess_Goal_Body',
      desc: '',
      args: [],
    );
  }

  /// `Board setup`
  String get Chess_Setup_Title {
    return Intl.message(
      'Board setup',
      name: 'Chess_Setup_Title',
      desc: '',
      args: [],
    );
  }

  /// `Place the board with a light square at each player’s right. The back row is rook, knight, bishop, queen, king, bishop, knight, rook; the queen starts on her own color. Pawns fill the row in front. White moves first.`
  String get Chess_Setup_Body {
    return Intl.message(
      'Place the board with a light square at each player’s right. The back row is rook, knight, bishop, queen, king, bishop, knight, rook; the queen starts on her own color. Pawns fill the row in front. White moves first.',
      name: 'Chess_Setup_Body',
      desc: '',
      args: [],
    );
  }

  /// `How the pieces move`
  String get Chess_Pieces_Title {
    return Intl.message(
      'How the pieces move',
      name: 'Chess_Pieces_Title',
      desc: '',
      args: [],
    );
  }

  /// `King — moves one square in any direction and may never move into check.`
  String get Chess_King_Rule {
    return Intl.message(
      'King — moves one square in any direction and may never move into check.',
      name: 'Chess_King_Rule',
      desc: '',
      args: [],
    );
  }

  /// `Queen — moves any number of squares along a rank, file, or diagonal.`
  String get Chess_Queen_Rule {
    return Intl.message(
      'Queen — moves any number of squares along a rank, file, or diagonal.',
      name: 'Chess_Queen_Rule',
      desc: '',
      args: [],
    );
  }

  /// `Rook — moves any number of squares horizontally or vertically.`
  String get Chess_Rook_Rule {
    return Intl.message(
      'Rook — moves any number of squares horizontally or vertically.',
      name: 'Chess_Rook_Rule',
      desc: '',
      args: [],
    );
  }

  /// `Bishop — moves any number of squares diagonally.`
  String get Chess_Bishop_Rule {
    return Intl.message(
      'Bishop — moves any number of squares diagonally.',
      name: 'Chess_Bishop_Rule',
      desc: '',
      args: [],
    );
  }

  /// `Knight — moves in an L shape: two squares in one direction and one to the side. It can jump over pieces.`
  String get Chess_Knight_Rule {
    return Intl.message(
      'Knight — moves in an L shape: two squares in one direction and one to the side. It can jump over pieces.',
      name: 'Chess_Knight_Rule',
      desc: '',
      args: [],
    );
  }

  /// `Pawn — moves one square forward, or two from its starting square, and captures one square diagonally forward.`
  String get Chess_Pawn_Rule {
    return Intl.message(
      'Pawn — moves one square forward, or two from its starting square, and captures one square diagonally forward.',
      name: 'Chess_Pawn_Rule',
      desc: '',
      args: [],
    );
  }

  /// `Special moves`
  String get Chess_Special_Moves_Title {
    return Intl.message(
      'Special moves',
      name: 'Chess_Special_Moves_Title',
      desc: '',
      args: [],
    );
  }

  /// `Castling — move the king two squares toward a rook, then place that rook beside the king. Neither piece may have moved, the path must be clear, and the king cannot be in, cross through, or land in check.`
  String get Chess_Castling_Rule {
    return Intl.message(
      'Castling — move the king two squares toward a rook, then place that rook beside the king. Neither piece may have moved, the path must be clear, and the king cannot be in, cross through, or land in check.',
      name: 'Chess_Castling_Rule',
      desc: '',
      args: [],
    );
  }

  /// `En passant — a pawn may capture an adjacent enemy pawn that has just advanced two squares as though it moved only one. This is allowed only on the next move.`
  String get Chess_En_Passant_Rule {
    return Intl.message(
      'En passant — a pawn may capture an adjacent enemy pawn that has just advanced two squares as though it moved only one. This is allowed only on the next move.',
      name: 'Chess_En_Passant_Rule',
      desc: '',
      args: [],
    );
  }

  /// `Promotion — a pawn reaching the last rank becomes a queen, rook, bishop, or knight.`
  String get Chess_Promotion_Rule {
    return Intl.message(
      'Promotion — a pawn reaching the last rank becomes a queen, rook, bishop, or knight.',
      name: 'Chess_Promotion_Rule',
      desc: '',
      args: [],
    );
  }

  /// `Check and checkmate`
  String get Chess_Check_Title {
    return Intl.message(
      'Check and checkmate',
      name: 'Chess_Check_Title',
      desc: '',
      args: [],
    );
  }

  /// `When your king is in check, you must move the king, capture the attacking piece, or block the attack. If no legal response exists, it is checkmate and the game ends.`
  String get Chess_Check_Body {
    return Intl.message(
      'When your king is in check, you must move the king, capture the attacking piece, or block the attack. If no legal response exists, it is checkmate and the game ends.',
      name: 'Chess_Check_Body',
      desc: '',
      args: [],
    );
  }

  /// `Draws`
  String get Chess_Draws_Title {
    return Intl.message('Draws', name: 'Chess_Draws_Title', desc: '', args: []);
  }

  /// `A game can be drawn by stalemate, agreement, insufficient mating material, threefold repetition, or fifty moves by each side without a pawn move or capture.`
  String get Chess_Draws_Body {
    return Intl.message(
      'A game can be drawn by stalemate, agreement, insufficient mating material, threefold repetition, or fifty moves by each side without a pawn move or capture.',
      name: 'Chess_Draws_Body',
      desc: '',
      args: [],
    );
  }

  /// `Beginner tips`
  String get Chess_Tips_Title {
    return Intl.message(
      'Beginner tips',
      name: 'Chess_Tips_Title',
      desc: '',
      args: [],
    );
  }

  /// `Control the center, develop knights and bishops early, castle to protect your king, and check what your opponent threatens before every move.`
  String get Chess_Tips_Body {
    return Intl.message(
      'Control the center, develop knights and bishops early, castle to protect your king, and check what your opponent threatens before every move.',
      name: 'Chess_Tips_Body',
      desc: '',
      args: [],
    );
  }

  /// `Continue Game`
  String get Continue_Game {
    return Intl.message(
      'Continue Game',
      name: 'Continue_Game',
      desc: '',
      args: [],
    );
  }

  /// `Pick up where you left off`
  String get Continue_Game_Description {
    return Intl.message(
      'Pick up where you left off',
      name: 'Continue_Game_Description',
      desc: '',
      args: [],
    );
  }

  /// `Quick Play`
  String get Quick_Play {
    return Intl.message('Quick Play', name: 'Quick_Play', desc: '', args: []);
  }

  /// `Play AI with your last settings`
  String get Quick_Play_Description {
    return Intl.message(
      'Play AI with your last settings',
      name: 'Quick_Play_Description',
      desc: '',
      args: [],
    );
  }

  /// `Complete today · keep practicing`
  String get Daily_Practice_Complete {
    return Intl.message(
      'Complete today · keep practicing',
      name: 'Daily_Practice_Complete',
      desc: '',
      args: [],
    );
  }

  /// `A fresh challenge for today`
  String get Daily_Practice_Ready {
    return Intl.message(
      'A fresh challenge for today',
      name: 'Daily_Practice_Ready',
      desc: '',
      args: [],
    );
  }

  /// `Start a new game?`
  String get Replace_Unfinished_Game {
    return Intl.message(
      'Start a new game?',
      name: 'Replace_Unfinished_Game',
      desc: '',
      args: [],
    );
  }

  /// `Your unfinished game will be replaced.`
  String get Replace_Unfinished_Game_Description {
    return Intl.message(
      'Your unfinished game will be replaced.',
      name: 'Replace_Unfinished_Game_Description',
      desc: '',
      args: [],
    );
  }

  /// `This game could not be restored. You can start a new game.`
  String get Resume_Game_Unavailable {
    return Intl.message(
      'This game could not be restored. You can start a new game.',
      name: 'Resume_Game_Unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Easy`
  String get Puzzle_Easy {
    return Intl.message('Easy', name: 'Puzzle_Easy', desc: '', args: []);
  }

  /// `Medium`
  String get Puzzle_Medium {
    return Intl.message('Medium', name: 'Puzzle_Medium', desc: '', args: []);
  }

  /// `Hard`
  String get Puzzle_Hard {
    return Intl.message('Hard', name: 'Puzzle_Hard', desc: '', args: []);
  }

  /// `Back-rank mate`
  String get Theme_Back_Rank {
    return Intl.message(
      'Back-rank mate',
      name: 'Theme_Back_Rank',
      desc: '',
      args: [],
    );
  }

  /// `Knight mate`
  String get Theme_Knight_Mate {
    return Intl.message(
      'Knight mate',
      name: 'Theme_Knight_Mate',
      desc: '',
      args: [],
    );
  }

  /// `Double attack`
  String get Theme_Double_Attack {
    return Intl.message(
      'Double attack',
      name: 'Theme_Double_Attack',
      desc: '',
      args: [],
    );
  }

  /// `Keep practicing`
  String get Puzzle_Practice_Next {
    return Intl.message(
      'Keep practicing',
      name: 'Puzzle_Practice_Next',
      desc: '',
      args: [],
    );
  }

  /// `Continue the combination`
  String get Puzzle_Line_Progress {
    return Intl.message(
      'Continue the combination',
      name: 'Puzzle_Line_Progress',
      desc: '',
      args: [],
    );
  }

  /// `Why this works`
  String get Puzzle_Why_This_Works {
    return Intl.message(
      'Why this works',
      name: 'Puzzle_Why_This_Works',
      desc: '',
      args: [],
    );
  }

  /// `Coordinate your queen with your supporting pieces to cover every escape square.`
  String get Puzzle_Explain_Queen_Net {
    return Intl.message(
      'Coordinate your queen with your supporting pieces to cover every escape square.',
      name: 'Puzzle_Explain_Queen_Net',
      desc: '',
      args: [],
    );
  }

  /// `The pawns block the king’s escape. Check along the back rank to finish the game.`
  String get Puzzle_Explain_Back_Rank {
    return Intl.message(
      'The pawns block the king’s escape. Check along the back rank to finish the game.',
      name: 'Puzzle_Explain_Back_Rank',
      desc: '',
      args: [],
    );
  }

  /// `The knight checks the king while your other pieces cover its escape squares.`
  String get Puzzle_Explain_Knight_Mate {
    return Intl.message(
      'The knight checks the king while your other pieces cover its escape squares.',
      name: 'Puzzle_Explain_Knight_Mate',
      desc: '',
      args: [],
    );
  }

  /// `Check the king and attack another valuable piece at the same time.`
  String get Puzzle_Explain_Fork {
    return Intl.message(
      'Check the king and attack another valuable piece at the same time.',
      name: 'Puzzle_Explain_Fork',
      desc: '',
      args: [],
    );
  }

  /// `Promote the pawn safely to gain a queen.`
  String get Puzzle_Explain_Promotion {
    return Intl.message(
      'Promote the pawn safely to gain a queen.',
      name: 'Puzzle_Explain_Promotion',
      desc: '',
      args: [],
    );
  }

  /// `Cut off the king’s escape squares, then check along the edge of the board.`
  String get Puzzle_Explain_Rook_Mate {
    return Intl.message(
      'Cut off the king’s escape squares, then check along the edge of the board.',
      name: 'Puzzle_Explain_Rook_Mate',
      desc: '',
      args: [],
    );
  }

  /// `Coordinate the bishop with your other pieces to cover the king’s escape squares.`
  String get Puzzle_Explain_Bishop_Mate {
    return Intl.message(
      'Coordinate the bishop with your other pieces to cover the king’s escape squares.',
      name: 'Puzzle_Explain_Bishop_Mate',
      desc: '',
      args: [],
    );
  }

  /// `Use forcing checks to limit the replies, then finish with checkmate.`
  String get Puzzle_Explain_Combination {
    return Intl.message(
      'Use forcing checks to limit the replies, then finish with checkmate.',
      name: 'Puzzle_Explain_Combination',
      desc: '',
      args: [],
    );
  }

  /// `Queen mate`
  String get Theme_Queen_Net {
    return Intl.message(
      'Queen mate',
      name: 'Theme_Queen_Net',
      desc: '',
      args: [],
    );
  }

  /// `Rook mate`
  String get Theme_Rook_Mate {
    return Intl.message(
      'Rook mate',
      name: 'Theme_Rook_Mate',
      desc: '',
      args: [],
    );
  }

  /// `Bishop mate`
  String get Theme_Bishop_Mate {
    return Intl.message(
      'Bishop mate',
      name: 'Theme_Bishop_Mate',
      desc: '',
      args: [],
    );
  }

  /// `Mate in two`
  String get Mate_In_Two {
    return Intl.message('Mate in two', name: 'Mate_In_Two', desc: '', args: []);
  }

  /// `Combinations`
  String get Theme_Combination {
    return Intl.message(
      'Combinations',
      name: 'Theme_Combination',
      desc: '',
      args: [],
    );
  }

  /// `Chess Room`
  String get Chess_Room {
    return Intl.message('Chess Room', name: 'Chess_Room', desc: '', args: []);
  }

  /// `Play a game. Sharpen your next move.`
  String get Home_Subtitle {
    return Intl.message(
      'Play a game. Sharpen your next move.',
      name: 'Home_Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `More ways to play`
  String get Home_Play_Options {
    return Intl.message(
      'More ways to play',
      name: 'Home_Play_Options',
      desc: '',
      args: [],
    );
  }

  /// `Choose your level, side and clock`
  String get Home_AI_Description {
    return Intl.message(
      'Choose your level, side and clock',
      name: 'Home_AI_Description',
      desc: '',
      args: [],
    );
  }

  /// `Play together on one device`
  String get Home_Local_Description {
    return Intl.message(
      'Play together on one device',
      name: 'Home_Local_Description',
      desc: '',
      args: [],
    );
  }

  /// `Puzzles and guided openings`
  String get Home_Training_Description {
    return Intl.message(
      'Puzzles and guided openings',
      name: 'Home_Training_Description',
      desc: '',
      args: [],
    );
  }

  /// `Gameplay`
  String get Gameplay_Settings {
    return Intl.message(
      'Gameplay',
      name: 'Gameplay_Settings',
      desc: '',
      args: [],
    );
  }

  /// `Help & privacy`
  String get Help_And_Privacy {
    return Intl.message(
      'Help & privacy',
      name: 'Help_And_Privacy',
      desc: '',
      args: [],
    );
  }

  /// `Show legal destinations when you select a piece.`
  String get Hints_Description {
    return Intl.message(
      'Show legal destinations when you select a piece.',
      name: 'Hints_Description',
      desc: '',
      args: [],
    );
  }

  /// `Show a button that suggests a stronger move.`
  String get Tip_Button_Description {
    return Intl.message(
      'Show a button that suggests a stronger move.',
      name: 'Tip_Button_Description',
      desc: '',
      args: [],
    );
  }

  /// `Allow taking back and replaying moves.`
  String get Undo_Description {
    return Intl.message(
      'Allow taking back and replaying moves.',
      name: 'Undo_Description',
      desc: '',
      args: [],
    );
  }

  /// `Sound`
  String get Sound {
    return Intl.message('Sound', name: 'Sound', desc: '', args: []);
  }

  /// `Play sounds when pieces move.`
  String get Sound_Description {
    return Intl.message(
      'Play sounds when pieces move.',
      name: 'Sound_Description',
      desc: '',
      args: [],
    );
  }

  /// `Choose a comfortable challenge and make your first move.`
  String get Game_Setup_Description {
    return Intl.message(
      'Choose a comfortable challenge and make your first move.',
      name: 'Game_Setup_Description',
      desc: '',
      args: [],
    );
  }

  /// `Your progress`
  String get Training_Progress {
    return Intl.message(
      'Your progress',
      name: 'Training_Progress',
      desc: '',
      args: [],
    );
  }

  /// `Progress is temporarily unavailable. Please try again.`
  String get Training_Progress_Unavailable {
    return Intl.message(
      'Progress is temporarily unavailable. Please try again.',
      name: 'Training_Progress_Unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get Retry {
    return Intl.message('Retry', name: 'Retry', desc: '', args: []);
  }

  /// `{completed} of {total} puzzles completed`
  String Puzzles_Completed_Count(Object completed, Object total) {
    return Intl.message(
      '$completed of $total puzzles completed',
      name: 'Puzzles_Completed_Count',
      desc: '',
      args: [completed, total],
    );
  }

  /// `{completed} of {total} openings completed`
  String Openings_Completed_Count(Object completed, Object total) {
    return Intl.message(
      '$completed of $total openings completed',
      name: 'Openings_Completed_Count',
      desc: '',
      args: [completed, total],
    );
  }

  /// `Delete this game?`
  String get Delete_Game_Title {
    return Intl.message(
      'Delete this game?',
      name: 'Delete_Game_Title',
      desc: '',
      args: [],
    );
  }

  /// `This removes the saved game from this device. This cannot be undone.`
  String get Delete_Game_Message {
    return Intl.message(
      'This removes the saved game from this device. This cannot be undone.',
      name: 'Delete_Game_Message',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Delete {
    return Intl.message('Delete', name: 'Delete', desc: '', args: []);
  }

  /// `Flip board`
  String get Flip_Board {
    return Intl.message('Flip board', name: 'Flip_Board', desc: '', args: []);
  }

  /// `Previous move`
  String get Previous_Move {
    return Intl.message(
      'Previous move',
      name: 'Previous_Move',
      desc: '',
      args: [],
    );
  }

  /// `Next move`
  String get Next_Move {
    return Intl.message('Next move', name: 'Next_Move', desc: '', args: []);
  }

  /// `First move`
  String get First_Move {
    return Intl.message('First move', name: 'First_Move', desc: '', args: []);
  }

  /// `Last move`
  String get Last_Move {
    return Intl.message('Last move', name: 'Last_Move', desc: '', args: []);
  }

  /// `Undo move`
  String get Undo_Move {
    return Intl.message('Undo move', name: 'Undo_Move', desc: '', args: []);
  }

  /// `Redo move`
  String get Redo_Move {
    return Intl.message('Redo move', name: 'Redo_Move', desc: '', args: []);
  }

  /// `White`
  String get Clock_White {
    return Intl.message('White', name: 'Clock_White', desc: '', args: []);
  }

  /// `Black`
  String get Clock_Black {
    return Intl.message('Black', name: 'Clock_Black', desc: '', args: []);
  }

  /// `To move`
  String get Clock_Active {
    return Intl.message('To move', name: 'Clock_Active', desc: '', args: []);
  }

  /// `Board coordinates`
  String get Board_Coordinates {
    return Intl.message(
      'Board coordinates',
      name: 'Board_Coordinates',
      desc: '',
      args: [],
    );
  }

  /// `Show files and ranks around the board.`
  String get Board_Coordinates_Description {
    return Intl.message(
      'Show files and ranks around the board.',
      name: 'Board_Coordinates_Description',
      desc: '',
      args: [],
    );
  }

  /// `{piece} on {square}`
  String Piece_On_Square(Object piece, Object square) {
    return Intl.message(
      '$piece on $square',
      name: 'Piece_On_Square',
      desc: '',
      args: [piece, square],
    );
  }

  /// `Empty square {square}`
  String Empty_Square(Object square) {
    return Intl.message(
      'Empty square $square',
      name: 'Empty_Square',
      desc: '',
      args: [square],
    );
  }

  /// `White pawn`
  String get Piece_White_Pawn {
    return Intl.message(
      'White pawn',
      name: 'Piece_White_Pawn',
      desc: '',
      args: [],
    );
  }

  /// `White rook`
  String get Piece_White_Rook {
    return Intl.message(
      'White rook',
      name: 'Piece_White_Rook',
      desc: '',
      args: [],
    );
  }

  /// `White knight`
  String get Piece_White_Knight {
    return Intl.message(
      'White knight',
      name: 'Piece_White_Knight',
      desc: '',
      args: [],
    );
  }

  /// `White bishop`
  String get Piece_White_Bishop {
    return Intl.message(
      'White bishop',
      name: 'Piece_White_Bishop',
      desc: '',
      args: [],
    );
  }

  /// `White queen`
  String get Piece_White_Queen {
    return Intl.message(
      'White queen',
      name: 'Piece_White_Queen',
      desc: '',
      args: [],
    );
  }

  /// `White king`
  String get Piece_White_King {
    return Intl.message(
      'White king',
      name: 'Piece_White_King',
      desc: '',
      args: [],
    );
  }

  /// `Black pawn`
  String get Piece_Black_Pawn {
    return Intl.message(
      'Black pawn',
      name: 'Piece_Black_Pawn',
      desc: '',
      args: [],
    );
  }

  /// `Black rook`
  String get Piece_Black_Rook {
    return Intl.message(
      'Black rook',
      name: 'Piece_Black_Rook',
      desc: '',
      args: [],
    );
  }

  /// `Black knight`
  String get Piece_Black_Knight {
    return Intl.message(
      'Black knight',
      name: 'Piece_Black_Knight',
      desc: '',
      args: [],
    );
  }

  /// `Black bishop`
  String get Piece_Black_Bishop {
    return Intl.message(
      'Black bishop',
      name: 'Piece_Black_Bishop',
      desc: '',
      args: [],
    );
  }

  /// `Black queen`
  String get Piece_Black_Queen {
    return Intl.message(
      'Black queen',
      name: 'Piece_Black_Queen',
      desc: '',
      args: [],
    );
  }

  /// `Black king`
  String get Piece_Black_King {
    return Intl.message(
      'Black king',
      name: 'Piece_Black_King',
      desc: '',
      args: [],
    );
  }

  /// `One solution: {line}.`
  String Puzzle_Position_Line(Object line) {
    return Intl.message(
      'One solution: $line.',
      name: 'Puzzle_Position_Line',
      desc: '',
      args: [line],
    );
  }

  /// `{piece}: {from} → {to}.`
  String Puzzle_Position_Move(Object piece, Object from, Object to) {
    return Intl.message(
      '$piece: $from → $to.',
      name: 'Puzzle_Position_Move',
      desc: '',
      args: [piece, from, to],
    );
  }

  /// `Checkmate against the king on {square}: there is no legal escape, capture or block.`
  String Puzzle_Position_Mate(Object square) {
    return Intl.message(
      'Checkmate against the king on $square: there is no legal escape, capture or block.',
      name: 'Puzzle_Position_Mate',
      desc: '',
      args: [square],
    );
  }

  /// `Support: {piece} on {support} protects {square}.`
  String Puzzle_Position_Support(Object piece, Object support, Object square) {
    return Intl.message(
      'Support: $piece on $support protects $square.',
      name: 'Puzzle_Position_Support',
      desc: '',
      args: [piece, support, square],
    );
  }

  /// `Escape denied: {piece} on {support} covers {square}.`
  String Puzzle_Position_Escape(Object piece, Object support, Object square) {
    return Intl.message(
      'Escape denied: $piece on $support covers $square.',
      name: 'Puzzle_Position_Escape',
      desc: '',
      args: [piece, support, square],
    );
  }

  /// `The defending pawns on {squares} block their own king’s escape.`
  String Puzzle_Position_Pawns(Object squares) {
    return Intl.message(
      'The defending pawns on $squares block their own king’s escape.',
      name: 'Puzzle_Position_Pawns',
      desc: '',
      args: [squares],
    );
  }

  /// `From {from}, the knight checks the king on {king} and also attacks {target}.`
  String Puzzle_Position_Fork(Object from, Object king, Object target) {
    return Intl.message(
      'From $from, the knight checks the king on $king and also attacks $target.',
      name: 'Puzzle_Position_Fork',
      desc: '',
      args: [from, king, target],
    );
  }

  /// `The pawn reaches {square} and becomes {piece}.`
  String Puzzle_Position_Promotion(Object square, Object piece) {
    return Intl.message(
      'The pawn reaches $square and becomes $piece.',
      name: 'Puzzle_Position_Promotion',
      desc: '',
      args: [square, piece],
    );
  }

  /// `After {reply}, {finish} delivers checkmate.`
  String Puzzle_Position_Reply(Object reply, Object finish) {
    return Intl.message(
      'After $reply, $finish delivers checkmate.',
      name: 'Puzzle_Position_Reply',
      desc: '',
      args: [reply, finish],
    );
  }

  /// `Saved data is temporarily unavailable. Please try again.`
  String get Local_Data_Unavailable {
    return Intl.message(
      'Saved data is temporarily unavailable. Please try again.',
      name: 'Local_Data_Unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Could not delete this game. Please try again.`
  String get Delete_Game_Failed {
    return Intl.message(
      'Could not delete this game. Please try again.',
      name: 'Delete_Game_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Show hint`
  String get Puzzle_Hint {
    return Intl.message('Show hint', name: 'Puzzle_Hint', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'ja'),
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
