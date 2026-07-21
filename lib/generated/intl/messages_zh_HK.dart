// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_HK locale. All the
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
  String get localeName => 'zh_HK';

  static String m0(count) => "${count} 分鐘";

  static String m1(count) => "${count} 回合";

  static String m2(current, total) => "第 ${current} 步，共 ${total} 步";

  static String m3(current, total, side) =>
      "第 ${current}/${total} 步：為${side}走棋";

  static String m4(value) => "損失 ${value} 個兵的局面分";

  static String m5(current, total) => "第 ${current}/${total} 題";

  static String m6(count) => "連續：${count} 天";

  static String m7(solved, total) => "已完成 ${solved}/${total}";

  static String m8(price) => "移除廣告 ${price}";

  static String m9(current, total, classification) =>
      "第 ${current}/${total} 步：${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage("AI難度"),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage("AI正在思考"),
    "Back": MessageLookupByLibrary.simpleMessage("返回"),
    "Best_Move": MessageLookupByLibrary.simpleMessage("最佳走法"),
    "Biggest_Mistake": MessageLookupByLibrary.simpleMessage("最大失誤"),
    "Black": MessageLookupByLibrary.simpleMessage("黑棋"),
    "Black_Wins": MessageLookupByLibrary.simpleMessage("黑棋獲勝！"),
    "Blacks_Turn": MessageLookupByLibrary.simpleMessage("輪到黑棋"),
    "Blunder": MessageLookupByLibrary.simpleMessage("嚴重失誤"),
    "Blunder_Explanation": MessageLookupByLibrary.simpleMessage(
      "這步棋會損失大量子力，或讓對手發動決定性進攻。",
    ),
    "Cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "Chess_Bishop_Rule": MessageLookupByLibrary.simpleMessage("象 — 可沿斜線走任意格。"),
    "Chess_Castling_Rule": MessageLookupByLibrary.simpleMessage(
      "王車易位 — 王向車的方向走兩格，再把該車放到王的旁邊。王和車都必須從未移動，中間沒有棋子，並且王不能處於被將軍、經過受攻擊格或落入受攻擊格。",
    ),
    "Chess_Check_Body": MessageLookupByLibrary.simpleMessage(
      "王被將軍時，必須移動王、吃掉進攻棋子或阻擋攻擊。如果沒有合法應對，就是將死，對局結束。",
    ),
    "Chess_Check_Title": MessageLookupByLibrary.simpleMessage("將軍與將死"),
    "Chess_Draws_Body": MessageLookupByLibrary.simpleMessage(
      "逼和、雙方同意、子力不足、三次重複局面，或雙方各連續五十步沒有走兵和吃子時，對局為和棋。",
    ),
    "Chess_Draws_Title": MessageLookupByLibrary.simpleMessage("和棋"),
    "Chess_En_Passant_Rule": MessageLookupByLibrary.simpleMessage(
      "吃過路兵 — 相鄰的對方兵剛從初始位置走兩格時，可以把它當作只走了一格來吃掉，但只能立即執行。",
    ),
    "Chess_Goal_Body": MessageLookupByLibrary.simpleMessage(
      "將死對方的王。將死是指王正受到攻擊，並且沒有任何合法走法可以脫險。",
    ),
    "Chess_Goal_Title": MessageLookupByLibrary.simpleMessage("遊戲目標"),
    "Chess_King_Rule": MessageLookupByLibrary.simpleMessage(
      "王 — 可向任意方向走一格，但不能走入被攻擊的格子。",
    ),
    "Chess_Knight_Rule": MessageLookupByLibrary.simpleMessage(
      "馬 — 走「日」字，即一個方向兩格再向側面一格，並且可以越過其他棋子。",
    ),
    "Chess_Pawn_Rule": MessageLookupByLibrary.simpleMessage(
      "兵 — 向前走一格，首次可走兩格；吃子時向斜前方走一格。",
    ),
    "Chess_Pieces_Title": MessageLookupByLibrary.simpleMessage("棋子的走法"),
    "Chess_Promotion_Rule": MessageLookupByLibrary.simpleMessage(
      "兵升變 — 兵到達最後一排時，可升變為后、車、象或馬。",
    ),
    "Chess_Queen_Rule": MessageLookupByLibrary.simpleMessage(
      "后 — 可沿橫線、直線或斜線走任意格。",
    ),
    "Chess_Rook_Rule": MessageLookupByLibrary.simpleMessage("車 — 可沿橫線或直線走任意格。"),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "Chess Room 對局結果",
    ),
    "Chess_Setup_Body": MessageLookupByLibrary.simpleMessage(
      "擺放棋盤時，每位玩家的右下角都應為淺色格。底線依次為車、馬、象、后、王、象、馬、車；后放在與自身顏色相同的格子。兵排在前一行，由白方先走。",
    ),
    "Chess_Setup_Title": MessageLookupByLibrary.simpleMessage("棋盤擺放"),
    "Chess_Special_Moves_Title": MessageLookupByLibrary.simpleMessage("特殊走法"),
    "Chess_Tips_Body": MessageLookupByLibrary.simpleMessage(
      "控制中心，儘早出馬和象，透過王車易位保護王，並在每步棋前檢查對手的威脅。",
    ),
    "Chess_Tips_Title": MessageLookupByLibrary.simpleMessage("新手技巧"),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage("古典音樂盒"),
    "Correct": MessageLookupByLibrary.simpleMessage("正確！將殺。"),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("每日棋題"),
    "Done": MessageLookupByLibrary.simpleMessage("完成"),
    "Draw": MessageLookupByLibrary.simpleMessage("和棋"),
    "Easy": MessageLookupByLibrary.simpleMessage("簡單"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("易換算"),
    "Export_PGN": MessageLookupByLibrary.simpleMessage("複製 PGN"),
    "Extreme": MessageLookupByLibrary.simpleMessage("非常困難"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage("經典俄羅斯掌機方塊"),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage("找出最佳走法。"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("西瓜飛刀"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage("完整覆盤"),
    "Game_History": MessageLookupByLibrary.simpleMessage("對局記錄"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("對局重播"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("好棋"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "這步棋與引擎建議的最佳選擇十分接近。",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("困難"),
    "Hints": MessageLookupByLibrary.simpleMessage("提示"),
    "How_To_Play_Chess": MessageLookupByLibrary.simpleMessage("國際象棋玩法"),
    "How_To_Play_Intro": MessageLookupByLibrary.simpleMessage(
      "先學習基本規則，再透過訓練練習戰術與開局。",
    ),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("咕嚕濾鏡"),
    "Import": MessageLookupByLibrary.simpleMessage("匯入"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("匯入 PGN"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("不準確"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "這步棋讓出了局面中的一小部分優勢。",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("Instant_Face"),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("一步將殺"),
    "Medium": MessageLookupByLibrary.simpleMessage("中等"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("打拍節拍器"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("經典掃雷"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("薄荷翻譯"),
    "Minute_Count": m0,
    "Mistake": MessageLookupByLibrary.simpleMessage("失誤"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "更強的走法可以保留明顯更好的局面。",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("極簡記賬"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("更多App"),
    "Move_Count": m1,
    "Move_Of": m2,
    "Next": MessageLookupByLibrary.simpleMessage("下一步"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("下一題"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("不限時"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage("完成或匯入的對局會顯示在這裏。"),
    "Novels_Hub": MessageLookupByLibrary.simpleMessage("英文小說站"),
    "Onlynote": MessageLookupByLibrary.simpleMessage("極簡備忘錄"),
    "Opening_Complete": MessageLookupByLibrary.simpleMessage("變化完成！每一步都正確。"),
    "Opening_Italian": MessageLookupByLibrary.simpleMessage("意大利開局"),
    "Opening_Italian_Description": MessageLookupByLibrary.simpleMessage(
      "快速出子並向薄弱的 f7 格施壓。",
    ),
    "Opening_London": MessageLookupByLibrary.simpleMessage("倫敦體系"),
    "Opening_London_Description": MessageLookupByLibrary.simpleMessage(
      "把黑格象放到兵鏈外，建立穩健的陣型。",
    ),
    "Opening_Move_Prompt": m3,
    "Opening_Queens_Gambit": MessageLookupByLibrary.simpleMessage("后翼棄兵"),
    "Opening_Queens_Gambit_Description": MessageLookupByLibrary.simpleMessage(
      "犧牲翼兵以建立持久的中心控制。",
    ),
    "Opening_Ruy_Lopez": MessageLookupByLibrary.simpleMessage("西班牙開局"),
    "Opening_Ruy_Lopez_Description": MessageLookupByLibrary.simpleMessage(
      "用象早早牽制黑方的中心防守子。",
    ),
    "Opening_Sicilian": MessageLookupByLibrary.simpleMessage("西西里防禦"),
    "Opening_Sicilian_Description": MessageLookupByLibrary.simpleMessage(
      "對白方王兵開局製造不對稱的複雜戰鬥。",
    ),
    "Opening_Trainer": MessageLookupByLibrary.simpleMessage("開局訓練"),
    "Opening_Trainer_Description": MessageLookupByLibrary.simpleMessage(
      "學習五種可靠開局的思路與前幾步走法。",
    ),
    "Opening_Try_Again": MessageLookupByLibrary.simpleMessage("這步不在訓練變化中，請重試。"),
    "PGN_Copied": MessageLookupByLibrary.simpleMessage("PGN 已複製到剪貼簿。"),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage("PGN 匯入成功。"),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage("無法匯入此 PGN。"),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("貼上 PGN 對局"),
    "Pawns_Lost": m4,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("選擇棋子"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("實戰走法"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("再次練習"),
    "Previous": MessageLookupByLibrary.simpleMessage("上一步"),
    "Purchase_Cancelled": MessageLookupByLibrary.simpleMessage("購買已取消。"),
    "Purchase_Failed": MessageLookupByLibrary.simpleMessage("購買失敗，請重試。"),
    "Purchase_In_Progress": MessageLookupByLibrary.simpleMessage("正在購買..."),
    "Purchase_Pending": MessageLookupByLibrary.simpleMessage("購買正在等待批准。"),
    "Purchase_Restored": MessageLookupByLibrary.simpleMessage("購買已恢復，廣告已移除。"),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage("購買完成，廣告已移除。"),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage("棋題完成！"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "輪到白方或黑方。找出一步將殺。",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("棋題庫"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "按主題自由練習，進度會儲存在此裝置上。",
    ),
    "Puzzle_Number": m5,
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage("今日棋題已完成。"),
    "Puzzle_Streak": m6,
    "Puzzles_Solved": m7,
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("移除廣告"),
    "Remove_Ads_Description": MessageLookupByLibrary.simpleMessage(
      "永久移除此 App 中的廣告。",
    ),
    "Remove_Ads_Loading": MessageLookupByLibrary.simpleMessage("正在載入購買選項..."),
    "Remove_Ads_Purchased": MessageLookupByLibrary.simpleMessage("此裝置已移除廣告。"),
    "Remove_Ads_Unavailable": MessageLookupByLibrary.simpleMessage(
      "移除廣告暫時無法使用。",
    ),
    "Remove_Ads_With_Price": m8,
    "Replay": MessageLookupByLibrary.simpleMessage("重播"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "未找到之前的移除廣告購買記錄。",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage("恢復購買"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("復盤最大失誤"),
    "Review_Move_Title": m9,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage("拯救救護車!"),
    "Settings": MessageLookupByLibrary.simpleMessage("設置"),
    "Share_Result": MessageLookupByLibrary.simpleMessage("分享賽果"),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage("正在製作賽果卡片…"),
    "Shows": MessageLookupByLibrary.simpleMessage("Shows"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage("極簡計算器"),
    "Stalemate": MessageLookupByLibrary.simpleMessage("和棋"),
    "Start": MessageLookupByLibrary.simpleMessage("開始"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("數獨迷"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("將殺"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("馬的雙攻"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("兵升變"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("時間限制"),
    "Tip": MessageLookupByLibrary.simpleMessage("最佳走法提示"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("顯示提示按鈕"),
    "Training": MessageLookupByLibrary.simpleMessage("訓練"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "選擇專項棋題練習，或學習可靠的開局變化。",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage("差一點，再試一次"),
    "Two_Players": MessageLookupByLibrary.simpleMessage("二人對戰"),
    "Undo": MessageLookupByLibrary.simpleMessage("撤銷/悔棋"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("未完成的對局"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("AI棋手"),
    "We_Play_Piano": MessageLookupByLibrary.simpleMessage("彈鋼琴"),
    "White": MessageLookupByLibrary.simpleMessage("白棋"),
    "White_Wins": MessageLookupByLibrary.simpleMessage("白棋獲勝！"),
    "Whites_Turn": MessageLookupByLibrary.simpleMessage("輪到白棋"),
    "World_Weather_Live": MessageLookupByLibrary.simpleMessage("極簡天氣"),
    "Yes_Habit": MessageLookupByLibrary.simpleMessage("簽簽習慣"),
    "You_Lose": MessageLookupByLibrary.simpleMessage("你輸了"),
    "You_Win": MessageLookupByLibrary.simpleMessage("你贏了"),
    "Your_Turn": MessageLookupByLibrary.simpleMessage("請下棋子"),
  };
}
