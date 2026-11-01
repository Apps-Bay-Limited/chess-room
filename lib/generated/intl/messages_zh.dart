// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(square) => "空格 ${square}";

  static String m1(count) => "${count} 分钟";

  static String m2(count) => "${count} 回合";

  static String m3(current, total) => "第 ${current} 步，共 ${total} 步";

  static String m4(current, total, side) =>
      "第 ${current}/${total} 步：为${side}走棋";

  static String m5(completed, total) => "已完成 ${completed}/${total} 个开局";

  static String m6(value) => "损失 ${value} 个兵的局面分";

  static String m7(piece, square) => "${square} 上的${piece}";

  static String m8(count) => "另有 ${count} 局旧对局需高级版查看。";

  static String m9(count) => "今日还剩 ${count} 道免费习题";

  static String m10(count) => "今日还剩 ${count} 次免费复盘";

  static String m11(price) => "解锁高级版 ${price}";

  static String m12(current, total) => "第 ${current}/${total} 题";

  static String m13(piece, support, square) =>
      "封锁逃路：${support} 上的${piece}控制 ${square}。";

  static String m14(from, king, target) =>
      "马在 ${from} 将军攻击 ${king} 上的王，同时攻击 ${target}。";

  static String m15(line) => "一种解法：${line}。";

  static String m16(square) => "位于 ${square} 的王已被将死：无法逃离、吃掉将军棋子或垫子解将。";

  static String m17(piece, from, to) => "${piece}：${from} → ${to}。";

  static String m18(squares) => "防守方在 ${squares} 的兵挡住了己方王的逃路。";

  static String m19(square, piece) => "兵到达 ${square}，升变为${piece}。";

  static String m20(reply, finish) => "对方走 ${reply} 后，${finish} 将死。";

  static String m21(piece, support, square) =>
      "支援：${support} 上的${piece}保护 ${square}。";

  static String m22(count) => "连续：${count} 天";

  static String m23(completed, total) => "已完成 ${completed}/${total} 道题";

  static String m24(solved, total) => "已完成 ${solved}/${total}";

  static String m25(current, total, classification) =>
      "第 ${current}/${total} 步：${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage("AI难度"),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage("AI正在思考"),
    "Appearance": MessageLookupByLibrary.simpleMessage("外观"),
    "Back": MessageLookupByLibrary.simpleMessage("返回"),
    "Best_Move": MessageLookupByLibrary.simpleMessage("最佳走法"),
    "Biggest_Mistake": MessageLookupByLibrary.simpleMessage("最大失误"),
    "Black": MessageLookupByLibrary.simpleMessage("黑棋"),
    "Black_Wins": MessageLookupByLibrary.simpleMessage("黑棋获胜！"),
    "Blacks_Turn": MessageLookupByLibrary.simpleMessage("轮到黑棋"),
    "Blunder": MessageLookupByLibrary.simpleMessage("严重失误"),
    "Blunder_Explanation": MessageLookupByLibrary.simpleMessage(
      "这步棋会损失大量子力，或让对手发动决定性进攻。",
    ),
    "Board_Coordinates": MessageLookupByLibrary.simpleMessage("棋盘坐标"),
    "Board_Coordinates_Description": MessageLookupByLibrary.simpleMessage(
      "在棋盘边缘显示横纵坐标。",
    ),
    "Board_Theme": MessageLookupByLibrary.simpleMessage("棋盘主题"),
    "Cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "Chess_Bishop_Rule": MessageLookupByLibrary.simpleMessage("象 — 可沿斜线走任意格。"),
    "Chess_Castling_Rule": MessageLookupByLibrary.simpleMessage(
      "王车易位 — 王向车的方向走两格，再把该车放到王的旁边。王和车都必须从未移动，中间没有棋子，并且王不能处于被将军、经过受攻击格或落入受攻击格。",
    ),
    "Chess_Check_Body": MessageLookupByLibrary.simpleMessage(
      "王被将军时，必须移动王、吃掉进攻棋子或阻挡攻击。如果没有合法应对，就是将死，对局结束。",
    ),
    "Chess_Check_Title": MessageLookupByLibrary.simpleMessage("将军与将死"),
    "Chess_Draws_Body": MessageLookupByLibrary.simpleMessage(
      "逼和、双方同意、子力不足、三次重复局面，或双方各连续五十步没有走兵和吃子时，对局为和棋。",
    ),
    "Chess_Draws_Title": MessageLookupByLibrary.simpleMessage("和棋"),
    "Chess_En_Passant_Rule": MessageLookupByLibrary.simpleMessage(
      "吃过路兵 — 相邻的对方兵刚从初始位置走两格时，可以把它当作只走了一格来吃掉，但只能立即执行。",
    ),
    "Chess_Goal_Body": MessageLookupByLibrary.simpleMessage(
      "将死对方的王。将死是指王正受到攻击，并且没有任何合法走法可以脱险。",
    ),
    "Chess_Goal_Title": MessageLookupByLibrary.simpleMessage("游戏目标"),
    "Chess_King_Rule": MessageLookupByLibrary.simpleMessage(
      "王 — 可向任意方向走一格，但不能走入被攻击的格子。",
    ),
    "Chess_Knight_Rule": MessageLookupByLibrary.simpleMessage(
      "马 — 走“日”字，即一个方向两格再向侧面一格，并且可以越过其他棋子。",
    ),
    "Chess_Pawn_Rule": MessageLookupByLibrary.simpleMessage(
      "兵 — 向前走一格，首次可走两格；吃子时向斜前方走一格。",
    ),
    "Chess_Pieces_Title": MessageLookupByLibrary.simpleMessage("棋子的走法"),
    "Chess_Promotion_Rule": MessageLookupByLibrary.simpleMessage(
      "兵升变 — 兵到达最后一排时，可升变为后、车、象或马。",
    ),
    "Chess_Queen_Rule": MessageLookupByLibrary.simpleMessage(
      "后 — 可沿横线、直线或斜线走任意格。",
    ),
    "Chess_Rook_Rule": MessageLookupByLibrary.simpleMessage("车 — 可沿横线或直线走任意格。"),
    "Chess_Room": MessageLookupByLibrary.simpleMessage("国际象棋室"),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "Chess Room 对局结果",
    ),
    "Chess_Setup_Body": MessageLookupByLibrary.simpleMessage(
      "摆放棋盘时，每位玩家的右下角都应为浅色格。底线依次为车、马、象、后、王、象、马、车；后放在与自身颜色相同的格子。兵排在前一行，由白方先走。",
    ),
    "Chess_Setup_Title": MessageLookupByLibrary.simpleMessage("棋盘摆放"),
    "Chess_Special_Moves_Title": MessageLookupByLibrary.simpleMessage("特殊走法"),
    "Chess_Tips_Body": MessageLookupByLibrary.simpleMessage(
      "控制中心，尽早出马和象，通过王车易位保护王，并在每步棋前检查对手的威胁。",
    ),
    "Chess_Tips_Title": MessageLookupByLibrary.simpleMessage("新手技巧"),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage("古典音乐盒"),
    "Clock_Active": MessageLookupByLibrary.simpleMessage("行棋方"),
    "Clock_Black": MessageLookupByLibrary.simpleMessage("黑方"),
    "Clock_White": MessageLookupByLibrary.simpleMessage("白方"),
    "Continue_Game": MessageLookupByLibrary.simpleMessage("继续对局"),
    "Continue_Game_Description": MessageLookupByLibrary.simpleMessage(
      "从上次停下的地方继续",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("正确！将杀。"),
    "Daily_Practice_Complete": MessageLookupByLibrary.simpleMessage(
      "今日已完成 · 继续练习",
    ),
    "Daily_Practice_Ready": MessageLookupByLibrary.simpleMessage("今天的新挑战"),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("每日棋题"),
    "Delete": MessageLookupByLibrary.simpleMessage("删除"),
    "Delete_Game_Failed": MessageLookupByLibrary.simpleMessage("无法删除此对局，请重试。"),
    "Delete_Game_Message": MessageLookupByLibrary.simpleMessage(
      "此对局将从本设备中删除，且无法恢复。",
    ),
    "Delete_Game_Title": MessageLookupByLibrary.simpleMessage("删除此对局？"),
    "Done": MessageLookupByLibrary.simpleMessage("完成"),
    "Draw": MessageLookupByLibrary.simpleMessage("和棋"),
    "Easy": MessageLookupByLibrary.simpleMessage("简单"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("易换算"),
    "Empty_Square": m0,
    "Export_PGN": MessageLookupByLibrary.simpleMessage("复制 PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("非常困难"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage("经典俄罗斯掌机方块"),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage("找出最佳走法。"),
    "First_Move": MessageLookupByLibrary.simpleMessage("第一步"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("西瓜飞刀"),
    "Flip_Board": MessageLookupByLibrary.simpleMessage("翻转棋盘"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage("完整复盘"),
    "Game_History": MessageLookupByLibrary.simpleMessage("对局记录"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("对局回放"),
    "Game_Setup_Description": MessageLookupByLibrary.simpleMessage(
      "选择适合自己的难度，走出第一步。",
    ),
    "Gameplay_Settings": MessageLookupByLibrary.simpleMessage("对弈设置"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("好棋"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "这步棋与引擎推荐的最佳选择十分接近。",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("困难"),
    "Help_And_Privacy": MessageLookupByLibrary.simpleMessage("帮助与隐私"),
    "Hints": MessageLookupByLibrary.simpleMessage("合法走法"),
    "Hints_Description": MessageLookupByLibrary.simpleMessage(
      "选中棋子时，显示可以移动到的位置。",
    ),
    "Home_AI_Description": MessageLookupByLibrary.simpleMessage("选择难度、执棋方和时限"),
    "Home_Local_Description": MessageLookupByLibrary.simpleMessage(
      "与朋友在同一设备上对弈",
    ),
    "Home_Play_Options": MessageLookupByLibrary.simpleMessage("更多对弈方式"),
    "Home_Subtitle": MessageLookupByLibrary.simpleMessage("下好每一局，精进每一步。"),
    "Home_Training_Description": MessageLookupByLibrary.simpleMessage(
      "战术练习与开局指导",
    ),
    "How_To_Play_Chess": MessageLookupByLibrary.simpleMessage("国际象棋玩法"),
    "How_To_Play_Intro": MessageLookupByLibrary.simpleMessage(
      "先学习基本规则，再通过训练练习战术与开局。",
    ),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("咕噜滤镜"),
    "Import": MessageLookupByLibrary.simpleMessage("导入"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("导入 PGN"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("不准确"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "这步棋让出了局面中的一小部分优势。",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("Instant_Face"),
    "Last_Move": MessageLookupByLibrary.simpleMessage("最后一步"),
    "Local_Data_Unavailable": MessageLookupByLibrary.simpleMessage(
      "暂时无法读取已保存的数据，请重试。",
    ),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("一步将杀"),
    "Mate_In_Two": MessageLookupByLibrary.simpleMessage("两步将杀"),
    "Medium": MessageLookupByLibrary.simpleMessage("中等"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("打拍节拍器"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("经典扫雷"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("薄荷翻译"),
    "Minute_Count": m1,
    "Mistake": MessageLookupByLibrary.simpleMessage("失误"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "更强的走法可以保留明显更好的局面。",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("极简记账"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("更多App"),
    "Move_Count": m2,
    "Move_Of": m3,
    "Next": MessageLookupByLibrary.simpleMessage("下一步"),
    "Next_Move": MessageLookupByLibrary.simpleMessage("下一步"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("下一题"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("不限时"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage("完成或导入的对局会显示在这里。"),
    "Not_Now": MessageLookupByLibrary.simpleMessage("暂不"),
    "Novels_Hub": MessageLookupByLibrary.simpleMessage("英文小说站"),
    "Onlynote": MessageLookupByLibrary.simpleMessage("极简备忘录"),
    "Opening_Complete": MessageLookupByLibrary.simpleMessage("变化完成！每一步都正确。"),
    "Opening_Italian": MessageLookupByLibrary.simpleMessage("意大利开局"),
    "Opening_Italian_Description": MessageLookupByLibrary.simpleMessage(
      "快速出子并向薄弱的 f7 格施压。",
    ),
    "Opening_London": MessageLookupByLibrary.simpleMessage("伦敦体系"),
    "Opening_London_Description": MessageLookupByLibrary.simpleMessage(
      "把黑格象放到兵链外，建立稳健的阵型。",
    ),
    "Opening_Move_Prompt": m4,
    "Opening_Queens_Gambit": MessageLookupByLibrary.simpleMessage("后翼弃兵"),
    "Opening_Queens_Gambit_Description": MessageLookupByLibrary.simpleMessage(
      "牺牲翼兵以建立持久的中心控制。",
    ),
    "Opening_Ruy_Lopez": MessageLookupByLibrary.simpleMessage("西班牙开局"),
    "Opening_Ruy_Lopez_Description": MessageLookupByLibrary.simpleMessage(
      "用象早早牵制黑方的中心防守子。",
    ),
    "Opening_Sicilian": MessageLookupByLibrary.simpleMessage("西西里防御"),
    "Opening_Sicilian_Description": MessageLookupByLibrary.simpleMessage(
      "对白方王兵开局制造不对称的复杂战斗。",
    ),
    "Opening_Trainer": MessageLookupByLibrary.simpleMessage("开局训练"),
    "Opening_Trainer_Description": MessageLookupByLibrary.simpleMessage(
      "学习五种可靠开局的思路与前几步走法。",
    ),
    "Opening_Try_Again": MessageLookupByLibrary.simpleMessage("这步不在训练变化中，请重试。"),
    "Openings_Completed_Count": m5,
    "PGN_Copied": MessageLookupByLibrary.simpleMessage("PGN 已复制到剪贴板。"),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage("PGN 导入成功。"),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage("无法导入此 PGN。"),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("粘贴 PGN 对局"),
    "Pawns_Lost": m6,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("选择棋子"),
    "Piece_Black_Bishop": MessageLookupByLibrary.simpleMessage("黑象"),
    "Piece_Black_King": MessageLookupByLibrary.simpleMessage("黑王"),
    "Piece_Black_Knight": MessageLookupByLibrary.simpleMessage("黑马"),
    "Piece_Black_Pawn": MessageLookupByLibrary.simpleMessage("黑兵"),
    "Piece_Black_Queen": MessageLookupByLibrary.simpleMessage("黑后"),
    "Piece_Black_Rook": MessageLookupByLibrary.simpleMessage("黑车"),
    "Piece_On_Square": m7,
    "Piece_Set": MessageLookupByLibrary.simpleMessage("棋子样式"),
    "Piece_White_Bishop": MessageLookupByLibrary.simpleMessage("白象"),
    "Piece_White_King": MessageLookupByLibrary.simpleMessage("白王"),
    "Piece_White_Knight": MessageLookupByLibrary.simpleMessage("白马"),
    "Piece_White_Pawn": MessageLookupByLibrary.simpleMessage("白兵"),
    "Piece_White_Queen": MessageLookupByLibrary.simpleMessage("白后"),
    "Piece_White_Rook": MessageLookupByLibrary.simpleMessage("白车"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("实战走法"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("再次练习"),
    "Premium": MessageLookupByLibrary.simpleMessage("高级版"),
    "Premium_Active": MessageLookupByLibrary.simpleMessage("此设备已启用高级版。"),
    "Premium_Benefit_History": MessageLookupByLibrary.simpleMessage("完整的对局存档"),
    "Premium_Benefit_No_Ads": MessageLookupByLibrary.simpleMessage("无广告"),
    "Premium_Benefit_Review": MessageLookupByLibrary.simpleMessage("无限对局复盘"),
    "Premium_Benefit_Shared": MessageLookupByLibrary.simpleMessage(
      "一次购买，iPhone、iPad 和 Mac 通用",
    ),
    "Premium_Benefit_Themes": MessageLookupByLibrary.simpleMessage(
      "全部棋盘主题与棋子样式",
    ),
    "Premium_Benefit_Training": MessageLookupByLibrary.simpleMessage(
      "无限题库习题与全部开局课程",
    ),
    "Premium_Description": MessageLookupByLibrary.simpleMessage(
      "一次购买即可解锁全部主题、无限训练和完整对局存档，并移除广告。iPhone、iPad 和 Mac 通用。",
    ),
    "Premium_Loading": MessageLookupByLibrary.simpleMessage("正在载入购买选项..."),
    "Premium_Locked_Board_Theme": MessageLookupByLibrary.simpleMessage(
      "此棋盘主题属于高级版。",
    ),
    "Premium_Locked_History": m8,
    "Premium_Locked_Opening": MessageLookupByLibrary.simpleMessage(
      "此开局课程属于高级版。",
    ),
    "Premium_Locked_Piece_Theme": MessageLookupByLibrary.simpleMessage(
      "此棋子样式属于高级版。",
    ),
    "Premium_Puzzles_Left": m9,
    "Premium_Puzzles_Spent": MessageLookupByLibrary.simpleMessage(
      "今日的免费题库习题已用完。",
    ),
    "Premium_Reviews_Left": m10,
    "Premium_Reviews_Spent": MessageLookupByLibrary.simpleMessage(
      "今日的免费复盘次数已用完。",
    ),
    "Premium_Unavailable": MessageLookupByLibrary.simpleMessage("高级版暂时不可用。"),
    "Premium_Unlimited": MessageLookupByLibrary.simpleMessage("高级版无限使用"),
    "Premium_Unlock": MessageLookupByLibrary.simpleMessage("解锁高级版"),
    "Premium_Unlock_With_Price": m11,
    "Previous": MessageLookupByLibrary.simpleMessage("上一步"),
    "Previous_Move": MessageLookupByLibrary.simpleMessage("上一步"),
    "Privacy_Choices": MessageLookupByLibrary.simpleMessage("隐私选项"),
    "Purchase_Cancelled": MessageLookupByLibrary.simpleMessage("购买已取消。"),
    "Purchase_Failed": MessageLookupByLibrary.simpleMessage("购买失败，请重试。"),
    "Purchase_In_Progress": MessageLookupByLibrary.simpleMessage("正在购买..."),
    "Purchase_Pending": MessageLookupByLibrary.simpleMessage("购买正在等待批准。"),
    "Purchase_Restored": MessageLookupByLibrary.simpleMessage("购买已恢复，高级版已解锁。"),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage("购买完成，高级版已解锁。"),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage("棋题完成！"),
    "Puzzle_Easy": MessageLookupByLibrary.simpleMessage("简单"),
    "Puzzle_Explain_Back_Rank": MessageLookupByLibrary.simpleMessage(
      "兵挡住了王的退路。沿底线将军，结束对局。",
    ),
    "Puzzle_Explain_Bishop_Mate": MessageLookupByLibrary.simpleMessage(
      "让象与其他棋子配合，控制王的逃脱格。",
    ),
    "Puzzle_Explain_Combination": MessageLookupByLibrary.simpleMessage(
      "连续将军，限制对方的应对，最后完成将杀。",
    ),
    "Puzzle_Explain_Fork": MessageLookupByLibrary.simpleMessage(
      "将军的同时，攻击另一枚价值较高的棋子。",
    ),
    "Puzzle_Explain_Knight_Mate": MessageLookupByLibrary.simpleMessage(
      "用马将军，同时让其他棋子控制王的逃脱格。",
    ),
    "Puzzle_Explain_Promotion": MessageLookupByLibrary.simpleMessage(
      "让兵安全升变，获得一个后。",
    ),
    "Puzzle_Explain_Queen_Net": MessageLookupByLibrary.simpleMessage(
      "让后与支援棋子配合，控制所有逃脱格。",
    ),
    "Puzzle_Explain_Rook_Mate": MessageLookupByLibrary.simpleMessage(
      "封锁王的逃脱格，再沿棋盘边缘将军。",
    ),
    "Puzzle_Hard": MessageLookupByLibrary.simpleMessage("困难"),
    "Puzzle_Hint": MessageLookupByLibrary.simpleMessage("显示提示"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "轮到白方或黑方。找出一步将杀。",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("棋题库"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "按主题自由练习，进度会保存在此设备上。",
    ),
    "Puzzle_Line_Progress": MessageLookupByLibrary.simpleMessage("继续组合战术"),
    "Puzzle_Medium": MessageLookupByLibrary.simpleMessage("中等"),
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
    "Puzzle_Practice_Next": MessageLookupByLibrary.simpleMessage("继续练习"),
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage("今天的棋题已完成。"),
    "Puzzle_Streak": m22,
    "Puzzle_Why_This_Works": MessageLookupByLibrary.simpleMessage("为什么这步有效"),
    "Puzzles_Completed_Count": m23,
    "Puzzles_Solved": m24,
    "Quick_Play": MessageLookupByLibrary.simpleMessage("快速对局"),
    "Quick_Play_Description": MessageLookupByLibrary.simpleMessage(
      "使用上次的设置与 AI 对战",
    ),
    "Redo_Move": MessageLookupByLibrary.simpleMessage("重做走法"),
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("移除广告"),
    "Replace_Unfinished_Game": MessageLookupByLibrary.simpleMessage("开始新对局？"),
    "Replace_Unfinished_Game_Description": MessageLookupByLibrary.simpleMessage(
      "未完成的对局将被替换。",
    ),
    "Replay": MessageLookupByLibrary.simpleMessage("回放"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage("未找到之前的高级版购买记录。"),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage("恢复购买"),
    "Resume_Game_Unavailable": MessageLookupByLibrary.simpleMessage(
      "无法恢复此对局。你可以开始新对局。",
    ),
    "Retry": MessageLookupByLibrary.simpleMessage("重试"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("复盘对局"),
    "Review_Move_Title": m25,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage("拯救救护车!"),
    "Settings": MessageLookupByLibrary.simpleMessage("设置"),
    "Share_Result": MessageLookupByLibrary.simpleMessage("分享赛果"),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage("正在生成赛果卡片…"),
    "Shows": MessageLookupByLibrary.simpleMessage("Shows"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage("极简计算器"),
    "Sound": MessageLookupByLibrary.simpleMessage("音效"),
    "Sound_Description": MessageLookupByLibrary.simpleMessage("移动棋子时播放音效。"),
    "Stalemate": MessageLookupByLibrary.simpleMessage("和棋"),
    "Start": MessageLookupByLibrary.simpleMessage("开始"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("数独迷"),
    "Theme_Back_Rank": MessageLookupByLibrary.simpleMessage("底线将杀"),
    "Theme_Bishop_Mate": MessageLookupByLibrary.simpleMessage("象将杀"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("将杀"),
    "Theme_Combination": MessageLookupByLibrary.simpleMessage("组合战术"),
    "Theme_Double_Attack": MessageLookupByLibrary.simpleMessage("双重攻击"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("马的双攻"),
    "Theme_Knight_Mate": MessageLookupByLibrary.simpleMessage("马将杀"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("兵升变"),
    "Theme_Queen_Net": MessageLookupByLibrary.simpleMessage("后将杀"),
    "Theme_Rook_Mate": MessageLookupByLibrary.simpleMessage("车将杀"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("时间限制"),
    "Tip": MessageLookupByLibrary.simpleMessage("推荐走法"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("走法推荐按钮"),
    "Tip_Button_Description": MessageLookupByLibrary.simpleMessage(
      "显示按钮，为你推荐更好的走法。",
    ),
    "Training": MessageLookupByLibrary.simpleMessage("训练"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "选择专项棋题练习，或学习可靠的开局变化。",
    ),
    "Training_Progress": MessageLookupByLibrary.simpleMessage("练习进度"),
    "Training_Progress_Unavailable": MessageLookupByLibrary.simpleMessage(
      "暂时无法读取进度，请重试。",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage("还差一点，再试一次"),
    "Two_Players": MessageLookupByLibrary.simpleMessage("二人对战"),
    "Undo": MessageLookupByLibrary.simpleMessage("撤销/悔棋"),
    "Undo_Description": MessageLookupByLibrary.simpleMessage("允许悔棋和重做走法。"),
    "Undo_Move": MessageLookupByLibrary.simpleMessage("悔棋"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("未完成的对局"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("设置人机对弈"),
    "We_Play_Piano": MessageLookupByLibrary.simpleMessage("弹钢琴"),
    "White": MessageLookupByLibrary.simpleMessage("白棋"),
    "White_Wins": MessageLookupByLibrary.simpleMessage("白棋获胜！"),
    "Whites_Turn": MessageLookupByLibrary.simpleMessage("轮到白棋"),
    "World_Weather_Live": MessageLookupByLibrary.simpleMessage("极简天气"),
    "Yes_Habit": MessageLookupByLibrary.simpleMessage("签签习惯"),
    "You_Lose": MessageLookupByLibrary.simpleMessage("你输了"),
    "You_Win": MessageLookupByLibrary.simpleMessage("你赢了"),
    "Your_Turn": MessageLookupByLibrary.simpleMessage("请下棋子"),
  };
}
