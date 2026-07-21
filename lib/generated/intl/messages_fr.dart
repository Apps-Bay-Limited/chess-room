// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(count) => "${count} min";

  static String m1(count) => "${count} coups";

  static String m2(current, total) => "Coup ${current} sur ${total}";

  static String m3(current, total, side) =>
      "Coup ${current} sur ${total} : jouez pour les ${side}";

  static String m4(value) => "Perte d’évaluation : ${value} pions";

  static String m5(current, total) => "Problème ${current} sur ${total}";

  static String m6(count) => "Série : ${count}";

  static String m7(solved, total) => "${solved} sur ${total} résolus";

  static String m8(price) => "Supprimer les publicités ${price}";

  static String m9(current, total, classification) =>
      "Coup ${current} sur ${total} : ${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage("Difficulté de l’IA"),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage("L’IA réfléchit"),
    "Back": MessageLookupByLibrary.simpleMessage("Retour"),
    "Best_Move": MessageLookupByLibrary.simpleMessage("Meilleur coup"),
    "Biggest_Mistake": MessageLookupByLibrary.simpleMessage(
      "Plus grosse erreur",
    ),
    "Black": MessageLookupByLibrary.simpleMessage("Noirs"),
    "Black_Wins": MessageLookupByLibrary.simpleMessage("Les Noirs gagnent !"),
    "Blacks_Turn": MessageLookupByLibrary.simpleMessage("Au tour des Noirs"),
    "Blunder": MessageLookupByLibrary.simpleMessage("Gaffe"),
    "Blunder_Explanation": MessageLookupByLibrary.simpleMessage(
      "Ce coup perd beaucoup de matériel ou permet une attaque décisive.",
    ),
    "Cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "Résultat Chess Room",
    ),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage(
      "Boîte à musique classique",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("Correct ! Échec et mat."),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("Problème du jour"),
    "Done": MessageLookupByLibrary.simpleMessage("Terminé"),
    "Draw": MessageLookupByLibrary.simpleMessage("Partie nulle"),
    "Easy": MessageLookupByLibrary.simpleMessage("Facile"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("Easy Unit"),
    "Export_PGN": MessageLookupByLibrary.simpleMessage("Copier le PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("Extrême"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage(
      "Puzzle de blocs",
    ),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage(
      "Trouvez le meilleur coup.",
    ),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("Lancer de couteau"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage(
      "Analyse complète de la partie",
    ),
    "Game_History": MessageLookupByLibrary.simpleMessage(
      "Historique des parties",
    ),
    "Game_Replay": MessageLookupByLibrary.simpleMessage(
      "Relecture de la partie",
    ),
    "Good_Move": MessageLookupByLibrary.simpleMessage("Bon coup"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "Ce coup reste proche du meilleur choix du moteur.",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("Difficile"),
    "Hints": MessageLookupByLibrary.simpleMessage("Indices"),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("Image Guru"),
    "Import": MessageLookupByLibrary.simpleMessage("Importer"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("Importer un PGN"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("Imprécision"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "Ce coup cède une petite partie de l’avantage de la position.",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("Instant Face"),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("Mat en un"),
    "Medium": MessageLookupByLibrary.simpleMessage("Moyen"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("Metronome Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("Minesweeper Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("Mint Translate"),
    "Minute_Count": m0,
    "Mistake": MessageLookupByLibrary.simpleMessage("Erreur"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "Un coup plus fort aurait conservé une position nettement meilleure.",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("Suivi des dépenses"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("Plus d’applications"),
    "Move_Count": m1,
    "Move_Of": m2,
    "Next": MessageLookupByLibrary.simpleMessage("Suivant"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("Problème suivant"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("Aucune limite"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage(
      "Les parties terminées et importées apparaîtront ici.",
    ),
    "Novels_Hub": MessageLookupByLibrary.simpleMessage(
      "Bibliothèque de romans",
    ),
    "Onlynote": MessageLookupByLibrary.simpleMessage("Onlynote"),
    "Opening_Complete": MessageLookupByLibrary.simpleMessage(
      "Variante terminée ! Vous avez joué tous les coups correctement.",
    ),
    "Opening_Italian": MessageLookupByLibrary.simpleMessage("Partie italienne"),
    "Opening_Italian_Description": MessageLookupByLibrary.simpleMessage(
      "Développez rapidement vos pièces et mettez la case f7 sous pression.",
    ),
    "Opening_London": MessageLookupByLibrary.simpleMessage(
      "Système de Londres",
    ),
    "Opening_London_Description": MessageLookupByLibrary.simpleMessage(
      "Construisez une position solide avec le fou de cases noires hors de la chaîne de pions.",
    ),
    "Opening_Move_Prompt": m3,
    "Opening_Queens_Gambit": MessageLookupByLibrary.simpleMessage(
      "Gambit dame",
    ),
    "Opening_Queens_Gambit_Description": MessageLookupByLibrary.simpleMessage(
      "Offrez un pion de l’aile pour établir un contrôle durable du centre.",
    ),
    "Opening_Ruy_Lopez": MessageLookupByLibrary.simpleMessage(
      "Partie espagnole",
    ),
    "Opening_Ruy_Lopez_Description": MessageLookupByLibrary.simpleMessage(
      "Contestez le défenseur central des Noirs avec un clouage rapide du fou.",
    ),
    "Opening_Sicilian": MessageLookupByLibrary.simpleMessage(
      "Défense sicilienne",
    ),
    "Opening_Sicilian_Description": MessageLookupByLibrary.simpleMessage(
      "Créez une lutte déséquilibrée contre l’ouverture du pion roi des Blancs.",
    ),
    "Opening_Trainer": MessageLookupByLibrary.simpleMessage(
      "Entraînement aux ouvertures",
    ),
    "Opening_Trainer_Description": MessageLookupByLibrary.simpleMessage(
      "Apprenez les idées et les premiers coups de cinq ouvertures fiables.",
    ),
    "Opening_Try_Again": MessageLookupByLibrary.simpleMessage(
      "Ce coup ne fait pas partie de cette variante. Réessayez.",
    ),
    "PGN_Copied": MessageLookupByLibrary.simpleMessage(
      "PGN copié dans le presse-papiers.",
    ),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage(
      "PGN importé avec succès.",
    ),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage(
      "Ce PGN n’a pas pu être importé.",
    ),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("Collez une partie PGN"),
    "Pawns_Lost": m4,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage(
      "Choisissez votre camp",
    ),
    "Played_Move": MessageLookupByLibrary.simpleMessage("Coup joué"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("Recommencer"),
    "Previous": MessageLookupByLibrary.simpleMessage("Précédent"),
    "Purchase_Cancelled": MessageLookupByLibrary.simpleMessage("Achat annulé."),
    "Purchase_Failed": MessageLookupByLibrary.simpleMessage(
      "Échec de l’achat. Veuillez réessayer.",
    ),
    "Purchase_In_Progress": MessageLookupByLibrary.simpleMessage(
      "Achat en cours…",
    ),
    "Purchase_Pending": MessageLookupByLibrary.simpleMessage(
      "L’achat est en attente d’approbation.",
    ),
    "Purchase_Restored": MessageLookupByLibrary.simpleMessage(
      "Achat restauré. Les publicités sont supprimées.",
    ),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage(
      "Achat terminé. Les publicités sont supprimées.",
    ),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage(
      "Problème terminé !",
    ),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "Aux Blancs ou aux Noirs de jouer. Trouvez le mat en un coup.",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage(
      "Bibliothèque de problèmes",
    ),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "Entraînez-vous par thème à votre rythme. Votre progression est enregistrée sur cet appareil.",
    ),
    "Puzzle_Number": m5,
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage(
      "Le problème du jour est terminé.",
    ),
    "Puzzle_Streak": m6,
    "Puzzles_Solved": m7,
    "Remove_Ads": MessageLookupByLibrary.simpleMessage(
      "Supprimer les publicités",
    ),
    "Remove_Ads_Description": MessageLookupByLibrary.simpleMessage(
      "Supprime définitivement les publicités de cette application.",
    ),
    "Remove_Ads_Loading": MessageLookupByLibrary.simpleMessage(
      "Chargement des options d’achat…",
    ),
    "Remove_Ads_Purchased": MessageLookupByLibrary.simpleMessage(
      "Les publicités sont supprimées sur cet appareil.",
    ),
    "Remove_Ads_Unavailable": MessageLookupByLibrary.simpleMessage(
      "La suppression des publicités est actuellement indisponible.",
    ),
    "Remove_Ads_With_Price": m8,
    "Replay": MessageLookupByLibrary.simpleMessage("Rejouer"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "Aucun achat antérieur de suppression des publicités n’a été trouvé.",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage(
      "Restaurer les achats",
    ),
    "Review_Game": MessageLookupByLibrary.simpleMessage(
      "Analyser la plus grosse erreur",
    ),
    "Review_Move_Title": m9,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage(
      "Sauver l’ambulance",
    ),
    "Settings": MessageLookupByLibrary.simpleMessage("Réglages"),
    "Share_Result": MessageLookupByLibrary.simpleMessage(
      "Partager le résultat",
    ),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage(
      "Création de la carte de résultat…",
    ),
    "Shows": MessageLookupByLibrary.simpleMessage("Émissions"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage(
      "Calculatrice simple",
    ),
    "Stalemate": MessageLookupByLibrary.simpleMessage("Pat"),
    "Start": MessageLookupByLibrary.simpleMessage("Commencer"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("Sudoku Lover"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("Échec et mat"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage(
      "Fourchettes de cavalier",
    ),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage(
      "Promotion du pion",
    ),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("Limite de temps"),
    "Tip": MessageLookupByLibrary.simpleMessage("Conseil"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage(
      "Afficher le bouton Conseil",
    ),
    "Training": MessageLookupByLibrary.simpleMessage("Entraînement"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "Choisissez une séance de problèmes ciblée ou apprenez une variante d’ouverture fiable.",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage(
      "Pas tout à fait — réessayez",
    ),
    "Two_Players": MessageLookupByLibrary.simpleMessage("Deux joueurs"),
    "Undo": MessageLookupByLibrary.simpleMessage("Annuler/Rétablir"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("Partie inachevée"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("Contre l’IA"),
    "We_Play_Piano": MessageLookupByLibrary.simpleMessage("We Play Piano"),
    "White": MessageLookupByLibrary.simpleMessage("Blancs"),
    "White_Wins": MessageLookupByLibrary.simpleMessage("Les Blancs gagnent !"),
    "Whites_Turn": MessageLookupByLibrary.simpleMessage("Au tour des Blancs"),
    "World_Weather_Live": MessageLookupByLibrary.simpleMessage(
      "Météo mondiale en direct",
    ),
    "Yes_Habit": MessageLookupByLibrary.simpleMessage("Yes Habit"),
    "You_Lose": MessageLookupByLibrary.simpleMessage("Vous avez perdu"),
    "You_Win": MessageLookupByLibrary.simpleMessage("Vous avez gagné"),
    "Your_Turn": MessageLookupByLibrary.simpleMessage("À vous de jouer"),
  };
}
