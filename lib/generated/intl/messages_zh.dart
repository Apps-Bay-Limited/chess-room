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

  static String m0(count) => "${count} 分钟";

  static String m1(count) => "${count} 回合";

  static String m2(current, total) => "第 ${current} 步，共 ${total} 步";

  static String m3(current, total, side) =>
      "第 ${current}/${total} 步：为${side}走棋";

  static String m4(value) => "损失 ${value} 个兵的局面分";

  static String m5(current, total) => "第 ${current}/${total} 题";

  static String m6(count) => "连续：${count} 天";

  static String m7(solved, total) => "已完成 ${solved}/${total}";

  static String m8(price) => "移除广告 ${price}";

  static String m9(current, total, classification) =>
      "第 ${current}/${total} 步：${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage("AI难度"),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage("AI正在思考"),
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
    "Correct": MessageLookupByLibrary.simpleMessage("正确！将杀。"),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("每日棋题"),
    "Done": MessageLookupByLibrary.simpleMessage("完成"),
    "Draw": MessageLookupByLibrary.simpleMessage("和棋"),
    "Easy": MessageLookupByLibrary.simpleMessage("简单"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("易换算"),
    "Export_PGN": MessageLookupByLibrary.simpleMessage("复制 PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("非常困难"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage("经典俄罗斯掌机方块"),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage("找出最佳走法。"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("西瓜飞刀"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage("完整复盘"),
    "Game_History": MessageLookupByLibrary.simpleMessage("对局记录"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("对局回放"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("好棋"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "这步棋与引擎推荐的最佳选择十分接近。",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("困难"),
    "Hints": MessageLookupByLibrary.simpleMessage("提示"),
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
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("一步将杀"),
    "Medium": MessageLookupByLibrary.simpleMessage("中等"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("打拍节拍器"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("经典扫雷"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("薄荷翻译"),
    "Minute_Count": m0,
    "Mistake": MessageLookupByLibrary.simpleMessage("失误"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "更强的走法可以保留明显更好的局面。",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("极简记账"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("更多App"),
    "Move_Count": m1,
    "Move_Of": m2,
    "Next": MessageLookupByLibrary.simpleMessage("下一步"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("下一题"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("不限时"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage("完成或导入的对局会显示在这里。"),
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
    "Opening_Move_Prompt": m3,
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
    "PGN_Copied": MessageLookupByLibrary.simpleMessage("PGN 已复制到剪贴板。"),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage("PGN 导入成功。"),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage("无法导入此 PGN。"),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("粘贴 PGN 对局"),
    "Pawns_Lost": m4,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("选择棋子"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("实战走法"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("再次练习"),
    "Previous": MessageLookupByLibrary.simpleMessage("上一步"),
    "Purchase_Cancelled": MessageLookupByLibrary.simpleMessage("购买已取消。"),
    "Purchase_Failed": MessageLookupByLibrary.simpleMessage("购买失败，请重试。"),
    "Purchase_In_Progress": MessageLookupByLibrary.simpleMessage("正在购买..."),
    "Purchase_Pending": MessageLookupByLibrary.simpleMessage("购买正在等待批准。"),
    "Purchase_Restored": MessageLookupByLibrary.simpleMessage("购买已恢复，广告已移除。"),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage("购买完成，广告已移除。"),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage("棋题完成！"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "轮到白方或黑方。找出一步将杀。",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("棋题库"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "按主题自由练习，进度会保存在此设备上。",
    ),
    "Puzzle_Number": m5,
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage("今天的棋题已完成。"),
    "Puzzle_Streak": m6,
    "Puzzles_Solved": m7,
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("移除广告"),
    "Remove_Ads_Description": MessageLookupByLibrary.simpleMessage(
      "永久移除此 App 中的广告。",
    ),
    "Remove_Ads_Loading": MessageLookupByLibrary.simpleMessage("正在加载购买选项..."),
    "Remove_Ads_Purchased": MessageLookupByLibrary.simpleMessage("此设备已移除广告。"),
    "Remove_Ads_Unavailable": MessageLookupByLibrary.simpleMessage(
      "移除广告暂时不可用。",
    ),
    "Remove_Ads_With_Price": m8,
    "Replay": MessageLookupByLibrary.simpleMessage("回放"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "未找到之前的移除广告购买记录。",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage("恢复购买"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("复盘最大失误"),
    "Review_Move_Title": m9,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage("拯救救护车!"),
    "Settings": MessageLookupByLibrary.simpleMessage("设置"),
    "Share_Result": MessageLookupByLibrary.simpleMessage("分享赛果"),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage("正在生成赛果卡片…"),
    "Shows": MessageLookupByLibrary.simpleMessage("Shows"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage("极简计算器"),
    "Stalemate": MessageLookupByLibrary.simpleMessage("和棋"),
    "Start": MessageLookupByLibrary.simpleMessage("开始"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("数独迷"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("将杀"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("马的双攻"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("兵升变"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("时间限制"),
    "Tip": MessageLookupByLibrary.simpleMessage("最佳走法提示"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("显示提示按钮"),
    "Training": MessageLookupByLibrary.simpleMessage("训练"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "选择专项棋题练习，或学习可靠的开局变化。",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage("还差一点，再试一次"),
    "Two_Players": MessageLookupByLibrary.simpleMessage("二人对战"),
    "Undo": MessageLookupByLibrary.simpleMessage("撤销/悔棋"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("未完成的对局"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("AI棋手"),
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
