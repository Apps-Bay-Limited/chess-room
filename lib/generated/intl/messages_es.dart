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

  static String m0(square) => "Casilla vacía ${square}";

  static String m1(count) => "${count} min";

  static String m2(count) => "${count} jugadas";

  static String m3(current, total) => "Jugada ${current} de ${total}";

  static String m4(current, total, side) =>
      "Jugada ${current} de ${total}: juega con ${side}";

  static String m5(completed, total) =>
      "${completed} de ${total} aperturas completadas";

  static String m6(value) => "Pérdida de evaluación: ${value} peones";

  static String m7(piece, square) => "${piece} en ${square}";

  static String m8(count) =>
      "Se conservan ${count} partidas anteriores con Premium.";

  static String m9(count) => "Te quedan ${count} ejercicios gratuitos hoy";

  static String m10(count) => "Te quedan ${count} análisis gratuitos hoy";

  static String m11(price) => "Desbloquear Premium ${price}";

  static String m12(current, total) => "Problema ${current} de ${total}";

  static String m13(piece, support, square) =>
      "Escape cerrado: ${piece} en ${support} controla ${square}.";

  static String m14(from, king, target) =>
      "Desde ${from}, el caballo da jaque al rey en ${king} y también ataca ${target}.";

  static String m15(line) => "Una solución: ${line}.";

  static String m16(square) =>
      "Jaque mate al rey en ${square}: no hay escape, captura ni bloqueo legal.";

  static String m17(piece, from, to) => "${piece}: ${from} → ${to}.";

  static String m18(squares) =>
      "Los peones defensores en ${squares} bloquean la salida de su propio rey.";

  static String m19(square, piece) =>
      "El peón alcanza ${square} y se convierte en ${piece}.";

  static String m20(reply, finish) =>
      "Después de ${reply}, ${finish} da jaque mate.";

  static String m21(piece, support, square) =>
      "Apoyo: ${piece} en ${support} protege ${square}.";

  static String m22(count) => "Racha: ${count}";

  static String m23(completed, total) =>
      "${completed} de ${total} problemas completados";

  static String m24(solved, total) => "${solved} de ${total} resueltos";

  static String m25(current, total, classification) =>
      "Jugada ${current} de ${total}: ${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage(
      "Dificultad de la IA",
    ),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage(
      "La IA está pensando",
    ),
    "Appearance": MessageLookupByLibrary.simpleMessage("Apariencia"),
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
    "Board_Coordinates": MessageLookupByLibrary.simpleMessage(
      "Coordenadas del tablero",
    ),
    "Board_Coordinates_Description": MessageLookupByLibrary.simpleMessage(
      "Mostrar las columnas y filas alrededor del tablero.",
    ),
    "Board_Theme": MessageLookupByLibrary.simpleMessage("Tema del tablero"),
    "Cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "Chess_Bishop_Rule": MessageLookupByLibrary.simpleMessage(
      "Alfil — mueve cualquier número de casillas en diagonal.",
    ),
    "Chess_Castling_Rule": MessageLookupByLibrary.simpleMessage(
      "Enroque — mueve el rey dos casillas hacia una torre y coloca esa torre junto al rey. Ninguna pieza puede haberse movido, el camino debe estar libre y el rey no puede estar, pasar ni terminar en jaque.",
    ),
    "Chess_Check_Body": MessageLookupByLibrary.simpleMessage(
      "Cuando tu rey está en jaque, debes moverlo, capturar la pieza atacante o bloquear el ataque. Si no existe respuesta legal, es jaque mate y la partida termina.",
    ),
    "Chess_Check_Title": MessageLookupByLibrary.simpleMessage(
      "Jaque y jaque mate",
    ),
    "Chess_Draws_Body": MessageLookupByLibrary.simpleMessage(
      "Una partida puede acabar en tablas por ahogado, acuerdo, material insuficiente, triple repetición o cincuenta jugadas de cada bando sin mover un peón ni capturar.",
    ),
    "Chess_Draws_Title": MessageLookupByLibrary.simpleMessage("Tablas"),
    "Chess_En_Passant_Rule": MessageLookupByLibrary.simpleMessage(
      "Captura al paso — un peón puede capturar un peón rival adyacente que acaba de avanzar dos casillas como si solo hubiera avanzado una. Solo puede hacerse inmediatamente.",
    ),
    "Chess_Goal_Body": MessageLookupByLibrary.simpleMessage(
      "Da jaque mate al rey rival. El jaque mate ocurre cuando el rey está atacado y no tiene ninguna forma legal de escapar.",
    ),
    "Chess_Goal_Title": MessageLookupByLibrary.simpleMessage("El objetivo"),
    "Chess_King_Rule": MessageLookupByLibrary.simpleMessage(
      "Rey — mueve una casilla en cualquier dirección y nunca puede entrar en jaque.",
    ),
    "Chess_Knight_Rule": MessageLookupByLibrary.simpleMessage(
      "Caballo — mueve en forma de L: dos casillas en una dirección y una hacia un lado. Puede saltar sobre otras piezas.",
    ),
    "Chess_Pawn_Rule": MessageLookupByLibrary.simpleMessage(
      "Peón — avanza una casilla, o dos desde su posición inicial, y captura una casilla en diagonal hacia delante.",
    ),
    "Chess_Pieces_Title": MessageLookupByLibrary.simpleMessage(
      "Cómo se mueven las piezas",
    ),
    "Chess_Promotion_Rule": MessageLookupByLibrary.simpleMessage(
      "Promoción — un peón que llega a la última fila se convierte en dama, torre, alfil o caballo.",
    ),
    "Chess_Queen_Rule": MessageLookupByLibrary.simpleMessage(
      "Dama — mueve cualquier número de casillas por filas, columnas o diagonales.",
    ),
    "Chess_Rook_Rule": MessageLookupByLibrary.simpleMessage(
      "Torre — mueve cualquier número de casillas en horizontal o vertical.",
    ),
    "Chess_Room": MessageLookupByLibrary.simpleMessage("Chess Room"),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "Resultado de Chess Room",
    ),
    "Chess_Setup_Body": MessageLookupByLibrary.simpleMessage(
      "Coloca el tablero con una casilla clara a la derecha de cada jugador. La fila trasera es torre, caballo, alfil, dama, rey, alfil, caballo y torre; la dama empieza en su propio color. Los peones ocupan la fila delantera. Las blancas mueven primero.",
    ),
    "Chess_Setup_Title": MessageLookupByLibrary.simpleMessage(
      "Colocación del tablero",
    ),
    "Chess_Special_Moves_Title": MessageLookupByLibrary.simpleMessage(
      "Movimientos especiales",
    ),
    "Chess_Tips_Body": MessageLookupByLibrary.simpleMessage(
      "Controla el centro, desarrolla pronto caballos y alfiles, enrócate para proteger al rey y revisa las amenazas del rival antes de cada jugada.",
    ),
    "Chess_Tips_Title": MessageLookupByLibrary.simpleMessage(
      "Consejos para principiantes",
    ),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage(
      "Caja de música clásica",
    ),
    "Clock_Active": MessageLookupByLibrary.simpleMessage("Juegan"),
    "Clock_Black": MessageLookupByLibrary.simpleMessage("Negras"),
    "Clock_White": MessageLookupByLibrary.simpleMessage("Blancas"),
    "Continue_Game": MessageLookupByLibrary.simpleMessage("Continuar partida"),
    "Continue_Game_Description": MessageLookupByLibrary.simpleMessage(
      "Retoma donde lo dejaste",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("¡Correcto! Jaque mate."),
    "Daily_Practice_Complete": MessageLookupByLibrary.simpleMessage(
      "Reto de hoy completado · sigue practicando",
    ),
    "Daily_Practice_Ready": MessageLookupByLibrary.simpleMessage(
      "Un nuevo reto para hoy",
    ),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("Problema diario"),
    "Delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "Delete_Game_Failed": MessageLookupByLibrary.simpleMessage(
      "No se pudo eliminar esta partida. Inténtalo de nuevo.",
    ),
    "Delete_Game_Message": MessageLookupByLibrary.simpleMessage(
      "La partida guardada se eliminará de este dispositivo. No se puede deshacer.",
    ),
    "Delete_Game_Title": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar esta partida?",
    ),
    "Done": MessageLookupByLibrary.simpleMessage("Hecho"),
    "Draw": MessageLookupByLibrary.simpleMessage("Tablas"),
    "Easy": MessageLookupByLibrary.simpleMessage("Fácil"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("Easy Unit"),
    "Empty_Square": m0,
    "Export_PGN": MessageLookupByLibrary.simpleMessage("Copiar PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("Extrema"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage(
      "Puzzle de bloques",
    ),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage(
      "Encuentra la mejor jugada.",
    ),
    "First_Move": MessageLookupByLibrary.simpleMessage("Primera jugada"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage(
      "Lanzamiento de cuchillos",
    ),
    "Flip_Board": MessageLookupByLibrary.simpleMessage("Girar tablero"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage(
      "Revisión completa de la partida",
    ),
    "Game_History": MessageLookupByLibrary.simpleMessage(
      "Historial de partidas",
    ),
    "Game_Replay": MessageLookupByLibrary.simpleMessage(
      "Repetición de la partida",
    ),
    "Game_Setup_Description": MessageLookupByLibrary.simpleMessage(
      "Elige un desafío a tu nivel y realiza tu primera jugada.",
    ),
    "Gameplay_Settings": MessageLookupByLibrary.simpleMessage("Juego"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("Buena jugada"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "Esta jugada se acerca a la mejor opción del motor.",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("Difícil"),
    "Help_And_Privacy": MessageLookupByLibrary.simpleMessage(
      "Ayuda y privacidad",
    ),
    "Hints": MessageLookupByLibrary.simpleMessage("Jugadas legales"),
    "Hints_Description": MessageLookupByLibrary.simpleMessage(
      "Mostrar los destinos legales al seleccionar una pieza.",
    ),
    "Home_AI_Description": MessageLookupByLibrary.simpleMessage(
      "Elige nivel, color y ritmo de juego",
    ),
    "Home_Local_Description": MessageLookupByLibrary.simpleMessage(
      "Jugad juntos en un mismo dispositivo",
    ),
    "Home_Play_Options": MessageLookupByLibrary.simpleMessage(
      "Más formas de jugar",
    ),
    "Home_Subtitle": MessageLookupByLibrary.simpleMessage(
      "Juega una partida. Mejora tu próxima jugada.",
    ),
    "Home_Training_Description": MessageLookupByLibrary.simpleMessage(
      "Problemas y aperturas guiadas",
    ),
    "How_To_Play_Chess": MessageLookupByLibrary.simpleMessage(
      "Cómo jugar al ajedrez",
    ),
    "How_To_Play_Intro": MessageLookupByLibrary.simpleMessage(
      "Aprende las reglas esenciales y después usa Entrenamiento para practicar tácticas y aperturas.",
    ),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("Image Guru"),
    "Import": MessageLookupByLibrary.simpleMessage("Importar"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("Importar PGN"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("Imprecisión"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "Esta jugada cede una pequeña parte de la ventaja de la posición.",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("Instant Face"),
    "Last_Move": MessageLookupByLibrary.simpleMessage("Última jugada"),
    "Local_Data_Unavailable": MessageLookupByLibrary.simpleMessage(
      "Los datos guardados no están disponibles temporalmente. Inténtalo de nuevo.",
    ),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("Mate en uno"),
    "Mate_In_Two": MessageLookupByLibrary.simpleMessage("Mate en dos"),
    "Medium": MessageLookupByLibrary.simpleMessage("Media"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("Metronome Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("Minesweeper Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("Mint Translate"),
    "Minute_Count": m1,
    "Mistake": MessageLookupByLibrary.simpleMessage("Error"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "Una jugada más fuerte habría mantenido una posición mucho mejor.",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("Control de gastos"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("Más aplicaciones"),
    "Move_Count": m2,
    "Move_Of": m3,
    "Next": MessageLookupByLibrary.simpleMessage("Siguiente"),
    "Next_Move": MessageLookupByLibrary.simpleMessage("Jugada siguiente"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("Siguiente problema"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("Sin límite"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage(
      "Las partidas completadas e importadas aparecerán aquí.",
    ),
    "Not_Now": MessageLookupByLibrary.simpleMessage("Ahora no"),
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
    "Opening_Move_Prompt": m4,
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
    "Openings_Completed_Count": m5,
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
    "Pawns_Lost": m6,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("Elige tu bando"),
    "Piece_Black_Bishop": MessageLookupByLibrary.simpleMessage("Alfil negro"),
    "Piece_Black_King": MessageLookupByLibrary.simpleMessage("Rey negro"),
    "Piece_Black_Knight": MessageLookupByLibrary.simpleMessage("Caballo negro"),
    "Piece_Black_Pawn": MessageLookupByLibrary.simpleMessage("Peón negro"),
    "Piece_Black_Queen": MessageLookupByLibrary.simpleMessage("Dama negra"),
    "Piece_Black_Rook": MessageLookupByLibrary.simpleMessage("Torre negra"),
    "Piece_On_Square": m7,
    "Piece_Set": MessageLookupByLibrary.simpleMessage("Juego de piezas"),
    "Piece_White_Bishop": MessageLookupByLibrary.simpleMessage("Alfil blanco"),
    "Piece_White_King": MessageLookupByLibrary.simpleMessage("Rey blanco"),
    "Piece_White_Knight": MessageLookupByLibrary.simpleMessage(
      "Caballo blanco",
    ),
    "Piece_White_Pawn": MessageLookupByLibrary.simpleMessage("Peón blanco"),
    "Piece_White_Queen": MessageLookupByLibrary.simpleMessage("Dama blanca"),
    "Piece_White_Rook": MessageLookupByLibrary.simpleMessage("Torre blanca"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("Jugada"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage(
      "Practicar de nuevo",
    ),
    "Premium": MessageLookupByLibrary.simpleMessage("Premium"),
    "Premium_Active": MessageLookupByLibrary.simpleMessage(
      "Premium está activo en este dispositivo.",
    ),
    "Premium_Benefit_History": MessageLookupByLibrary.simpleMessage(
      "Tu archivo completo de partidas",
    ),
    "Premium_Benefit_No_Ads": MessageLookupByLibrary.simpleMessage(
      "Sin anuncios",
    ),
    "Premium_Benefit_Play": MessageLookupByLibrary.simpleMessage(
      "Se restaura con tu cuenta de Google Play",
    ),
    "Premium_Benefit_Review": MessageLookupByLibrary.simpleMessage(
      "Análisis de partidas ilimitado",
    ),
    "Premium_Benefit_Shared": MessageLookupByLibrary.simpleMessage(
      "Una sola compra para iPhone, iPad y Mac",
    ),
    "Premium_Benefit_Themes": MessageLookupByLibrary.simpleMessage(
      "Todos los temas de tablero y juegos de piezas",
    ),
    "Premium_Benefit_Training": MessageLookupByLibrary.simpleMessage(
      "Ejercicios ilimitados y todos los cursos de apertura",
    ),
    "Premium_Description": MessageLookupByLibrary.simpleMessage(
      "Una sola compra desbloquea todos los temas, el entrenamiento ilimitado y tu archivo completo de partidas, y elimina los anuncios.",
    ),
    "Premium_Loading": MessageLookupByLibrary.simpleMessage(
      "Cargando opciones de compra...",
    ),
    "Premium_Locked_Board_Theme": MessageLookupByLibrary.simpleMessage(
      "Este tema de tablero forma parte de Premium.",
    ),
    "Premium_Locked_History": m8,
    "Premium_Locked_Opening": MessageLookupByLibrary.simpleMessage(
      "Este curso de apertura forma parte de Premium.",
    ),
    "Premium_Locked_Piece_Theme": MessageLookupByLibrary.simpleMessage(
      "Este juego de piezas forma parte de Premium.",
    ),
    "Premium_Puzzles_Left": m9,
    "Premium_Puzzles_Spent": MessageLookupByLibrary.simpleMessage(
      "Has usado los ejercicios gratuitos de hoy.",
    ),
    "Premium_Reviews_Left": m10,
    "Premium_Reviews_Spent": MessageLookupByLibrary.simpleMessage(
      "Has usado los análisis gratuitos de hoy.",
    ),
    "Premium_Unavailable": MessageLookupByLibrary.simpleMessage(
      "Premium no está disponible en este momento.",
    ),
    "Premium_Unlimited": MessageLookupByLibrary.simpleMessage(
      "Ilimitado con Premium",
    ),
    "Premium_Unlock": MessageLookupByLibrary.simpleMessage(
      "Desbloquear Premium",
    ),
    "Premium_Unlock_With_Price": m11,
    "Previous": MessageLookupByLibrary.simpleMessage("Anterior"),
    "Previous_Move": MessageLookupByLibrary.simpleMessage("Jugada anterior"),
    "Privacy_Choices": MessageLookupByLibrary.simpleMessage(
      "Opciones de privacidad",
    ),
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
      "Compra restaurada. Premium está desbloqueado.",
    ),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage(
      "Compra completada. Premium está desbloqueado.",
    ),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage(
      "¡Problema completado!",
    ),
    "Puzzle_Easy": MessageLookupByLibrary.simpleMessage("Fácil"),
    "Puzzle_Explain_Back_Rank": MessageLookupByLibrary.simpleMessage(
      "Los peones bloquean la salida del rey. Da jaque en la última fila para terminar la partida.",
    ),
    "Puzzle_Explain_Bishop_Mate": MessageLookupByLibrary.simpleMessage(
      "Coordina el alfil con tus otras piezas para cubrir las casillas de escape del rey.",
    ),
    "Puzzle_Explain_Combination": MessageLookupByLibrary.simpleMessage(
      "Usa jaques forzados para limitar las respuestas y termina con jaque mate.",
    ),
    "Puzzle_Explain_Fork": MessageLookupByLibrary.simpleMessage(
      "Da jaque al rey y ataca otra pieza valiosa al mismo tiempo.",
    ),
    "Puzzle_Explain_Knight_Mate": MessageLookupByLibrary.simpleMessage(
      "El caballo da jaque al rey mientras tus otras piezas cubren sus casillas de escape.",
    ),
    "Puzzle_Explain_Promotion": MessageLookupByLibrary.simpleMessage(
      "Corona el peón de forma segura para conseguir una dama.",
    ),
    "Puzzle_Explain_Queen_Net": MessageLookupByLibrary.simpleMessage(
      "Coordina la dama con las piezas de apoyo para cubrir todas las casillas de escape.",
    ),
    "Puzzle_Explain_Rook_Mate": MessageLookupByLibrary.simpleMessage(
      "Corta las vías de escape del rey y después da jaque por el borde del tablero.",
    ),
    "Puzzle_Hard": MessageLookupByLibrary.simpleMessage("Difícil"),
    "Puzzle_Hint": MessageLookupByLibrary.simpleMessage("Mostrar pista"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "Juegan blancas o negras. Encuentra el mate en una jugada.",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage(
      "Biblioteca de problemas",
    ),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "Practica temas específicos a tu ritmo. El progreso se guarda en este dispositivo.",
    ),
    "Puzzle_Line_Progress": MessageLookupByLibrary.simpleMessage(
      "Continúa la combinación",
    ),
    "Puzzle_Medium": MessageLookupByLibrary.simpleMessage("Media"),
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
      "Seguir practicando",
    ),
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage(
      "El problema de hoy está completado.",
    ),
    "Puzzle_Streak": m22,
    "Puzzle_Why_This_Works": MessageLookupByLibrary.simpleMessage(
      "Por qué funciona",
    ),
    "Puzzles_Completed_Count": m23,
    "Puzzles_Solved": m24,
    "Quick_Play": MessageLookupByLibrary.simpleMessage("Partida rápida"),
    "Quick_Play_Description": MessageLookupByLibrary.simpleMessage(
      "Juega contra la IA con tus últimos ajustes",
    ),
    "Redo_Move": MessageLookupByLibrary.simpleMessage("Rehacer jugada"),
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("Eliminar anuncios"),
    "Replace_Unfinished_Game": MessageLookupByLibrary.simpleMessage(
      "¿Empezar una nueva partida?",
    ),
    "Replace_Unfinished_Game_Description": MessageLookupByLibrary.simpleMessage(
      "Se reemplazará tu partida sin terminar.",
    ),
    "Replay": MessageLookupByLibrary.simpleMessage("Reproducir"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "No se encontró ninguna compra anterior de Premium.",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage(
      "Restaurar compras",
    ),
    "Resume_Game_Unavailable": MessageLookupByLibrary.simpleMessage(
      "No se pudo restaurar esta partida. Puedes empezar una nueva.",
    ),
    "Retry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("Analizar partida"),
    "Review_Move_Title": m25,
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
    "Sound": MessageLookupByLibrary.simpleMessage("Sonido"),
    "Sound_Description": MessageLookupByLibrary.simpleMessage(
      "Reproducir sonidos al mover las piezas.",
    ),
    "Stalemate": MessageLookupByLibrary.simpleMessage("Ahogado"),
    "Start": MessageLookupByLibrary.simpleMessage("Empezar"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("Sudoku Lover"),
    "Theme_Back_Rank": MessageLookupByLibrary.simpleMessage("Mate del pasillo"),
    "Theme_Bishop_Mate": MessageLookupByLibrary.simpleMessage("Mate con alfil"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("Jaque mate"),
    "Theme_Combination": MessageLookupByLibrary.simpleMessage("Combinaciones"),
    "Theme_Double_Attack": MessageLookupByLibrary.simpleMessage("Ataque doble"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage(
      "Horquillas de caballo",
    ),
    "Theme_Knight_Mate": MessageLookupByLibrary.simpleMessage(
      "Mate con caballo",
    ),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage(
      "Promoción de peón",
    ),
    "Theme_Queen_Net": MessageLookupByLibrary.simpleMessage("Mate con dama"),
    "Theme_Rook_Mate": MessageLookupByLibrary.simpleMessage("Mate con torre"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("Límite de tiempo"),
    "Tip": MessageLookupByLibrary.simpleMessage("Sugerir jugada"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("Botón de sugerencias"),
    "Tip_Button_Description": MessageLookupByLibrary.simpleMessage(
      "Mostrar un botón que sugiere una jugada mejor.",
    ),
    "Training": MessageLookupByLibrary.simpleMessage("Entrenamiento"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "Elige una sesión de problemas específica o aprende una variante de apertura fiable.",
    ),
    "Training_Progress": MessageLookupByLibrary.simpleMessage("Tu progreso"),
    "Training_Progress_Unavailable": MessageLookupByLibrary.simpleMessage(
      "El progreso no está disponible temporalmente. Inténtalo de nuevo.",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage(
      "No del todo — inténtalo de nuevo",
    ),
    "Two_Players": MessageLookupByLibrary.simpleMessage("Dos jugadores"),
    "Undo": MessageLookupByLibrary.simpleMessage("Deshacer/Rehacer"),
    "Undo_Description": MessageLookupByLibrary.simpleMessage(
      "Permitir deshacer y rehacer jugadas.",
    ),
    "Undo_Move": MessageLookupByLibrary.simpleMessage("Deshacer jugada"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("Partida sin terminar"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage(
      "Configurar partida contra la IA",
    ),
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
