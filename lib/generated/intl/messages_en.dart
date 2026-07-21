// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) => "${count} min";

  static String m1(count) => "${count} moves";

  static String m2(current, total) => "Move ${current} of ${total}";

  static String m3(current, total, side) =>
      "Move ${current} of ${total}: play for ${side}";

  static String m4(value) => "Lost ${value} pawns of evaluation";

  static String m5(current, total) => "Puzzle ${current} of ${total}";

  static String m6(count) => "Streak: ${count}";

  static String m7(solved, total) => "${solved} of ${total} solved";

  static String m8(price) => "Remove Ads ${price}";

  static String m9(current, total, classification) =>
      "Move ${current} of ${total}: ${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage("AI Difficulty"),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage("AI is thinking"),
    "Back": MessageLookupByLibrary.simpleMessage("Back"),
    "Best_Move": MessageLookupByLibrary.simpleMessage("Best move"),
    "Biggest_Mistake": MessageLookupByLibrary.simpleMessage("Biggest Mistake"),
    "Black": MessageLookupByLibrary.simpleMessage("Black"),
    "Black_Wins": MessageLookupByLibrary.simpleMessage("Black wins!"),
    "Blacks_Turn": MessageLookupByLibrary.simpleMessage("Black\'s turn"),
    "Blunder": MessageLookupByLibrary.simpleMessage("Blunder"),
    "Blunder_Explanation": MessageLookupByLibrary.simpleMessage(
      "This move loses significant material or allows a decisive attack.",
    ),
    "Cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "Chess_Bishop_Rule": MessageLookupByLibrary.simpleMessage(
      "Bishop — moves any number of squares diagonally.",
    ),
    "Chess_Castling_Rule": MessageLookupByLibrary.simpleMessage(
      "Castling — move the king two squares toward a rook, then place that rook beside the king. Neither piece may have moved, the path must be clear, and the king cannot be in, cross through, or land in check.",
    ),
    "Chess_Check_Body": MessageLookupByLibrary.simpleMessage(
      "When your king is in check, you must move the king, capture the attacking piece, or block the attack. If no legal response exists, it is checkmate and the game ends.",
    ),
    "Chess_Check_Title": MessageLookupByLibrary.simpleMessage(
      "Check and checkmate",
    ),
    "Chess_Draws_Body": MessageLookupByLibrary.simpleMessage(
      "A game can be drawn by stalemate, agreement, insufficient mating material, threefold repetition, or fifty moves by each side without a pawn move or capture.",
    ),
    "Chess_Draws_Title": MessageLookupByLibrary.simpleMessage("Draws"),
    "Chess_En_Passant_Rule": MessageLookupByLibrary.simpleMessage(
      "En passant — a pawn may capture an adjacent enemy pawn that has just advanced two squares as though it moved only one. This is allowed only on the next move.",
    ),
    "Chess_Goal_Body": MessageLookupByLibrary.simpleMessage(
      "Checkmate the opposing king. Checkmate means the king is under attack and has no legal way to escape.",
    ),
    "Chess_Goal_Title": MessageLookupByLibrary.simpleMessage("The goal"),
    "Chess_King_Rule": MessageLookupByLibrary.simpleMessage(
      "King — moves one square in any direction and may never move into check.",
    ),
    "Chess_Knight_Rule": MessageLookupByLibrary.simpleMessage(
      "Knight — moves in an L shape: two squares in one direction and one to the side. It can jump over pieces.",
    ),
    "Chess_Pawn_Rule": MessageLookupByLibrary.simpleMessage(
      "Pawn — moves one square forward, or two from its starting square, and captures one square diagonally forward.",
    ),
    "Chess_Pieces_Title": MessageLookupByLibrary.simpleMessage(
      "How the pieces move",
    ),
    "Chess_Promotion_Rule": MessageLookupByLibrary.simpleMessage(
      "Promotion — a pawn reaching the last rank becomes a queen, rook, bishop, or knight.",
    ),
    "Chess_Queen_Rule": MessageLookupByLibrary.simpleMessage(
      "Queen — moves any number of squares along a rank, file, or diagonal.",
    ),
    "Chess_Rook_Rule": MessageLookupByLibrary.simpleMessage(
      "Rook — moves any number of squares horizontally or vertically.",
    ),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "Chess Room Result",
    ),
    "Chess_Setup_Body": MessageLookupByLibrary.simpleMessage(
      "Place the board with a light square at each player’s right. The back row is rook, knight, bishop, queen, king, bishop, knight, rook; the queen starts on her own color. Pawns fill the row in front. White moves first.",
    ),
    "Chess_Setup_Title": MessageLookupByLibrary.simpleMessage("Board setup"),
    "Chess_Special_Moves_Title": MessageLookupByLibrary.simpleMessage(
      "Special moves",
    ),
    "Chess_Tips_Body": MessageLookupByLibrary.simpleMessage(
      "Control the center, develop knights and bishops early, castle to protect your king, and check what your opponent threatens before every move.",
    ),
    "Chess_Tips_Title": MessageLookupByLibrary.simpleMessage("Beginner tips"),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage(
      "Classical Music Box",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("Correct! Checkmate."),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("Daily Puzzle"),
    "Done": MessageLookupByLibrary.simpleMessage("Done"),
    "Draw": MessageLookupByLibrary.simpleMessage("Draw"),
    "Easy": MessageLookupByLibrary.simpleMessage("Easy"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("Easy Unit"),
    "Export_PGN": MessageLookupByLibrary.simpleMessage("Copy PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("Extreme"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage(
      "Falling Block Puzzle",
    ),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage(
      "Find the best move.",
    ),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("Fling Knife"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage(
      "Full Game Review",
    ),
    "Game_History": MessageLookupByLibrary.simpleMessage("Game History"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("Game Replay"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("Good move"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "This move stays close to the engine\'s best choice.",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("Hard"),
    "Hints": MessageLookupByLibrary.simpleMessage("Hints"),
    "How_To_Play_Chess": MessageLookupByLibrary.simpleMessage(
      "How to Play Chess",
    ),
    "How_To_Play_Intro": MessageLookupByLibrary.simpleMessage(
      "Learn the essential rules, then use Training to practice your tactics and openings.",
    ),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("Image Guru"),
    "Import": MessageLookupByLibrary.simpleMessage("Import"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("Import PGN"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("Inaccuracy"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "This move gives away a small part of the position\'s advantage.",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("Instant Face"),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("Mate in One"),
    "Medium": MessageLookupByLibrary.simpleMessage("Medium"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("Metronome Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("Minesweeper Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("Mint Translate"),
    "Minute_Count": m0,
    "Mistake": MessageLookupByLibrary.simpleMessage("Mistake"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "A stronger move would have preserved a much better position.",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("Money Tracker"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("More Apps"),
    "Move_Count": m1,
    "Move_Of": m2,
    "Next": MessageLookupByLibrary.simpleMessage("Next"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("Next Puzzle"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("No limit"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage(
      "Completed and imported games will appear here.",
    ),
    "Novels_Hub": MessageLookupByLibrary.simpleMessage("Novels Hub"),
    "Onlynote": MessageLookupByLibrary.simpleMessage("Onlynote"),
    "Opening_Complete": MessageLookupByLibrary.simpleMessage(
      "Line complete! You played every move correctly.",
    ),
    "Opening_Italian": MessageLookupByLibrary.simpleMessage("Italian Game"),
    "Opening_Italian_Description": MessageLookupByLibrary.simpleMessage(
      "Develop quickly and pressure the vulnerable f7 square.",
    ),
    "Opening_London": MessageLookupByLibrary.simpleMessage("London System"),
    "Opening_London_Description": MessageLookupByLibrary.simpleMessage(
      "Build a reliable setup with the dark-squared bishop outside the pawn chain.",
    ),
    "Opening_Move_Prompt": m3,
    "Opening_Queens_Gambit": MessageLookupByLibrary.simpleMessage(
      "Queen\'s Gambit",
    ),
    "Opening_Queens_Gambit_Description": MessageLookupByLibrary.simpleMessage(
      "Offer a wing pawn to build lasting central control.",
    ),
    "Opening_Ruy_Lopez": MessageLookupByLibrary.simpleMessage("Ruy Lopez"),
    "Opening_Ruy_Lopez_Description": MessageLookupByLibrary.simpleMessage(
      "Challenge Black\'s central defender with an early bishop pin.",
    ),
    "Opening_Sicilian": MessageLookupByLibrary.simpleMessage(
      "Sicilian Defense",
    ),
    "Opening_Sicilian_Description": MessageLookupByLibrary.simpleMessage(
      "Create an unbalanced fight against White\'s king-pawn opening.",
    ),
    "Opening_Trainer": MessageLookupByLibrary.simpleMessage("Opening Trainer"),
    "Opening_Trainer_Description": MessageLookupByLibrary.simpleMessage(
      "Learn the ideas and first moves of five dependable openings.",
    ),
    "Opening_Try_Again": MessageLookupByLibrary.simpleMessage(
      "That move is outside this training line. Try again.",
    ),
    "PGN_Copied": MessageLookupByLibrary.simpleMessage(
      "PGN copied to the clipboard.",
    ),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage(
      "PGN imported successfully.",
    ),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage(
      "This PGN could not be imported.",
    ),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("Paste a PGN game"),
    "Pawns_Lost": m4,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("Pick Your Side"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("Played"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("Practice Again"),
    "Previous": MessageLookupByLibrary.simpleMessage("Previous"),
    "Purchase_Cancelled": MessageLookupByLibrary.simpleMessage(
      "Purchase cancelled.",
    ),
    "Purchase_Failed": MessageLookupByLibrary.simpleMessage(
      "Purchase failed. Please try again.",
    ),
    "Purchase_In_Progress": MessageLookupByLibrary.simpleMessage(
      "Purchase in progress...",
    ),
    "Purchase_Pending": MessageLookupByLibrary.simpleMessage(
      "Purchase is pending approval.",
    ),
    "Purchase_Restored": MessageLookupByLibrary.simpleMessage(
      "Purchase restored. Ads are removed.",
    ),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage(
      "Purchase complete. Ads are removed.",
    ),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage("Puzzle complete!"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "White or black to move. Find checkmate in one.",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("Puzzle Library"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "Practice focused themes at your own pace. Progress is saved on this device.",
    ),
    "Puzzle_Number": m5,
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage(
      "Today\'s puzzle is complete.",
    ),
    "Puzzle_Streak": m6,
    "Puzzles_Solved": m7,
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("Remove Ads"),
    "Remove_Ads_Description": MessageLookupByLibrary.simpleMessage(
      "Remove ads permanently from this app.",
    ),
    "Remove_Ads_Loading": MessageLookupByLibrary.simpleMessage(
      "Loading purchase options...",
    ),
    "Remove_Ads_Purchased": MessageLookupByLibrary.simpleMessage(
      "Ads are removed on this device.",
    ),
    "Remove_Ads_Unavailable": MessageLookupByLibrary.simpleMessage(
      "Remove Ads is currently unavailable.",
    ),
    "Remove_Ads_With_Price": m8,
    "Replay": MessageLookupByLibrary.simpleMessage("Replay"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "No previous Remove Ads purchase was found.",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage(
      "Restore Purchases",
    ),
    "Review_Game": MessageLookupByLibrary.simpleMessage(
      "Review Biggest Mistake",
    ),
    "Review_Move_Title": m9,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage(
      "Saving Ambulance",
    ),
    "Settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "Share_Result": MessageLookupByLibrary.simpleMessage("Share Result"),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage(
      "Creating result card...",
    ),
    "Shows": MessageLookupByLibrary.simpleMessage("Shows"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage(
      "Simple Calculator",
    ),
    "Stalemate": MessageLookupByLibrary.simpleMessage("Stalemate"),
    "Start": MessageLookupByLibrary.simpleMessage("Start"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("Sudoku Lover"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("Checkmate"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("Knight Forks"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("Pawn Promotion"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("Time Limit"),
    "Tip": MessageLookupByLibrary.simpleMessage("Tip"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("Show Tip Button"),
    "Training": MessageLookupByLibrary.simpleMessage("Training"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "Choose a focused puzzle session or learn a dependable opening line.",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage("Not quite — try again"),
    "Two_Players": MessageLookupByLibrary.simpleMessage("Two Players"),
    "Undo": MessageLookupByLibrary.simpleMessage("Undo/Redo"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("Unfinished game"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("Vs AI Player"),
    "We_Play_Piano": MessageLookupByLibrary.simpleMessage("We Play Piano"),
    "White": MessageLookupByLibrary.simpleMessage("White"),
    "White_Wins": MessageLookupByLibrary.simpleMessage("White wins!"),
    "Whites_Turn": MessageLookupByLibrary.simpleMessage("White\'s turn"),
    "World_Weather_Live": MessageLookupByLibrary.simpleMessage(
      "World Weather Live",
    ),
    "Yes_Habit": MessageLookupByLibrary.simpleMessage("Yes Habit"),
    "You_Lose": MessageLookupByLibrary.simpleMessage("You Lose"),
    "You_Win": MessageLookupByLibrary.simpleMessage("You Win"),
    "Your_Turn": MessageLookupByLibrary.simpleMessage("Your Turn"),
  };
}
