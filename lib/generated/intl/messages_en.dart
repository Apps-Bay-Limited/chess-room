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

  static String m0(square) => "Empty square ${square}";

  static String m1(count) => "${count} min";

  static String m2(count) => "${count} moves";

  static String m3(current, total) => "Move ${current} of ${total}";

  static String m4(current, total, side) =>
      "Move ${current} of ${total}: play for ${side}";

  static String m5(completed, total) =>
      "${completed} of ${total} openings completed";

  static String m6(value) => "Lost ${value} pawns of evaluation";

  static String m7(piece, square) => "${piece} on ${square}";

  static String m8(count) => "${count} older games are kept with Premium.";

  static String m9(count) => "${count} free puzzles left today";

  static String m10(count) => "${count} free game reviews left today";

  static String m11(price) => "Unlock Premium ${price}";

  static String m12(current, total) => "Puzzle ${current} of ${total}";

  static String m13(piece, support, square) =>
      "Escape denied: ${piece} on ${support} covers ${square}.";

  static String m14(from, king, target) =>
      "From ${from}, the knight checks the king on ${king} and also attacks ${target}.";

  static String m15(line) => "One solution: ${line}.";

  static String m16(square) =>
      "Checkmate against the king on ${square}: there is no legal escape, capture or block.";

  static String m17(piece, from, to) => "${piece}: ${from} → ${to}.";

  static String m18(squares) =>
      "The defending pawns on ${squares} block their own king’s escape.";

  static String m19(square, piece) =>
      "The pawn reaches ${square} and becomes ${piece}.";

  static String m20(reply, finish) =>
      "After ${reply}, ${finish} delivers checkmate.";

  static String m21(piece, support, square) =>
      "Support: ${piece} on ${support} protects ${square}.";

  static String m22(count) => "Streak: ${count}";

  static String m23(completed, total) =>
      "${completed} of ${total} puzzles completed";

  static String m24(solved, total) => "${solved} of ${total} solved";

  static String m25(current, total, classification) =>
      "Move ${current} of ${total}: ${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage("AI Difficulty"),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage("AI is thinking"),
    "Appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
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
    "Board_Coordinates": MessageLookupByLibrary.simpleMessage(
      "Board coordinates",
    ),
    "Board_Coordinates_Description": MessageLookupByLibrary.simpleMessage(
      "Show files and ranks around the board.",
    ),
    "Board_Theme": MessageLookupByLibrary.simpleMessage("Board theme"),
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
    "Chess_Room": MessageLookupByLibrary.simpleMessage("Chess Room"),
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
    "Clock_Active": MessageLookupByLibrary.simpleMessage("To move"),
    "Clock_Black": MessageLookupByLibrary.simpleMessage("Black"),
    "Clock_White": MessageLookupByLibrary.simpleMessage("White"),
    "Continue_Game": MessageLookupByLibrary.simpleMessage("Continue Game"),
    "Continue_Game_Description": MessageLookupByLibrary.simpleMessage(
      "Pick up where you left off",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("Correct! Checkmate."),
    "Daily_Practice_Complete": MessageLookupByLibrary.simpleMessage(
      "Complete today · keep practicing",
    ),
    "Daily_Practice_Ready": MessageLookupByLibrary.simpleMessage(
      "A fresh challenge for today",
    ),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("Daily Puzzle"),
    "Delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "Delete_Game_Failed": MessageLookupByLibrary.simpleMessage(
      "Could not delete this game. Please try again.",
    ),
    "Delete_Game_Message": MessageLookupByLibrary.simpleMessage(
      "This removes the saved game from this device. This cannot be undone.",
    ),
    "Delete_Game_Title": MessageLookupByLibrary.simpleMessage(
      "Delete this game?",
    ),
    "Done": MessageLookupByLibrary.simpleMessage("Done"),
    "Draw": MessageLookupByLibrary.simpleMessage("Draw"),
    "Easy": MessageLookupByLibrary.simpleMessage("Easy"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("Easy Unit"),
    "Empty_Square": m0,
    "Export_PGN": MessageLookupByLibrary.simpleMessage("Copy PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("Extreme"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage(
      "Falling Block Puzzle",
    ),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage(
      "Find the best move.",
    ),
    "First_Move": MessageLookupByLibrary.simpleMessage("First move"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("Fling Knife"),
    "Flip_Board": MessageLookupByLibrary.simpleMessage("Flip board"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage(
      "Full Game Review",
    ),
    "Game_History": MessageLookupByLibrary.simpleMessage("Game History"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("Game Replay"),
    "Game_Setup_Description": MessageLookupByLibrary.simpleMessage(
      "Choose a comfortable challenge and make your first move.",
    ),
    "Gameplay_Settings": MessageLookupByLibrary.simpleMessage("Gameplay"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("Good move"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "This move stays close to the engine\'s best choice.",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("Hard"),
    "Help_And_Privacy": MessageLookupByLibrary.simpleMessage("Help & privacy"),
    "Hints": MessageLookupByLibrary.simpleMessage("Legal moves"),
    "Hints_Description": MessageLookupByLibrary.simpleMessage(
      "Show legal destinations when you select a piece.",
    ),
    "Home_AI_Description": MessageLookupByLibrary.simpleMessage(
      "Choose your level, side and clock",
    ),
    "Home_Local_Description": MessageLookupByLibrary.simpleMessage(
      "Play together on one device",
    ),
    "Home_Play_Options": MessageLookupByLibrary.simpleMessage(
      "More ways to play",
    ),
    "Home_Subtitle": MessageLookupByLibrary.simpleMessage(
      "Play a game. Sharpen your next move.",
    ),
    "Home_Training_Description": MessageLookupByLibrary.simpleMessage(
      "Puzzles and guided openings",
    ),
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
    "Last_Move": MessageLookupByLibrary.simpleMessage("Last move"),
    "Local_Data_Unavailable": MessageLookupByLibrary.simpleMessage(
      "Saved data is temporarily unavailable. Please try again.",
    ),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("Mate in One"),
    "Mate_In_Two": MessageLookupByLibrary.simpleMessage("Mate in two"),
    "Medium": MessageLookupByLibrary.simpleMessage("Medium"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("Metronome Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("Minesweeper Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("Mint Translate"),
    "Minute_Count": m1,
    "Mistake": MessageLookupByLibrary.simpleMessage("Mistake"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "A stronger move would have preserved a much better position.",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("Money Tracker"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("More Apps"),
    "Move_Count": m2,
    "Move_Of": m3,
    "Next": MessageLookupByLibrary.simpleMessage("Next"),
    "Next_Move": MessageLookupByLibrary.simpleMessage("Next move"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("Next Puzzle"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("No limit"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage(
      "Completed and imported games will appear here.",
    ),
    "Not_Now": MessageLookupByLibrary.simpleMessage("Not now"),
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
    "Opening_Move_Prompt": m4,
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
    "Openings_Completed_Count": m5,
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
    "Pawns_Lost": m6,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("Pick Your Side"),
    "Piece_Black_Bishop": MessageLookupByLibrary.simpleMessage("Black bishop"),
    "Piece_Black_King": MessageLookupByLibrary.simpleMessage("Black king"),
    "Piece_Black_Knight": MessageLookupByLibrary.simpleMessage("Black knight"),
    "Piece_Black_Pawn": MessageLookupByLibrary.simpleMessage("Black pawn"),
    "Piece_Black_Queen": MessageLookupByLibrary.simpleMessage("Black queen"),
    "Piece_Black_Rook": MessageLookupByLibrary.simpleMessage("Black rook"),
    "Piece_On_Square": m7,
    "Piece_Set": MessageLookupByLibrary.simpleMessage("Piece set"),
    "Piece_White_Bishop": MessageLookupByLibrary.simpleMessage("White bishop"),
    "Piece_White_King": MessageLookupByLibrary.simpleMessage("White king"),
    "Piece_White_Knight": MessageLookupByLibrary.simpleMessage("White knight"),
    "Piece_White_Pawn": MessageLookupByLibrary.simpleMessage("White pawn"),
    "Piece_White_Queen": MessageLookupByLibrary.simpleMessage("White queen"),
    "Piece_White_Rook": MessageLookupByLibrary.simpleMessage("White rook"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("Played"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("Practice Again"),
    "Premium": MessageLookupByLibrary.simpleMessage("Premium"),
    "Premium_Active": MessageLookupByLibrary.simpleMessage(
      "Premium is active on this device.",
    ),
    "Premium_Benefit_History": MessageLookupByLibrary.simpleMessage(
      "Your complete game archive",
    ),
    "Premium_Benefit_No_Ads": MessageLookupByLibrary.simpleMessage("No ads"),
    "Premium_Benefit_Play": MessageLookupByLibrary.simpleMessage(
      "Restores with your Google Play account",
    ),
    "Premium_Benefit_Review": MessageLookupByLibrary.simpleMessage(
      "Unlimited game review",
    ),
    "Premium_Benefit_Shared": MessageLookupByLibrary.simpleMessage(
      "One purchase covers iPhone, iPad and Mac",
    ),
    "Premium_Benefit_Themes": MessageLookupByLibrary.simpleMessage(
      "Every board theme and piece set",
    ),
    "Premium_Benefit_Training": MessageLookupByLibrary.simpleMessage(
      "Unlimited library puzzles and every opening course",
    ),
    "Premium_Description": MessageLookupByLibrary.simpleMessage(
      "One purchase unlocks every theme, unlimited training and your full game archive — and removes ads.",
    ),
    "Premium_Loading": MessageLookupByLibrary.simpleMessage(
      "Loading purchase options...",
    ),
    "Premium_Locked_Board_Theme": MessageLookupByLibrary.simpleMessage(
      "This board theme is part of Premium.",
    ),
    "Premium_Locked_History": m8,
    "Premium_Locked_Opening": MessageLookupByLibrary.simpleMessage(
      "This opening course is part of Premium.",
    ),
    "Premium_Locked_Piece_Theme": MessageLookupByLibrary.simpleMessage(
      "This piece set is part of Premium.",
    ),
    "Premium_Puzzles_Left": m9,
    "Premium_Puzzles_Spent": MessageLookupByLibrary.simpleMessage(
      "You have used today’s free library puzzles.",
    ),
    "Premium_Reviews_Left": m10,
    "Premium_Reviews_Spent": MessageLookupByLibrary.simpleMessage(
      "You have used today’s free game reviews.",
    ),
    "Premium_Unavailable": MessageLookupByLibrary.simpleMessage(
      "Premium is currently unavailable.",
    ),
    "Premium_Unlimited": MessageLookupByLibrary.simpleMessage(
      "Unlimited with Premium",
    ),
    "Premium_Unlock": MessageLookupByLibrary.simpleMessage("Unlock Premium"),
    "Premium_Unlock_With_Price": m11,
    "Previous": MessageLookupByLibrary.simpleMessage("Previous"),
    "Previous_Move": MessageLookupByLibrary.simpleMessage("Previous move"),
    "Privacy_Choices": MessageLookupByLibrary.simpleMessage("Privacy Choices"),
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
      "Purchase restored. Premium is unlocked.",
    ),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage(
      "Purchase complete. Premium is unlocked.",
    ),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage("Puzzle complete!"),
    "Puzzle_Easy": MessageLookupByLibrary.simpleMessage("Easy"),
    "Puzzle_Explain_Back_Rank": MessageLookupByLibrary.simpleMessage(
      "The pawns block the king’s escape. Check along the back rank to finish the game.",
    ),
    "Puzzle_Explain_Bishop_Mate": MessageLookupByLibrary.simpleMessage(
      "Coordinate the bishop with your other pieces to cover the king’s escape squares.",
    ),
    "Puzzle_Explain_Combination": MessageLookupByLibrary.simpleMessage(
      "Use forcing checks to limit the replies, then finish with checkmate.",
    ),
    "Puzzle_Explain_Fork": MessageLookupByLibrary.simpleMessage(
      "Check the king and attack another valuable piece at the same time.",
    ),
    "Puzzle_Explain_Knight_Mate": MessageLookupByLibrary.simpleMessage(
      "The knight checks the king while your other pieces cover its escape squares.",
    ),
    "Puzzle_Explain_Promotion": MessageLookupByLibrary.simpleMessage(
      "Promote the pawn safely to gain a queen.",
    ),
    "Puzzle_Explain_Queen_Net": MessageLookupByLibrary.simpleMessage(
      "Coordinate your queen with your supporting pieces to cover every escape square.",
    ),
    "Puzzle_Explain_Rook_Mate": MessageLookupByLibrary.simpleMessage(
      "Cut off the king’s escape squares, then check along the edge of the board.",
    ),
    "Puzzle_Hard": MessageLookupByLibrary.simpleMessage("Hard"),
    "Puzzle_Hint": MessageLookupByLibrary.simpleMessage("Show hint"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "White or black to move. Find checkmate in one.",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("Puzzle Library"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "Practice focused themes at your own pace. Progress is saved on this device.",
    ),
    "Puzzle_Line_Progress": MessageLookupByLibrary.simpleMessage(
      "Continue the combination",
    ),
    "Puzzle_Medium": MessageLookupByLibrary.simpleMessage("Medium"),
    "Puzzle_Number": m12,
    "Puzzle_Position_Escape": m13,
    "Puzzle_Position_Fork": m14,
    "Puzzle_Position_Line": m15,
    "Puzzle_Position_Mate": m16,
    "Puzzle_Position_Move": m17,
    "Puzzle_Position_Pawns": m18,
    "Puzzle_Position_Promotion": m19,
    "Puzzle_Position_Reply": m20,
    "Puzzle_Position_Support": m21,
    "Puzzle_Practice_Next": MessageLookupByLibrary.simpleMessage(
      "Keep practicing",
    ),
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage(
      "Today\'s puzzle is complete.",
    ),
    "Puzzle_Streak": m22,
    "Puzzle_Why_This_Works": MessageLookupByLibrary.simpleMessage(
      "Why this works",
    ),
    "Puzzles_Completed_Count": m23,
    "Puzzles_Solved": m24,
    "Quick_Play": MessageLookupByLibrary.simpleMessage("Quick Play"),
    "Quick_Play_Description": MessageLookupByLibrary.simpleMessage(
      "Play AI with your last settings",
    ),
    "Redo_Move": MessageLookupByLibrary.simpleMessage("Redo move"),
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("Remove Ads"),
    "Replace_Unfinished_Game": MessageLookupByLibrary.simpleMessage(
      "Start a new game?",
    ),
    "Replace_Unfinished_Game_Description": MessageLookupByLibrary.simpleMessage(
      "Your unfinished game will be replaced.",
    ),
    "Replay": MessageLookupByLibrary.simpleMessage("Replay"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "No previous Premium purchase was found.",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage(
      "Restore Purchases",
    ),
    "Resume_Game_Unavailable": MessageLookupByLibrary.simpleMessage(
      "This game could not be restored. You can start a new game.",
    ),
    "Retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("Review Game"),
    "Review_Move_Title": m25,
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
    "Sound": MessageLookupByLibrary.simpleMessage("Sound"),
    "Sound_Description": MessageLookupByLibrary.simpleMessage(
      "Play sounds when pieces move.",
    ),
    "Stalemate": MessageLookupByLibrary.simpleMessage("Stalemate"),
    "Start": MessageLookupByLibrary.simpleMessage("Start"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("Sudoku Lover"),
    "Theme_Back_Rank": MessageLookupByLibrary.simpleMessage("Back-rank mate"),
    "Theme_Bishop_Mate": MessageLookupByLibrary.simpleMessage("Bishop mate"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("Checkmate"),
    "Theme_Combination": MessageLookupByLibrary.simpleMessage("Combinations"),
    "Theme_Double_Attack": MessageLookupByLibrary.simpleMessage(
      "Double attack",
    ),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("Knight Forks"),
    "Theme_Knight_Mate": MessageLookupByLibrary.simpleMessage("Knight mate"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("Pawn Promotion"),
    "Theme_Queen_Net": MessageLookupByLibrary.simpleMessage("Queen mate"),
    "Theme_Rook_Mate": MessageLookupByLibrary.simpleMessage("Rook mate"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("Time Limit"),
    "Tip": MessageLookupByLibrary.simpleMessage("Suggest a move"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage(
      "Move suggestion button",
    ),
    "Tip_Button_Description": MessageLookupByLibrary.simpleMessage(
      "Show a button that suggests a stronger move.",
    ),
    "Training": MessageLookupByLibrary.simpleMessage("Training"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "Choose a focused puzzle session or learn a dependable opening line.",
    ),
    "Training_Progress": MessageLookupByLibrary.simpleMessage("Your progress"),
    "Training_Progress_Unavailable": MessageLookupByLibrary.simpleMessage(
      "Progress is temporarily unavailable. Please try again.",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage("Not quite — try again"),
    "Two_Players": MessageLookupByLibrary.simpleMessage("Two Players"),
    "Undo": MessageLookupByLibrary.simpleMessage("Undo/Redo"),
    "Undo_Description": MessageLookupByLibrary.simpleMessage(
      "Allow taking back and replaying moves.",
    ),
    "Undo_Move": MessageLookupByLibrary.simpleMessage("Undo move"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("Unfinished game"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("Set Up AI Game"),
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
