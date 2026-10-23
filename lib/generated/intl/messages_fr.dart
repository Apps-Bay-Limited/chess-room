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

  static String m0(square) => "Case vide ${square}";

  static String m1(count) => "${count} min";

  static String m2(count) => "${count} coups";

  static String m3(current, total) => "Coup ${current} sur ${total}";

  static String m4(current, total, side) =>
      "Coup ${current} sur ${total} : jouez pour les ${side}";

  static String m5(completed, total) =>
      "${completed} ouvertures sur ${total} terminées";

  static String m6(value) => "Perte d’évaluation : ${value} pions";

  static String m7(piece, square) => "${piece} en ${square}";

  static String m8(current, total) => "Problème ${current} sur ${total}";

  static String m9(piece, support, square) =>
      "Fuite empêchée : ${piece} en ${support} contrôle ${square}.";

  static String m10(from, king, target) =>
      "Depuis ${from}, le cavalier fait échec au roi en ${king} et attaque aussi ${target}.";

  static String m11(line) => "Une solution : ${line}.";

  static String m12(square) =>
      "Échec et mat au roi en ${square} : aucune fuite, capture ou interposition légale.";

  static String m13(piece, from, to) => "${piece} : ${from} → ${to}.";

  static String m14(squares) =>
      "Les pions de la défense en ${squares} bloquent la fuite de leur propre roi.";

  static String m15(square, piece) =>
      "Le pion atteint ${square} et devient ${piece}.";

  static String m16(reply, finish) =>
      "Après ${reply}, ${finish} fait échec et mat.";

  static String m17(piece, support, square) =>
      "Soutien : ${piece} en ${support} protège ${square}.";

  static String m18(count) => "Série : ${count}";

  static String m19(completed, total) =>
      "${completed} problèmes sur ${total} terminés";

  static String m20(solved, total) => "${solved} sur ${total} résolus";

  static String m21(price) => "Supprimer les publicités ${price}";

  static String m22(current, total, classification) =>
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
    "Board_Coordinates": MessageLookupByLibrary.simpleMessage(
      "Coordonnées de l’échiquier",
    ),
    "Board_Coordinates_Description": MessageLookupByLibrary.simpleMessage(
      "Afficher les colonnes et les rangées autour de l’échiquier.",
    ),
    "Cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "Chess_Bishop_Rule": MessageLookupByLibrary.simpleMessage(
      "Fou — se déplace d’autant de cases que souhaité en diagonale.",
    ),
    "Chess_Castling_Rule": MessageLookupByLibrary.simpleMessage(
      "Roque — déplacez le roi de deux cases vers une tour, puis placez cette tour à côté du roi. Aucune des deux pièces ne doit avoir bougé, le passage doit être libre et le roi ne peut être en échec, traverser une case attaquée ou finir en échec.",
    ),
    "Chess_Check_Body": MessageLookupByLibrary.simpleMessage(
      "Lorsque votre roi est en échec, vous devez déplacer le roi, capturer la pièce attaquante ou bloquer l’attaque. Si aucune réponse légale n’existe, c’est échec et mat et la partie est terminée.",
    ),
    "Chess_Check_Title": MessageLookupByLibrary.simpleMessage(
      "Échec et échec et mat",
    ),
    "Chess_Draws_Body": MessageLookupByLibrary.simpleMessage(
      "Une partie peut être nulle par pat, accord, matériel insuffisant, répétition triple ou après cinquante coups de chaque camp sans mouvement de pion ni prise.",
    ),
    "Chess_Draws_Title": MessageLookupByLibrary.simpleMessage("Parties nulles"),
    "Chess_En_Passant_Rule": MessageLookupByLibrary.simpleMessage(
      "Prise en passant — un pion peut capturer un pion adverse adjacent qui vient d’avancer de deux cases comme s’il n’en avait avancé qu’une. Ce coup n’est possible qu’immédiatement.",
    ),
    "Chess_Goal_Body": MessageLookupByLibrary.simpleMessage(
      "Mettez le roi adverse échec et mat. Cela signifie que le roi est attaqué et ne dispose d’aucun moyen légal de s’échapper.",
    ),
    "Chess_Goal_Title": MessageLookupByLibrary.simpleMessage("Le but"),
    "Chess_King_Rule": MessageLookupByLibrary.simpleMessage(
      "Roi — se déplace d’une case dans toutes les directions et ne peut jamais aller sur une case en échec.",
    ),
    "Chess_Knight_Rule": MessageLookupByLibrary.simpleMessage(
      "Cavalier — se déplace en L : deux cases dans une direction, puis une sur le côté. Il peut sauter par-dessus les pièces.",
    ),
    "Chess_Pawn_Rule": MessageLookupByLibrary.simpleMessage(
      "Pion — avance d’une case, ou de deux depuis sa case initiale, et capture d’une case en diagonale vers l’avant.",
    ),
    "Chess_Pieces_Title": MessageLookupByLibrary.simpleMessage(
      "Déplacement des pièces",
    ),
    "Chess_Promotion_Rule": MessageLookupByLibrary.simpleMessage(
      "Promotion — un pion qui atteint la dernière rangée devient une dame, une tour, un fou ou un cavalier.",
    ),
    "Chess_Queen_Rule": MessageLookupByLibrary.simpleMessage(
      "Dame — se déplace d’autant de cases que souhaité sur une rangée, une colonne ou une diagonale.",
    ),
    "Chess_Rook_Rule": MessageLookupByLibrary.simpleMessage(
      "Tour — se déplace d’autant de cases que souhaité horizontalement ou verticalement.",
    ),
    "Chess_Room": MessageLookupByLibrary.simpleMessage("Chess Room"),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "Résultat Chess Room",
    ),
    "Chess_Setup_Body": MessageLookupByLibrary.simpleMessage(
      "Placez l’échiquier avec une case claire à la droite de chaque joueur. La rangée du fond est : tour, cavalier, fou, dame, roi, fou, cavalier, tour ; la dame commence sur sa propre couleur. Les pions occupent la rangée devant. Les Blancs commencent.",
    ),
    "Chess_Setup_Title": MessageLookupByLibrary.simpleMessage("Mise en place"),
    "Chess_Special_Moves_Title": MessageLookupByLibrary.simpleMessage(
      "Coups spéciaux",
    ),
    "Chess_Tips_Body": MessageLookupByLibrary.simpleMessage(
      "Contrôlez le centre, développez rapidement cavaliers et fous, roquez pour protéger votre roi et vérifiez les menaces adverses avant chaque coup.",
    ),
    "Chess_Tips_Title": MessageLookupByLibrary.simpleMessage(
      "Conseils aux débutants",
    ),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage(
      "Boîte à musique classique",
    ),
    "Clock_Active": MessageLookupByLibrary.simpleMessage("Au trait"),
    "Clock_Black": MessageLookupByLibrary.simpleMessage("Noirs"),
    "Clock_White": MessageLookupByLibrary.simpleMessage("Blancs"),
    "Continue_Game": MessageLookupByLibrary.simpleMessage(
      "Reprendre la partie",
    ),
    "Continue_Game_Description": MessageLookupByLibrary.simpleMessage(
      "Reprenez là où vous en étiez",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("Correct ! Échec et mat."),
    "Daily_Practice_Complete": MessageLookupByLibrary.simpleMessage(
      "Défi du jour terminé · continuez à vous entraîner",
    ),
    "Daily_Practice_Ready": MessageLookupByLibrary.simpleMessage(
      "Un nouveau défi pour aujourd’hui",
    ),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("Problème du jour"),
    "Delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
    "Delete_Game_Failed": MessageLookupByLibrary.simpleMessage(
      "Impossible de supprimer cette partie. Veuillez réessayer.",
    ),
    "Delete_Game_Message": MessageLookupByLibrary.simpleMessage(
      "Cette partie enregistrée sera supprimée de cet appareil. Cette action est irréversible.",
    ),
    "Delete_Game_Title": MessageLookupByLibrary.simpleMessage(
      "Supprimer cette partie ?",
    ),
    "Done": MessageLookupByLibrary.simpleMessage("Terminé"),
    "Draw": MessageLookupByLibrary.simpleMessage("Partie nulle"),
    "Easy": MessageLookupByLibrary.simpleMessage("Facile"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("Easy Unit"),
    "Empty_Square": m0,
    "Export_PGN": MessageLookupByLibrary.simpleMessage("Copier le PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("Extrême"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage(
      "Puzzle de blocs",
    ),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage(
      "Trouvez le meilleur coup.",
    ),
    "First_Move": MessageLookupByLibrary.simpleMessage("Premier coup"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("Lancer de couteau"),
    "Flip_Board": MessageLookupByLibrary.simpleMessage("Retourner l’échiquier"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage(
      "Analyse complète de la partie",
    ),
    "Game_History": MessageLookupByLibrary.simpleMessage(
      "Historique des parties",
    ),
    "Game_Replay": MessageLookupByLibrary.simpleMessage(
      "Relecture de la partie",
    ),
    "Game_Setup_Description": MessageLookupByLibrary.simpleMessage(
      "Choisissez un défi à votre niveau et jouez votre premier coup.",
    ),
    "Gameplay_Settings": MessageLookupByLibrary.simpleMessage("Jeu"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("Bon coup"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "Ce coup reste proche du meilleur choix du moteur.",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("Difficile"),
    "Help_And_Privacy": MessageLookupByLibrary.simpleMessage(
      "Aide et confidentialité",
    ),
    "Hints": MessageLookupByLibrary.simpleMessage("Coups légaux"),
    "Hints_Description": MessageLookupByLibrary.simpleMessage(
      "Afficher les cases accessibles quand vous sélectionnez une pièce.",
    ),
    "Home_AI_Description": MessageLookupByLibrary.simpleMessage(
      "Choisissez le niveau, le camp et la cadence",
    ),
    "Home_Local_Description": MessageLookupByLibrary.simpleMessage(
      "Jouez à deux sur le même appareil",
    ),
    "Home_Play_Options": MessageLookupByLibrary.simpleMessage(
      "Autres façons de jouer",
    ),
    "Home_Subtitle": MessageLookupByLibrary.simpleMessage(
      "Jouez une partie. Affinez votre prochain coup.",
    ),
    "Home_Training_Description": MessageLookupByLibrary.simpleMessage(
      "Problèmes et ouvertures guidées",
    ),
    "How_To_Play_Chess": MessageLookupByLibrary.simpleMessage(
      "Comment jouer aux échecs",
    ),
    "How_To_Play_Intro": MessageLookupByLibrary.simpleMessage(
      "Apprenez les règles essentielles, puis utilisez l’entraînement pour travailler vos tactiques et vos ouvertures.",
    ),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("Image Guru"),
    "Import": MessageLookupByLibrary.simpleMessage("Importer"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("Importer un PGN"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("Imprécision"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "Ce coup cède une petite partie de l’avantage de la position.",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("Instant Face"),
    "Last_Move": MessageLookupByLibrary.simpleMessage("Dernier coup"),
    "Local_Data_Unavailable": MessageLookupByLibrary.simpleMessage(
      "Les données enregistrées sont momentanément indisponibles. Veuillez réessayer.",
    ),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("Mat en un"),
    "Mate_In_Two": MessageLookupByLibrary.simpleMessage("Mat en deux coups"),
    "Medium": MessageLookupByLibrary.simpleMessage("Moyen"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("Metronome Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("Minesweeper Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("Mint Translate"),
    "Minute_Count": m1,
    "Mistake": MessageLookupByLibrary.simpleMessage("Erreur"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "Un coup plus fort aurait conservé une position nettement meilleure.",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("Suivi des dépenses"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("Plus d’applications"),
    "Move_Count": m2,
    "Move_Of": m3,
    "Next": MessageLookupByLibrary.simpleMessage("Suivant"),
    "Next_Move": MessageLookupByLibrary.simpleMessage("Coup suivant"),
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
    "Opening_Move_Prompt": m4,
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
    "Openings_Completed_Count": m5,
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
    "Pawns_Lost": m6,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage(
      "Choisissez votre camp",
    ),
    "Piece_Black_Bishop": MessageLookupByLibrary.simpleMessage("Fou noir"),
    "Piece_Black_King": MessageLookupByLibrary.simpleMessage("Roi noir"),
    "Piece_Black_Knight": MessageLookupByLibrary.simpleMessage("Cavalier noir"),
    "Piece_Black_Pawn": MessageLookupByLibrary.simpleMessage("Pion noir"),
    "Piece_Black_Queen": MessageLookupByLibrary.simpleMessage("Dame noire"),
    "Piece_Black_Rook": MessageLookupByLibrary.simpleMessage("Tour noire"),
    "Piece_On_Square": m7,
    "Piece_White_Bishop": MessageLookupByLibrary.simpleMessage("Fou blanc"),
    "Piece_White_King": MessageLookupByLibrary.simpleMessage("Roi blanc"),
    "Piece_White_Knight": MessageLookupByLibrary.simpleMessage(
      "Cavalier blanc",
    ),
    "Piece_White_Pawn": MessageLookupByLibrary.simpleMessage("Pion blanc"),
    "Piece_White_Queen": MessageLookupByLibrary.simpleMessage("Dame blanche"),
    "Piece_White_Rook": MessageLookupByLibrary.simpleMessage("Tour blanche"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("Coup joué"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("Recommencer"),
    "Previous": MessageLookupByLibrary.simpleMessage("Précédent"),
    "Previous_Move": MessageLookupByLibrary.simpleMessage("Coup précédent"),
    "Privacy_Choices": MessageLookupByLibrary.simpleMessage(
      "Options de confidentialité",
    ),
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
    "Puzzle_Easy": MessageLookupByLibrary.simpleMessage("Facile"),
    "Puzzle_Explain_Back_Rank": MessageLookupByLibrary.simpleMessage(
      "Les pions empêchent le roi de fuir. Faites échec sur la dernière rangée pour terminer la partie.",
    ),
    "Puzzle_Explain_Bishop_Mate": MessageLookupByLibrary.simpleMessage(
      "Coordonnez le fou avec vos autres pièces pour contrôler les cases de fuite du roi.",
    ),
    "Puzzle_Explain_Combination": MessageLookupByLibrary.simpleMessage(
      "Utilisez des échecs forcés pour limiter les réponses, puis terminez par un mat.",
    ),
    "Puzzle_Explain_Fork": MessageLookupByLibrary.simpleMessage(
      "Faites échec au roi tout en attaquant une autre pièce de valeur.",
    ),
    "Puzzle_Explain_Knight_Mate": MessageLookupByLibrary.simpleMessage(
      "Le cavalier fait échec au roi tandis que vos autres pièces contrôlent ses cases de fuite.",
    ),
    "Puzzle_Explain_Promotion": MessageLookupByLibrary.simpleMessage(
      "Promouvez le pion en toute sécurité pour obtenir une dame.",
    ),
    "Puzzle_Explain_Queen_Net": MessageLookupByLibrary.simpleMessage(
      "Coordonnez votre dame avec les pièces qui la soutiennent pour contrôler toutes les cases de fuite.",
    ),
    "Puzzle_Explain_Rook_Mate": MessageLookupByLibrary.simpleMessage(
      "Coupez les voies de fuite du roi, puis faites échec le long du bord de l’échiquier.",
    ),
    "Puzzle_Hard": MessageLookupByLibrary.simpleMessage("Difficile"),
    "Puzzle_Hint": MessageLookupByLibrary.simpleMessage("Afficher un indice"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "Aux Blancs ou aux Noirs de jouer. Trouvez le mat en un coup.",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage(
      "Bibliothèque de problèmes",
    ),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "Entraînez-vous par thème à votre rythme. Votre progression est enregistrée sur cet appareil.",
    ),
    "Puzzle_Line_Progress": MessageLookupByLibrary.simpleMessage(
      "Poursuivez la combinaison",
    ),
    "Puzzle_Medium": MessageLookupByLibrary.simpleMessage("Moyen"),
    "Puzzle_Number": m8,
    "Puzzle_Position_Escape": m9,
    "Puzzle_Position_Fork": m10,
    "Puzzle_Position_Line": m11,
    "Puzzle_Position_Mate": m12,
    "Puzzle_Position_Move": m13,
    "Puzzle_Position_Pawns": m14,
    "Puzzle_Position_Promotion": m15,
    "Puzzle_Position_Reply": m16,
    "Puzzle_Position_Support": m17,
    "Puzzle_Practice_Next": MessageLookupByLibrary.simpleMessage(
      "Continuer à s’entraîner",
    ),
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage(
      "Le problème du jour est terminé.",
    ),
    "Puzzle_Streak": m18,
    "Puzzle_Why_This_Works": MessageLookupByLibrary.simpleMessage(
      "Pourquoi cela fonctionne",
    ),
    "Puzzles_Completed_Count": m19,
    "Puzzles_Solved": m20,
    "Quick_Play": MessageLookupByLibrary.simpleMessage("Partie rapide"),
    "Quick_Play_Description": MessageLookupByLibrary.simpleMessage(
      "Affrontez l’IA avec vos derniers réglages",
    ),
    "Redo_Move": MessageLookupByLibrary.simpleMessage("Rétablir le coup"),
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
    "Remove_Ads_With_Price": m21,
    "Replace_Unfinished_Game": MessageLookupByLibrary.simpleMessage(
      "Commencer une nouvelle partie ?",
    ),
    "Replace_Unfinished_Game_Description": MessageLookupByLibrary.simpleMessage(
      "Votre partie inachevée sera remplacée.",
    ),
    "Replay": MessageLookupByLibrary.simpleMessage("Rejouer"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "Aucun achat antérieur de suppression des publicités n’a été trouvé.",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage(
      "Restaurer les achats",
    ),
    "Resume_Game_Unavailable": MessageLookupByLibrary.simpleMessage(
      "Cette partie n’a pas pu être restaurée. Vous pouvez en commencer une nouvelle.",
    ),
    "Retry": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("Analyser la partie"),
    "Review_Move_Title": m22,
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
    "Sound": MessageLookupByLibrary.simpleMessage("Son"),
    "Sound_Description": MessageLookupByLibrary.simpleMessage(
      "Jouer des sons quand les pièces se déplacent.",
    ),
    "Stalemate": MessageLookupByLibrary.simpleMessage("Pat"),
    "Start": MessageLookupByLibrary.simpleMessage("Commencer"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("Sudoku Lover"),
    "Theme_Back_Rank": MessageLookupByLibrary.simpleMessage("Mat du couloir"),
    "Theme_Bishop_Mate": MessageLookupByLibrary.simpleMessage("Mat au fou"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("Échec et mat"),
    "Theme_Combination": MessageLookupByLibrary.simpleMessage("Combinaisons"),
    "Theme_Double_Attack": MessageLookupByLibrary.simpleMessage(
      "Attaque double",
    ),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage(
      "Fourchettes de cavalier",
    ),
    "Theme_Knight_Mate": MessageLookupByLibrary.simpleMessage(
      "Mat au cavalier",
    ),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage(
      "Promotion du pion",
    ),
    "Theme_Queen_Net": MessageLookupByLibrary.simpleMessage("Mat à la dame"),
    "Theme_Rook_Mate": MessageLookupByLibrary.simpleMessage("Mat à la tour"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("Limite de temps"),
    "Tip": MessageLookupByLibrary.simpleMessage("Suggérer un coup"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("Bouton de suggestion"),
    "Tip_Button_Description": MessageLookupByLibrary.simpleMessage(
      "Afficher un bouton qui suggère un meilleur coup.",
    ),
    "Training": MessageLookupByLibrary.simpleMessage("Entraînement"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "Choisissez une séance de problèmes ciblée ou apprenez une variante d’ouverture fiable.",
    ),
    "Training_Progress": MessageLookupByLibrary.simpleMessage(
      "Votre progression",
    ),
    "Training_Progress_Unavailable": MessageLookupByLibrary.simpleMessage(
      "La progression est momentanément indisponible. Veuillez réessayer.",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage(
      "Pas tout à fait — réessayez",
    ),
    "Two_Players": MessageLookupByLibrary.simpleMessage("Deux joueurs"),
    "Undo": MessageLookupByLibrary.simpleMessage("Annuler/Rétablir"),
    "Undo_Description": MessageLookupByLibrary.simpleMessage(
      "Autoriser l’annulation et le rétablissement des coups.",
    ),
    "Undo_Move": MessageLookupByLibrary.simpleMessage("Annuler le coup"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("Partie inachevée"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage(
      "Configurer une partie contre l’IA",
    ),
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
