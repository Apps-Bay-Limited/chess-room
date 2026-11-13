// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(square) => "مربع فارغ ${square}";

  static String m1(count) => "${count} د";

  static String m2(count) => "${count} نقلة";

  static String m3(current, total) => "النقلة ${current} من ${total}";

  static String m4(current, total, side) =>
      "النقلة ${current} من ${total}: العب بـ${side}";

  static String m5(completed, total) =>
      "اكتمل ${completed} من ${total} افتتاحية";

  static String m6(value) => "خسرت ما يعادل ${value} بيادق من التقييم";

  static String m7(piece, square) => "${piece} على ${square}";

  static String m8(count) =>
      "يتم الاحتفاظ بـ ${count} مباريات أقدم مع النسخة المميزة.";

  static String m9(count) => "بقي لك ${count} ألغاز مجانية اليوم";

  static String m10(count) => "بقي لك ${count} مراجعات مجانية اليوم";

  static String m11(price) => "فتح النسخة المميزة ${price}";

  static String m12(current, total) => "اللغز ${current} من ${total}";

  static String m13(piece, support, square) =>
      "إغلاق الهروب: ${piece} على ${support} يسيطر على ${square}.";

  static String m14(from, king, target) =>
      "من ${from}، يهدد الحصان الملك على ${king} بالكش ويهاجم أيضًا ${target}.";

  static String m15(line) => "أحد الحلول: ${line}.";

  static String m16(square) =>
      "كش مات للملك على ${square}: لا توجد نقلة قانونية للهروب أو الأخذ أو الحجب.";

  static String m17(piece, from, to) => "${piece}: ${from} → ${to}.";

  static String m18(squares) =>
      "بيادق الطرف المدافع على ${squares} تسدّ طريق هروب ملكها.";

  static String m19(square, piece) =>
      "يصل البيدق إلى ${square} ويترقّى إلى ${piece}.";

  static String m20(reply, finish) =>
      "بعد ${reply}، تحقق النقلة ${finish} كش مات.";

  static String m21(piece, support, square) =>
      "الدعم: ${piece} على ${support} يحمي ${square}.";

  static String m22(count) => "السلسلة: ${count}";

  static String m23(completed, total) => "اكتمل ${completed} من ${total} لغزًا";

  static String m24(solved, total) => "تم حل ${solved} من ${total}";

  static String m25(current, total, classification) =>
      "النقلة ${current} من ${total}: ${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage(
      "مستوى صعوبة الذكاء الاصطناعي",
    ),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage(
      "الذكاء الاصطناعي يفكر",
    ),
    "Appearance": MessageLookupByLibrary.simpleMessage("المظهر"),
    "Back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "Best_Move": MessageLookupByLibrary.simpleMessage("أفضل نقلة"),
    "Biggest_Mistake": MessageLookupByLibrary.simpleMessage("أكبر خطأ"),
    "Black": MessageLookupByLibrary.simpleMessage("الأسود"),
    "Black_Wins": MessageLookupByLibrary.simpleMessage("فاز الأسود!"),
    "Blacks_Turn": MessageLookupByLibrary.simpleMessage("دور الأسود"),
    "Blunder": MessageLookupByLibrary.simpleMessage("خطأ فادح"),
    "Blunder_Explanation": MessageLookupByLibrary.simpleMessage(
      "تؤدي هذه النقلة إلى خسارة كبيرة في القطع أو تسمح بهجوم حاسم.",
    ),
    "Board_Coordinates": MessageLookupByLibrary.simpleMessage(
      "إحداثيات الرقعة",
    ),
    "Board_Coordinates_Description": MessageLookupByLibrary.simpleMessage(
      "إظهار الأعمدة والصفوف حول الرقعة.",
    ),
    "Board_Theme": MessageLookupByLibrary.simpleMessage("سمة الرقعة"),
    "Cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "Chess_Bishop_Rule": MessageLookupByLibrary.simpleMessage(
      "الفيل — يتحرك أي عدد من المربعات قطريًا.",
    ),
    "Chess_Castling_Rule": MessageLookupByLibrary.simpleMessage(
      "التبييت — حرّك الملك مربعين نحو الرخ، ثم ضع الرخ بجانب الملك. يجب ألا تكون القطعتان قد تحركتا، وأن يكون المسار خاليًا، وألا يكون الملك مهددًا أو يمر بمربع مهدد أو ينتهي فيه.",
    ),
    "Chess_Check_Body": MessageLookupByLibrary.simpleMessage(
      "عندما يكون ملكك في كش، يجب تحريك الملك أو أخذ القطعة المهاجمة أو صد الهجوم. إذا لم توجد استجابة قانونية، فهي كش مات وتنتهي المباراة.",
    ),
    "Chess_Check_Title": MessageLookupByLibrary.simpleMessage("الكش وكش مات"),
    "Chess_Draws_Body": MessageLookupByLibrary.simpleMessage(
      "يمكن أن تنتهي المباراة بالتعادل بسبب الخنق، أو اتفاق اللاعبين، أو عدم كفاية القطع للإماتة، أو تكرار الوضع ثلاث مرات، أو مرور خمسين نقلة لكل طرف بلا حركة بيدق أو أخذ قطعة.",
    ),
    "Chess_Draws_Title": MessageLookupByLibrary.simpleMessage("التعادل"),
    "Chess_En_Passant_Rule": MessageLookupByLibrary.simpleMessage(
      "الأخذ بالتجاوز — يمكن للبيدق أخذ بيدق خصم مجاور تحرك للتو مربعين كما لو أنه تحرك مربعًا واحدًا. لا يُسمح بذلك إلا في النقلة التالية مباشرة.",
    ),
    "Chess_Goal_Body": MessageLookupByLibrary.simpleMessage(
      "أمِت ملك الخصم. كش مات تعني أن الملك يتعرض للهجوم ولا يملك أي طريقة قانونية للهروب.",
    ),
    "Chess_Goal_Title": MessageLookupByLibrary.simpleMessage("الهدف"),
    "Chess_King_Rule": MessageLookupByLibrary.simpleMessage(
      "الملك — يتحرك مربعًا واحدًا في أي اتجاه، ولا يجوز له الانتقال إلى مربع مهدد.",
    ),
    "Chess_Knight_Rule": MessageLookupByLibrary.simpleMessage(
      "الحصان — يتحرك على شكل حرف L: مربعين في اتجاه ثم مربعًا إلى الجانب، ويمكنه القفز فوق القطع.",
    ),
    "Chess_Pawn_Rule": MessageLookupByLibrary.simpleMessage(
      "البيدق — يتحرك مربعًا واحدًا للأمام، أو مربعين من موضع البداية، ويأخذ قطعة على مربع قطري أمامه.",
    ),
    "Chess_Pieces_Title": MessageLookupByLibrary.simpleMessage("حركة القطع"),
    "Chess_Promotion_Rule": MessageLookupByLibrary.simpleMessage(
      "الترقية — عندما يصل البيدق إلى الصف الأخير، يتحول إلى ملكة أو رخ أو فيل أو حصان.",
    ),
    "Chess_Queen_Rule": MessageLookupByLibrary.simpleMessage(
      "الملكة — تتحرك أي عدد من المربعات أفقيًا أو عموديًا أو قطريًا.",
    ),
    "Chess_Rook_Rule": MessageLookupByLibrary.simpleMessage(
      "الرخ — يتحرك أي عدد من المربعات أفقيًا أو عموديًا.",
    ),
    "Chess_Room": MessageLookupByLibrary.simpleMessage("غرفة الشطرنج"),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "نتيجة Chess Room",
    ),
    "Chess_Setup_Body": MessageLookupByLibrary.simpleMessage(
      "ضع الرقعة بحيث يكون المربع الفاتح على يمين كل لاعب. ترتيب الصف الخلفي: رخ، حصان، فيل، ملكة، ملك، فيل، حصان، رخ؛ وتبدأ الملكة على مربع من لونها. تملأ البيادق الصف الأمامي، ويبدأ الأبيض.",
    ),
    "Chess_Setup_Title": MessageLookupByLibrary.simpleMessage("ترتيب الرقعة"),
    "Chess_Special_Moves_Title": MessageLookupByLibrary.simpleMessage(
      "النقلات الخاصة",
    ),
    "Chess_Tips_Body": MessageLookupByLibrary.simpleMessage(
      "سيطر على الوسط، وطوّر الأحصنة والفيلة مبكرًا، وقم بالتبييت لحماية ملكك، وتحقق من تهديدات خصمك قبل كل نقلة.",
    ),
    "Chess_Tips_Title": MessageLookupByLibrary.simpleMessage("نصائح للمبتدئين"),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage(
      "صندوق الموسيقى الكلاسيكية",
    ),
    "Clock_Active": MessageLookupByLibrary.simpleMessage("صاحب الدور"),
    "Clock_Black": MessageLookupByLibrary.simpleMessage("الأسود"),
    "Clock_White": MessageLookupByLibrary.simpleMessage("الأبيض"),
    "Continue_Game": MessageLookupByLibrary.simpleMessage("متابعة المباراة"),
    "Continue_Game_Description": MessageLookupByLibrary.simpleMessage(
      "تابع من حيث توقفت",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("صحيح! كش مات."),
    "Daily_Practice_Complete": MessageLookupByLibrary.simpleMessage(
      "اكتمل تدريب اليوم · واصل التمرين",
    ),
    "Daily_Practice_Ready": MessageLookupByLibrary.simpleMessage(
      "تحدٍّ جديد لهذا اليوم",
    ),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("لغز اليوم"),
    "Delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "Delete_Game_Failed": MessageLookupByLibrary.simpleMessage(
      "تعذّر حذف هذه المباراة. يُرجى المحاولة مجددًا.",
    ),
    "Delete_Game_Message": MessageLookupByLibrary.simpleMessage(
      "ستُحذف المباراة المحفوظة من هذا الجهاز. لا يمكن التراجع عن ذلك.",
    ),
    "Delete_Game_Title": MessageLookupByLibrary.simpleMessage(
      "حذف هذه المباراة؟",
    ),
    "Done": MessageLookupByLibrary.simpleMessage("تم"),
    "Draw": MessageLookupByLibrary.simpleMessage("تعادل"),
    "Easy": MessageLookupByLibrary.simpleMessage("سهل"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("وحدات سهلة"),
    "Empty_Square": m0,
    "Export_PGN": MessageLookupByLibrary.simpleMessage("نسخ PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("فائق"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage(
      "لغز الكتل المتساقطة",
    ),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage("أوجد أفضل نقلة."),
    "First_Move": MessageLookupByLibrary.simpleMessage("النقلة الأولى"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("رمي السكاكين"),
    "Flip_Board": MessageLookupByLibrary.simpleMessage("قلب الرقعة"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage(
      "مراجعة كاملة للمباراة",
    ),
    "Game_History": MessageLookupByLibrary.simpleMessage("سجل المباريات"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("إعادة عرض المباراة"),
    "Game_Setup_Description": MessageLookupByLibrary.simpleMessage(
      "اختر تحديًا مناسبًا لمستواك والعب نقلتك الأولى.",
    ),
    "Gameplay_Settings": MessageLookupByLibrary.simpleMessage("إعدادات اللعب"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("نقلة جيدة"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "هذه النقلة قريبة من أفضل خيار يقترحه المحرك.",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("صعب"),
    "Help_And_Privacy": MessageLookupByLibrary.simpleMessage(
      "المساعدة والخصوصية",
    ),
    "Hints": MessageLookupByLibrary.simpleMessage("النقلات القانونية"),
    "Hints_Description": MessageLookupByLibrary.simpleMessage(
      "إظهار المربعات المتاحة عند اختيار قطعة.",
    ),
    "Home_AI_Description": MessageLookupByLibrary.simpleMessage(
      "اختر المستوى واللون ووقت اللعب",
    ),
    "Home_Local_Description": MessageLookupByLibrary.simpleMessage(
      "العبا معًا على جهاز واحد",
    ),
    "Home_Play_Options": MessageLookupByLibrary.simpleMessage("طرق أخرى للعب"),
    "Home_Subtitle": MessageLookupByLibrary.simpleMessage(
      "العب مباراة. وطوّر نقلتك القادمة.",
    ),
    "Home_Training_Description": MessageLookupByLibrary.simpleMessage(
      "ألغاز وافتتاحيات موجّهة",
    ),
    "How_To_Play_Chess": MessageLookupByLibrary.simpleMessage(
      "كيفية لعب الشطرنج",
    ),
    "How_To_Play_Intro": MessageLookupByLibrary.simpleMessage(
      "تعلّم القواعد الأساسية، ثم استخدم التدريب للتمرن على التكتيكات والافتتاحيات.",
    ),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("خبير الصور"),
    "Import": MessageLookupByLibrary.simpleMessage("استيراد"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("استيراد PGN"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("عدم دقة"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "تتنازل هذه النقلة عن جزء صغير من أفضلية الوضع.",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("الوجه الفوري"),
    "Last_Move": MessageLookupByLibrary.simpleMessage("النقلة الأخيرة"),
    "Local_Data_Unavailable": MessageLookupByLibrary.simpleMessage(
      "البيانات المحفوظة غير متاحة مؤقتًا. يُرجى المحاولة مجددًا.",
    ),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("كش مات في نقلة واحدة"),
    "Mate_In_Two": MessageLookupByLibrary.simpleMessage("مات في نقلتين"),
    "Medium": MessageLookupByLibrary.simpleMessage("متوسط"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("بندول الإيقاع Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("كاسحة الألغام Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("ترجمة Mint"),
    "Minute_Count": m1,
    "Mistake": MessageLookupByLibrary.simpleMessage("خطأ"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "كان من الممكن لنقلة أقوى أن تحافظ على وضع أفضل بكثير.",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("متتبع الأموال"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("المزيد من التطبيقات"),
    "Move_Count": m2,
    "Move_Of": m3,
    "Next": MessageLookupByLibrary.simpleMessage("التالي"),
    "Next_Move": MessageLookupByLibrary.simpleMessage("النقلة التالية"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("اللغز التالي"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("بلا حد"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage(
      "ستظهر المباريات المكتملة والمستوردة هنا.",
    ),
    "Not_Now": MessageLookupByLibrary.simpleMessage("ليس الآن"),
    "Novels_Hub": MessageLookupByLibrary.simpleMessage("مكتبة الروايات"),
    "Onlynote": MessageLookupByLibrary.simpleMessage("Onlynote"),
    "Opening_Complete": MessageLookupByLibrary.simpleMessage(
      "اكتمل الخط! لعبت جميع النقلات بشكل صحيح.",
    ),
    "Opening_Italian": MessageLookupByLibrary.simpleMessage(
      "الافتتاح الإيطالي",
    ),
    "Opening_Italian_Description": MessageLookupByLibrary.simpleMessage(
      "طوّر قطعك بسرعة واضغط على مربع f7 الضعيف.",
    ),
    "Opening_London": MessageLookupByLibrary.simpleMessage("نظام لندن"),
    "Opening_London_Description": MessageLookupByLibrary.simpleMessage(
      "ابنِ وضعًا موثوقًا مع إخراج فيل المربعات السوداء خارج سلسلة البيادق.",
    ),
    "Opening_Move_Prompt": m4,
    "Opening_Queens_Gambit": MessageLookupByLibrary.simpleMessage(
      "جامبيت الملكة",
    ),
    "Opening_Queens_Gambit_Description": MessageLookupByLibrary.simpleMessage(
      "قدّم بيدق الجناح لبناء سيطرة دائمة على المركز.",
    ),
    "Opening_Ruy_Lopez": MessageLookupByLibrary.simpleMessage("روي لوبيز"),
    "Opening_Ruy_Lopez_Description": MessageLookupByLibrary.simpleMessage(
      "هاجم مدافع الأسود المركزي بتثبيت مبكر بواسطة الفيل.",
    ),
    "Opening_Sicilian": MessageLookupByLibrary.simpleMessage("الدفاع الصقلي"),
    "Opening_Sicilian_Description": MessageLookupByLibrary.simpleMessage(
      "أنشئ صراعًا غير متوازن ضد افتتاح بيدق الملك لدى الأبيض.",
    ),
    "Opening_Trainer": MessageLookupByLibrary.simpleMessage("مدرب الافتتاحيات"),
    "Opening_Trainer_Description": MessageLookupByLibrary.simpleMessage(
      "تعلّم أفكار وأولى نقلات خمس افتتاحيات موثوقة.",
    ),
    "Opening_Try_Again": MessageLookupByLibrary.simpleMessage(
      "هذه النقلة خارج خط التدريب. حاول مجددًا.",
    ),
    "Openings_Completed_Count": m5,
    "PGN_Copied": MessageLookupByLibrary.simpleMessage(
      "تم نسخ PGN إلى الحافظة.",
    ),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage(
      "تم استيراد PGN بنجاح.",
    ),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage(
      "تعذر استيراد ملف PGN هذا.",
    ),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("الصق مباراة بصيغة PGN"),
    "Pawns_Lost": m6,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("اختر جانبك"),
    "Piece_Black_Bishop": MessageLookupByLibrary.simpleMessage("فيل أسود"),
    "Piece_Black_King": MessageLookupByLibrary.simpleMessage("ملك أسود"),
    "Piece_Black_Knight": MessageLookupByLibrary.simpleMessage("حصان أسود"),
    "Piece_Black_Pawn": MessageLookupByLibrary.simpleMessage("بيدق أسود"),
    "Piece_Black_Queen": MessageLookupByLibrary.simpleMessage("ملكة سوداء"),
    "Piece_Black_Rook": MessageLookupByLibrary.simpleMessage("رخ أسود"),
    "Piece_On_Square": m7,
    "Piece_Set": MessageLookupByLibrary.simpleMessage("طقم القطع"),
    "Piece_White_Bishop": MessageLookupByLibrary.simpleMessage("فيل أبيض"),
    "Piece_White_King": MessageLookupByLibrary.simpleMessage("ملك أبيض"),
    "Piece_White_Knight": MessageLookupByLibrary.simpleMessage("حصان أبيض"),
    "Piece_White_Pawn": MessageLookupByLibrary.simpleMessage("بيدق أبيض"),
    "Piece_White_Queen": MessageLookupByLibrary.simpleMessage("ملكة بيضاء"),
    "Piece_White_Rook": MessageLookupByLibrary.simpleMessage("رخ أبيض"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("النقلة الملعوبة"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("تدرّب مجددًا"),
    "Premium": MessageLookupByLibrary.simpleMessage("النسخة المميزة"),
    "Premium_Active": MessageLookupByLibrary.simpleMessage(
      "النسخة المميزة مُفعّلة على هذا الجهاز.",
    ),
    "Premium_Benefit_History": MessageLookupByLibrary.simpleMessage(
      "سجل مبارياتك الكامل",
    ),
    "Premium_Benefit_No_Ads": MessageLookupByLibrary.simpleMessage(
      "بدون إعلانات",
    ),
    "Premium_Benefit_Play": MessageLookupByLibrary.simpleMessage(
      "يمكن استعادتها بحساب Google Play نفسه",
    ),
    "Premium_Benefit_Review": MessageLookupByLibrary.simpleMessage(
      "مراجعة مباريات غير محدودة",
    ),
    "Premium_Benefit_Shared": MessageLookupByLibrary.simpleMessage(
      "شراء واحد يشمل iPhone وiPad وMac",
    ),
    "Premium_Benefit_Themes": MessageLookupByLibrary.simpleMessage(
      "كل سمات الرقعة وأطقم القطع",
    ),
    "Premium_Benefit_Training": MessageLookupByLibrary.simpleMessage(
      "ألغاز غير محدودة وكل دورات الافتتاحيات",
    ),
    "Premium_Description": MessageLookupByLibrary.simpleMessage(
      "عملية شراء واحدة تفتح كل السمات والتدريب غير المحدود وسجل مبارياتك الكامل، وتزيل الإعلانات.",
    ),
    "Premium_Loading": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل خيارات الشراء...",
    ),
    "Premium_Locked_Board_Theme": MessageLookupByLibrary.simpleMessage(
      "سمة الرقعة هذه جزء من النسخة المميزة.",
    ),
    "Premium_Locked_History": m8,
    "Premium_Locked_Opening": MessageLookupByLibrary.simpleMessage(
      "دورة الافتتاحية هذه جزء من النسخة المميزة.",
    ),
    "Premium_Locked_Piece_Theme": MessageLookupByLibrary.simpleMessage(
      "طقم القطع هذا جزء من النسخة المميزة.",
    ),
    "Premium_Puzzles_Left": m9,
    "Premium_Puzzles_Spent": MessageLookupByLibrary.simpleMessage(
      "لقد استخدمت ألغاز اليوم المجانية.",
    ),
    "Premium_Reviews_Left": m10,
    "Premium_Reviews_Spent": MessageLookupByLibrary.simpleMessage(
      "لقد استخدمت مراجعات اليوم المجانية.",
    ),
    "Premium_Unavailable": MessageLookupByLibrary.simpleMessage(
      "النسخة المميزة غير متاحة حاليًا.",
    ),
    "Premium_Unlimited": MessageLookupByLibrary.simpleMessage(
      "غير محدود مع النسخة المميزة",
    ),
    "Premium_Unlock": MessageLookupByLibrary.simpleMessage(
      "فتح النسخة المميزة",
    ),
    "Premium_Unlock_With_Price": m11,
    "Previous": MessageLookupByLibrary.simpleMessage("السابق"),
    "Previous_Move": MessageLookupByLibrary.simpleMessage("النقلة السابقة"),
    "Privacy_Choices": MessageLookupByLibrary.simpleMessage("خيارات الخصوصية"),
    "Purchase_Cancelled": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء عملية الشراء.",
    ),
    "Purchase_Failed": MessageLookupByLibrary.simpleMessage(
      "فشلت عملية الشراء. يُرجى المحاولة مجددًا.",
    ),
    "Purchase_In_Progress": MessageLookupByLibrary.simpleMessage(
      "جارٍ الشراء…",
    ),
    "Purchase_Pending": MessageLookupByLibrary.simpleMessage(
      "عملية الشراء بانتظار الموافقة.",
    ),
    "Purchase_Restored": MessageLookupByLibrary.simpleMessage(
      "تمت استعادة الشراء. تم فتح النسخة المميزة.",
    ),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage(
      "تمت عملية الشراء. تم فتح النسخة المميزة.",
    ),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage("اكتمل اللغز!"),
    "Puzzle_Easy": MessageLookupByLibrary.simpleMessage("سهل"),
    "Puzzle_Explain_Back_Rank": MessageLookupByLibrary.simpleMessage(
      "تمنع البيادق الملك من الهروب. وجّه كش على الصف الخلفي لإنهاء المباراة.",
    ),
    "Puzzle_Explain_Bishop_Mate": MessageLookupByLibrary.simpleMessage(
      "نسّق بين الفيل وقطعك الأخرى لتغطية مربعات هروب الملك.",
    ),
    "Puzzle_Explain_Combination": MessageLookupByLibrary.simpleMessage(
      "استخدم نقلات الكش الإجبارية لتقليل الردود، ثم أنهِ الهجوم بكش مات.",
    ),
    "Puzzle_Explain_Fork": MessageLookupByLibrary.simpleMessage(
      "وجّه كش للملك وهاجم قطعة قيّمة أخرى في الوقت نفسه.",
    ),
    "Puzzle_Explain_Knight_Mate": MessageLookupByLibrary.simpleMessage(
      "يوجّه الحصان كش للملك بينما تغطي قطعك الأخرى مربعات هروبه.",
    ),
    "Puzzle_Explain_Promotion": MessageLookupByLibrary.simpleMessage(
      "رقِّ البيدق بأمان للحصول على ملكة.",
    ),
    "Puzzle_Explain_Queen_Net": MessageLookupByLibrary.simpleMessage(
      "نسّق بين الملكة والقطع المساندة لتغطية جميع مربعات الهروب.",
    ),
    "Puzzle_Explain_Rook_Mate": MessageLookupByLibrary.simpleMessage(
      "اغلق مربعات هروب الملك، ثم وجّه كش بمحاذاة حافة الرقعة.",
    ),
    "Puzzle_Hard": MessageLookupByLibrary.simpleMessage("صعب"),
    "Puzzle_Hint": MessageLookupByLibrary.simpleMessage("إظهار تلميح"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "دور الأبيض أو الأسود. أوجد كش مات في نقلة واحدة.",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("مكتبة الألغاز"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "تدرّب على موضوعات محددة بالسرعة التي تناسبك. يُحفظ تقدمك على هذا الجهاز.",
    ),
    "Puzzle_Line_Progress": MessageLookupByLibrary.simpleMessage(
      "أكمل التسلسل التكتيكي",
    ),
    "Puzzle_Medium": MessageLookupByLibrary.simpleMessage("متوسط"),
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
      "واصل التمرين",
    ),
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage("اكتمل لغز اليوم."),
    "Puzzle_Streak": m22,
    "Puzzle_Why_This_Works": MessageLookupByLibrary.simpleMessage(
      "لماذا تنجح هذه الخطة",
    ),
    "Puzzles_Completed_Count": m23,
    "Puzzles_Solved": m24,
    "Quick_Play": MessageLookupByLibrary.simpleMessage("لعب سريع"),
    "Quick_Play_Description": MessageLookupByLibrary.simpleMessage(
      "واجه الذكاء الاصطناعي بآخر إعداداتك",
    ),
    "Redo_Move": MessageLookupByLibrary.simpleMessage("إعادة النقلة"),
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("إزالة الإعلانات"),
    "Replace_Unfinished_Game": MessageLookupByLibrary.simpleMessage(
      "بدء مباراة جديدة؟",
    ),
    "Replace_Unfinished_Game_Description": MessageLookupByLibrary.simpleMessage(
      "ستُستبدل مباراتك غير المكتملة.",
    ),
    "Replay": MessageLookupByLibrary.simpleMessage("إعادة اللعب"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على عملية شراء سابقة للنسخة المميزة.",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage(
      "استعادة المشتريات",
    ),
    "Resume_Game_Unavailable": MessageLookupByLibrary.simpleMessage(
      "تعذرت استعادة هذه المباراة. يمكنك بدء مباراة جديدة.",
    ),
    "Retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("مراجعة المباراة"),
    "Review_Move_Title": m25,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage(
      "إنقاذ سيارة الإسعاف",
    ),
    "Settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "Share_Result": MessageLookupByLibrary.simpleMessage("مشاركة النتيجة"),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage(
      "جارٍ إنشاء بطاقة النتيجة…",
    ),
    "Shows": MessageLookupByLibrary.simpleMessage("العروض"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage(
      "آلة حاسبة بسيطة",
    ),
    "Sound": MessageLookupByLibrary.simpleMessage("الصوت"),
    "Sound_Description": MessageLookupByLibrary.simpleMessage(
      "تشغيل أصوات عند تحريك القطع.",
    ),
    "Stalemate": MessageLookupByLibrary.simpleMessage("تعادل بالخنق"),
    "Start": MessageLookupByLibrary.simpleMessage("ابدأ"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("عاشق السودوكو"),
    "Theme_Back_Rank": MessageLookupByLibrary.simpleMessage("مات الصف الخلفي"),
    "Theme_Bishop_Mate": MessageLookupByLibrary.simpleMessage("مات بالفيل"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("كش مات"),
    "Theme_Combination": MessageLookupByLibrary.simpleMessage(
      "التكتيكات المركبة",
    ),
    "Theme_Double_Attack": MessageLookupByLibrary.simpleMessage("هجوم مزدوج"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("شوكات الحصان"),
    "Theme_Knight_Mate": MessageLookupByLibrary.simpleMessage("مات بالحصان"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("ترقية البيدق"),
    "Theme_Queen_Net": MessageLookupByLibrary.simpleMessage("مات بالملكة"),
    "Theme_Rook_Mate": MessageLookupByLibrary.simpleMessage("مات بالرخ"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("الحد الزمني"),
    "Tip": MessageLookupByLibrary.simpleMessage("اقتراح نقلة"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("زر اقتراح النقلة"),
    "Tip_Button_Description": MessageLookupByLibrary.simpleMessage(
      "إظهار زر يقترح نقلة أقوى.",
    ),
    "Training": MessageLookupByLibrary.simpleMessage("التدريب"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "اختر جلسة ألغاز مركزة أو تعلّم خط افتتاح موثوقًا.",
    ),
    "Training_Progress": MessageLookupByLibrary.simpleMessage("تقدّمك"),
    "Training_Progress_Unavailable": MessageLookupByLibrary.simpleMessage(
      "التقدّم غير متاح مؤقتًا. يُرجى المحاولة مجددًا.",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage(
      "ليست النقلة الصحيحة — حاول مجددًا",
    ),
    "Two_Players": MessageLookupByLibrary.simpleMessage("لاعبان"),
    "Undo": MessageLookupByLibrary.simpleMessage("تراجع/إعادة"),
    "Undo_Description": MessageLookupByLibrary.simpleMessage(
      "السماح بالتراجع عن النقلات وإعادتها.",
    ),
    "Undo_Move": MessageLookupByLibrary.simpleMessage("التراجع عن النقلة"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("مباراة غير مكتملة"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage(
      "إعداد مباراة ضد الذكاء الاصطناعي",
    ),
    "We_Play_Piano": MessageLookupByLibrary.simpleMessage("نعزف البيانو"),
    "White": MessageLookupByLibrary.simpleMessage("الأبيض"),
    "White_Wins": MessageLookupByLibrary.simpleMessage("فاز الأبيض!"),
    "Whites_Turn": MessageLookupByLibrary.simpleMessage("دور الأبيض"),
    "World_Weather_Live": MessageLookupByLibrary.simpleMessage(
      "طقس العالم المباشر",
    ),
    "Yes_Habit": MessageLookupByLibrary.simpleMessage("عادة Yes"),
    "You_Lose": MessageLookupByLibrary.simpleMessage("لقد خسرت"),
    "You_Win": MessageLookupByLibrary.simpleMessage("لقد فزت"),
    "Your_Turn": MessageLookupByLibrary.simpleMessage("دورك"),
  };
}
