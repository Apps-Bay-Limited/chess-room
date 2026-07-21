// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(count) => "${count} min";

  static String m1(count) => "${count} jugadas";

  static String m2(current, total) => "Jugada ${current} de ${total}";

  static String m3(current, total, side) =>
      "Jugada ${current} de ${total}: juega con ${side}";

  static String m4(value) => "Pérdida de evaluación: ${value} peones";

  static String m5(current, total) => "Problema ${current} de ${total}";

  static String m6(count) => "Racha: ${count}";

  static String m7(solved, total) => "${solved} de ${total} resueltos";

  static String m8(price) => "Eliminar anuncios ${price}";

  static String m9(current, total, classification) =>
      "Jugada ${current} de ${total}: ${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage(
      "Dificultad de la IA",
    ),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage(
      "La IA está pensando",
    ),
    "Back": MessageLookupByLibrary.simpleMessage("Atrás"),
    "Best_Move": MessageLookupByLibrary.simpleMessage("Mejor jugada"),
    "Biggest_Mistake": MessageLookupByLibrary.simpleMessage("Mayor error"),
    "Black": MessageLookupByLibrary.simpleMessage("Negras"),
    "Black_Wins": MessageLookupByLibrary.simpleMessage("¡Ganan las negras!"),
    "Blacks_Turn": MessageLookupByLibrary.simpleMessage("Turno de las negras"),
    "Blunder": MessageLookupByLibrary.simpleMessage("Error grave"),
    "Blunder_Explanation": MessageLookupByLibrary.simpleMessage(
      "Esta jugada pierde mucho material o permite un ataque decisivo.",
    ),
    "Cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "Resultado de Chess Room",
    ),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage(
      "Caja de música clásica",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("¡Correcto! Jaque mate."),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("Problema diario"),
    "Done": MessageLookupByLibrary.simpleMessage("Hecho"),
    "Draw": MessageLookupByLibrary.simpleMessage("Tablas"),
    "Easy": MessageLookupByLibrary.simpleMessage("Fácil"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("Easy Unit"),
    "Export_PGN": MessageLookupByLibrary.simpleMessage("Copiar PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("Extrema"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage(
      "Puzzle de bloques",
    ),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage(
      "Encuentra la mejor jugada.",
    ),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage(
      "Lanzamiento de cuchillos",
    ),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage(
      "Revisión completa de la partida",
    ),
    "Game_History": MessageLookupByLibrary.simpleMessage(
      "Historial de partidas",
    ),
    "Game_Replay": MessageLookupByLibrary.simpleMessage(
      "Repetición de la partida",
    ),
    "Good_Move": MessageLookupByLibrary.simpleMessage("Buena jugada"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "Esta jugada se acerca a la mejor opción del motor.",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("Difícil"),
    "Hints": MessageLookupByLibrary.simpleMessage("Pistas"),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("Image Guru"),
    "Import": MessageLookupByLibrary.simpleMessage("Importar"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("Importar PGN"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("Imprecisión"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "Esta jugada cede una pequeña parte de la ventaja de la posición.",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("Instant Face"),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("Mate en uno"),
    "Medium": MessageLookupByLibrary.simpleMessage("Media"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("Metronome Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("Minesweeper Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("Mint Translate"),
    "Minute_Count": m0,
    "Mistake": MessageLookupByLibrary.simpleMessage("Error"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "Una jugada más fuerte habría mantenido una posición mucho mejor.",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("Control de gastos"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("Más aplicaciones"),
    "Move_Count": m1,
    "Move_Of": m2,
    "Next": MessageLookupByLibrary.simpleMessage("Siguiente"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("Siguiente problema"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("Sin límite"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage(
      "Las partidas completadas e importadas aparecerán aquí.",
    ),
    "Novels_Hub": MessageLookupByLibrary.simpleMessage("Biblioteca de novelas"),
    "Onlynote": MessageLookupByLibrary.simpleMessage("Onlynote"),
    "Opening_Complete": MessageLookupByLibrary.simpleMessage(
      "¡Variante completada! Has jugado correctamente todas las jugadas.",
    ),
    "Opening_Italian": MessageLookupByLibrary.simpleMessage(
      "Apertura italiana",
    ),
    "Opening_Italian_Description": MessageLookupByLibrary.simpleMessage(
      "Desarrolla rápidamente y presiona la vulnerable casilla f7.",
    ),
    "Opening_London": MessageLookupByLibrary.simpleMessage("Sistema Londres"),
    "Opening_London_Description": MessageLookupByLibrary.simpleMessage(
      "Construye una posición fiable con el alfil de casillas negras fuera de la cadena de peones.",
    ),
    "Opening_Move_Prompt": m3,
    "Opening_Queens_Gambit": MessageLookupByLibrary.simpleMessage(
      "Gambito de dama",
    ),
    "Opening_Queens_Gambit_Description": MessageLookupByLibrary.simpleMessage(
      "Ofrece un peón del flanco para obtener un control duradero del centro.",
    ),
    "Opening_Ruy_Lopez": MessageLookupByLibrary.simpleMessage(
      "Apertura española",
    ),
    "Opening_Ruy_Lopez_Description": MessageLookupByLibrary.simpleMessage(
      "Ataca al defensor central de las negras con una clavada temprana del alfil.",
    ),
    "Opening_Sicilian": MessageLookupByLibrary.simpleMessage(
      "Defensa siciliana",
    ),
    "Opening_Sicilian_Description": MessageLookupByLibrary.simpleMessage(
      "Crea una lucha desequilibrada contra la apertura de peón de rey de las blancas.",
    ),
    "Opening_Trainer": MessageLookupByLibrary.simpleMessage(
      "Entrenador de aperturas",
    ),
    "Opening_Trainer_Description": MessageLookupByLibrary.simpleMessage(
      "Aprende las ideas y primeras jugadas de cinco aperturas fiables.",
    ),
    "Opening_Try_Again": MessageLookupByLibrary.simpleMessage(
      "Esta jugada no pertenece a la variante de entrenamiento. Inténtalo de nuevo.",
    ),
    "PGN_Copied": MessageLookupByLibrary.simpleMessage(
      "PGN copiado al portapapeles.",
    ),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage(
      "PGN importado correctamente.",
    ),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage(
      "No se pudo importar este PGN.",
    ),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("Pega una partida PGN"),
    "Pawns_Lost": m4,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("Elige tu bando"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("Jugada"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage(
      "Practicar de nuevo",
    ),
    "Previous": MessageLookupByLibrary.simpleMessage("Anterior"),
    "Purchase_Cancelled": MessageLookupByLibrary.simpleMessage(
      "Compra cancelada.",
    ),
    "Purchase_Failed": MessageLookupByLibrary.simpleMessage(
      "La compra ha fallado. Inténtalo de nuevo.",
    ),
    "Purchase_In_Progress": MessageLookupByLibrary.simpleMessage(
      "Compra en curso…",
    ),
    "Purchase_Pending": MessageLookupByLibrary.simpleMessage(
      "La compra está pendiente de aprobación.",
    ),
    "Purchase_Restored": MessageLookupByLibrary.simpleMessage(
      "Compra restaurada. Se han eliminado los anuncios.",
    ),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage(
      "Compra completada. Se han eliminado los anuncios.",
    ),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage(
      "¡Problema completado!",
    ),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "Juegan blancas o negras. Encuentra el mate en una jugada.",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage(
      "Biblioteca de problemas",
    ),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "Practica temas específicos a tu ritmo. El progreso se guarda en este dispositivo.",
    ),
    "Puzzle_Number": m5,
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage(
      "El problema de hoy está completado.",
    ),
    "Puzzle_Streak": m6,
    "Puzzles_Solved": m7,
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("Eliminar anuncios"),
    "Remove_Ads_Description": MessageLookupByLibrary.simpleMessage(
      "Elimina los anuncios de esta aplicación para siempre.",
    ),
    "Remove_Ads_Loading": MessageLookupByLibrary.simpleMessage(
      "Cargando opciones de compra…",
    ),
    "Remove_Ads_Purchased": MessageLookupByLibrary.simpleMessage(
      "Los anuncios están eliminados en este dispositivo.",
    ),
    "Remove_Ads_Unavailable": MessageLookupByLibrary.simpleMessage(
      "La eliminación de anuncios no está disponible en este momento.",
    ),
    "Remove_Ads_With_Price": m8,
    "Replay": MessageLookupByLibrary.simpleMessage("Reproducir"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "No se encontró ninguna compra anterior para eliminar anuncios.",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage(
      "Restaurar compras",
    ),
    "Review_Game": MessageLookupByLibrary.simpleMessage(
      "Revisar el mayor error",
    ),
    "Review_Move_Title": m9,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage(
      "Salvar la ambulancia",
    ),
    "Settings": MessageLookupByLibrary.simpleMessage("Configuración"),
    "Share_Result": MessageLookupByLibrary.simpleMessage("Compartir resultado"),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage(
      "Creando tarjeta de resultado…",
    ),
    "Shows": MessageLookupByLibrary.simpleMessage("Programas"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage(
      "Calculadora sencilla",
    ),
    "Stalemate": MessageLookupByLibrary.simpleMessage("Ahogado"),
    "Start": MessageLookupByLibrary.simpleMessage("Empezar"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("Sudoku Lover"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("Jaque mate"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage(
      "Horquillas de caballo",
    ),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage(
      "Promoción de peón",
    ),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("Límite de tiempo"),
    "Tip": MessageLookupByLibrary.simpleMessage("Consejo"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage(
      "Mostrar botón de consejo",
    ),
    "Training": MessageLookupByLibrary.simpleMessage("Entrenamiento"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "Elige una sesión de problemas específica o aprende una variante de apertura fiable.",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage(
      "No del todo — inténtalo de nuevo",
    ),
    "Two_Players": MessageLookupByLibrary.simpleMessage("Dos jugadores"),
    "Undo": MessageLookupByLibrary.simpleMessage("Deshacer/Rehacer"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("Partida sin terminar"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("Contra la IA"),
    "We_Play_Piano": MessageLookupByLibrary.simpleMessage("We Play Piano"),
    "White": MessageLookupByLibrary.simpleMessage("Blancas"),
    "White_Wins": MessageLookupByLibrary.simpleMessage("¡Ganan las blancas!"),
    "Whites_Turn": MessageLookupByLibrary.simpleMessage("Turno de las blancas"),
    "World_Weather_Live": MessageLookupByLibrary.simpleMessage(
      "Tiempo mundial en directo",
    ),
    "Yes_Habit": MessageLookupByLibrary.simpleMessage("Yes Habit"),
    "You_Lose": MessageLookupByLibrary.simpleMessage("Has perdido"),
    "You_Win": MessageLookupByLibrary.simpleMessage("Has ganado"),
    "Your_Turn": MessageLookupByLibrary.simpleMessage("Tu turno"),
  };
}
