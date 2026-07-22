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

  static String m0(count) => "${count} د";

  static String m1(count) => "${count} نقلة";

  static String m2(current, total) => "النقلة ${current} من ${total}";

  static String m3(current, total, side) =>
      "النقلة ${current} من ${total}: العب بـ${side}";

  static String m4(value) => "خسرت ما يعادل ${value} بيادق من التقييم";

  static String m5(current, total) => "اللغز ${current} من ${total}";

  static String m6(count) => "السلسلة: ${count}";

  static String m7(solved, total) => "تم حل ${solved} من ${total}";

  static String m8(price) => "إزالة الإعلانات ${price}";

  static String m9(current, total, classification) =>
      "النقلة ${current} من ${total}: ${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage(
      "مستوى صعوبة الذكاء الاصطناعي",
    ),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage(
      "الذكاء الاصطناعي يفكر",
    ),
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
    "Correct": MessageLookupByLibrary.simpleMessage("صحيح! كش مات."),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("لغز اليوم"),
    "Done": MessageLookupByLibrary.simpleMessage("تم"),
    "Draw": MessageLookupByLibrary.simpleMessage("تعادل"),
    "Easy": MessageLookupByLibrary.simpleMessage("سهل"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("وحدات سهلة"),
    "Export_PGN": MessageLookupByLibrary.simpleMessage("نسخ PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("فائق"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage(
      "لغز الكتل المتساقطة",
    ),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage("أوجد أفضل نقلة."),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("رمي السكاكين"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage(
      "مراجعة كاملة للمباراة",
    ),
    "Game_History": MessageLookupByLibrary.simpleMessage("سجل المباريات"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("إعادة عرض المباراة"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("نقلة جيدة"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "هذه النقلة قريبة من أفضل خيار يقترحه المحرك.",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("صعب"),
    "Hints": MessageLookupByLibrary.simpleMessage("تلميحات"),
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
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("كش مات في نقلة واحدة"),
    "Medium": MessageLookupByLibrary.simpleMessage("متوسط"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("بندول الإيقاع Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("كاسحة الألغام Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("ترجمة Mint"),
    "Minute_Count": m0,
    "Mistake": MessageLookupByLibrary.simpleMessage("خطأ"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "كان من الممكن لنقلة أقوى أن تحافظ على وضع أفضل بكثير.",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("متتبع الأموال"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("المزيد من التطبيقات"),
    "Move_Count": m1,
    "Move_Of": m2,
    "Next": MessageLookupByLibrary.simpleMessage("التالي"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("اللغز التالي"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("بلا حد"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage(
      "ستظهر المباريات المكتملة والمستوردة هنا.",
    ),
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
    "Opening_Move_Prompt": m3,
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
    "Pawns_Lost": m4,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("اختر جانبك"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("النقلة الملعوبة"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("تدرّب مجددًا"),
    "Previous": MessageLookupByLibrary.simpleMessage("السابق"),
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
      "تمت استعادة عملية الشراء وإزالة الإعلانات.",
    ),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage(
      "اكتملت عملية الشراء. تمت إزالة الإعلانات.",
    ),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage("اكتمل اللغز!"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "دور الأبيض أو الأسود. أوجد كش مات في نقلة واحدة.",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("مكتبة الألغاز"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "تدرّب على موضوعات محددة بالسرعة التي تناسبك. يُحفظ تقدمك على هذا الجهاز.",
    ),
    "Puzzle_Number": m5,
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage("اكتمل لغز اليوم."),
    "Puzzle_Streak": m6,
    "Puzzles_Solved": m7,
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("إزالة الإعلانات"),
    "Remove_Ads_Description": MessageLookupByLibrary.simpleMessage(
      "إزالة الإعلانات نهائيًا من هذا التطبيق.",
    ),
    "Remove_Ads_Loading": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل خيارات الشراء…",
    ),
    "Remove_Ads_Purchased": MessageLookupByLibrary.simpleMessage(
      "تمت إزالة الإعلانات على هذا الجهاز.",
    ),
    "Remove_Ads_Unavailable": MessageLookupByLibrary.simpleMessage(
      "إزالة الإعلانات غير متاحة حاليًا.",
    ),
    "Remove_Ads_With_Price": m8,
    "Replay": MessageLookupByLibrary.simpleMessage("إعادة اللعب"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على عملية شراء سابقة لإزالة الإعلانات.",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage(
      "استعادة المشتريات",
    ),
    "Review_Game": MessageLookupByLibrary.simpleMessage("مراجعة أكبر خطأ"),
    "Review_Move_Title": m9,
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
    "Stalemate": MessageLookupByLibrary.simpleMessage("تعادل بالخنق"),
    "Start": MessageLookupByLibrary.simpleMessage("ابدأ"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("عاشق السودوكو"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("كش مات"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("شوكات الحصان"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("ترقية البيدق"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("الحد الزمني"),
    "Tip": MessageLookupByLibrary.simpleMessage("تلميح"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("إظهار زر التلميح"),
    "Training": MessageLookupByLibrary.simpleMessage("التدريب"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "اختر جلسة ألغاز مركزة أو تعلّم خط افتتاح موثوقًا.",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage(
      "ليست النقلة الصحيحة — حاول مجددًا",
    ),
    "Two_Players": MessageLookupByLibrary.simpleMessage("لاعبان"),
    "Undo": MessageLookupByLibrary.simpleMessage("تراجع/إعادة"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("مباراة غير مكتملة"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("ضد الذكاء الاصطناعي"),
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
