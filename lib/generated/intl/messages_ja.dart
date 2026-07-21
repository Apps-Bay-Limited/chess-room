// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(count) => "${count}分";

  static String m1(count) => "${count}手";

  static String m2(current, total) => "${total}手中${current}手目";

  static String m3(current, total, side) =>
      "${total}手中${current}手目：${side}を指してください";

  static String m4(value) => "${value}ポーン分の評価値を失いました";

  static String m5(current, total) => "${total}問中${current}問目";

  static String m6(count) => "連続正解：${count}";

  static String m7(solved, total) => "${total}問中${solved}問クリア";

  static String m8(price) => "広告を削除 ${price}";

  static String m9(current, total, classification) =>
      "${total}手中${current}手目：${classification}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AI_Difficulty": MessageLookupByLibrary.simpleMessage("AIの強さ"),
    "AI_is_thinking": MessageLookupByLibrary.simpleMessage("AIが考えています"),
    "Back": MessageLookupByLibrary.simpleMessage("戻る"),
    "Best_Move": MessageLookupByLibrary.simpleMessage("最善手"),
    "Biggest_Mistake": MessageLookupByLibrary.simpleMessage("最大のミス"),
    "Black": MessageLookupByLibrary.simpleMessage("黒"),
    "Black_Wins": MessageLookupByLibrary.simpleMessage("黒の勝ち！"),
    "Blacks_Turn": MessageLookupByLibrary.simpleMessage("黒の番"),
    "Blunder": MessageLookupByLibrary.simpleMessage("大悪手"),
    "Blunder_Explanation": MessageLookupByLibrary.simpleMessage(
      "この手は大きく駒損するか、決定的な攻撃を許します。",
    ),
    "Cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "Chess_Bishop_Rule": MessageLookupByLibrary.simpleMessage(
      "ビショップ — 斜めに好きなだけ動けます。",
    ),
    "Chess_Castling_Rule": MessageLookupByLibrary.simpleMessage(
      "キャスリング — キングをルーク側へ2マス動かし、そのルークをキングの隣に置きます。両方が未移動で間に駒がなく、キングがチェック中、攻撃されるマスの通過、チェックされるマスへの着地でないことが条件です。",
    ),
    "Chess_Check_Body": MessageLookupByLibrary.simpleMessage(
      "キングがチェックされたら、キングを動かす、攻撃している駒を取る、攻撃を遮る、のいずれかが必要です。合法的な応手がなければチェックメイトで対局終了です。",
    ),
    "Chess_Check_Title": MessageLookupByLibrary.simpleMessage("チェックとチェックメイト"),
    "Chess_Draws_Body": MessageLookupByLibrary.simpleMessage(
      "ステイルメイト、合意、メイトに必要な戦力不足、同一局面の3回反復、またはポーンの移動や駒取りが双方50手ない場合は引き分けになります。",
    ),
    "Chess_Draws_Title": MessageLookupByLibrary.simpleMessage("引き分け"),
    "Chess_En_Passant_Rule": MessageLookupByLibrary.simpleMessage(
      "アンパッサン — 隣の敵ポーンが直前に2マス進んだ場合、1マスだけ進んだものとして取れます。直後の手でのみ可能です。",
    ),
    "Chess_Goal_Body": MessageLookupByLibrary.simpleMessage(
      "相手のキングをチェックメイトします。チェックメイトとは、キングが攻撃され、合法的に逃げる手がない状態です。",
    ),
    "Chess_Goal_Title": MessageLookupByLibrary.simpleMessage("ゲームの目的"),
    "Chess_King_Rule": MessageLookupByLibrary.simpleMessage(
      "キング — 全方向に1マス動けますが、チェックされるマスには移動できません。",
    ),
    "Chess_Knight_Rule": MessageLookupByLibrary.simpleMessage(
      "ナイト — 一方向に2マス、横に1マスのL字形に動きます。他の駒を飛び越えられます。",
    ),
    "Chess_Pawn_Rule": MessageLookupByLibrary.simpleMessage(
      "ポーン — 前に1マス、初期位置からは2マス進めます。駒を取るときは斜め前に1マス動きます。",
    ),
    "Chess_Pieces_Title": MessageLookupByLibrary.simpleMessage("駒の動かし方"),
    "Chess_Promotion_Rule": MessageLookupByLibrary.simpleMessage(
      "プロモーション — ポーンが最終段に到達すると、クイーン、ルーク、ビショップ、ナイトのいずれかに昇格します。",
    ),
    "Chess_Queen_Rule": MessageLookupByLibrary.simpleMessage(
      "クイーン — 縦、横、斜めに好きなだけ動けます。",
    ),
    "Chess_Rook_Rule": MessageLookupByLibrary.simpleMessage(
      "ルーク — 縦または横に好きなだけ動けます。",
    ),
    "Chess_Room_Result": MessageLookupByLibrary.simpleMessage(
      "Chess Room 対局結果",
    ),
    "Chess_Setup_Body": MessageLookupByLibrary.simpleMessage(
      "各プレイヤーの右手前が明るいマスになるように盤を置きます。奥の列はルーク、ナイト、ビショップ、クイーン、キング、ビショップ、ナイト、ルークの順で、クイーンは自分と同じ色のマスに置きます。手前の列にポーンを並べ、白から指します。",
    ),
    "Chess_Setup_Title": MessageLookupByLibrary.simpleMessage("盤の準備"),
    "Chess_Special_Moves_Title": MessageLookupByLibrary.simpleMessage("特殊な動き"),
    "Chess_Tips_Body": MessageLookupByLibrary.simpleMessage(
      "中央を支配し、ナイトとビショップを早めに展開し、キャスリングでキングを守りましょう。毎手、相手の狙いを確認することも大切です。",
    ),
    "Chess_Tips_Title": MessageLookupByLibrary.simpleMessage("初心者向けのコツ"),
    "Classical_Music_Box": MessageLookupByLibrary.simpleMessage("クラシック音楽ボックス"),
    "Correct": MessageLookupByLibrary.simpleMessage("正解！チェックメイトです。"),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("デイリーパズル"),
    "Done": MessageLookupByLibrary.simpleMessage("完了"),
    "Draw": MessageLookupByLibrary.simpleMessage("引き分け"),
    "Easy": MessageLookupByLibrary.simpleMessage("かんたん"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("Easy Unit"),
    "Export_PGN": MessageLookupByLibrary.simpleMessage("PGNをコピー"),
    "Extreme": MessageLookupByLibrary.simpleMessage("最強"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage("落ちものブロックパズル"),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage("最善手を見つけてください。"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("ナイフ投げ"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage("対局の完全レビュー"),
    "Game_History": MessageLookupByLibrary.simpleMessage("対局履歴"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("対局再生"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("好手"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "この手はエンジンの最善手に近い選択です。",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("むずかしい"),
    "Hints": MessageLookupByLibrary.simpleMessage("ヒント"),
    "How_To_Play_Chess": MessageLookupByLibrary.simpleMessage("チェスの遊び方"),
    "How_To_Play_Intro": MessageLookupByLibrary.simpleMessage(
      "基本ルールを学んだら、トレーニングで戦術とオープニングを練習しましょう。",
    ),
    "Image_Guru": MessageLookupByLibrary.simpleMessage("Image Guru"),
    "Import": MessageLookupByLibrary.simpleMessage("インポート"),
    "Import_PGN": MessageLookupByLibrary.simpleMessage("PGNをインポート"),
    "Inaccuracy": MessageLookupByLibrary.simpleMessage("不正確"),
    "Inaccuracy_Explanation": MessageLookupByLibrary.simpleMessage(
      "この手は局面の優位性を少し失います。",
    ),
    "Instant_Face": MessageLookupByLibrary.simpleMessage("Instant Face"),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("1手詰め"),
    "Medium": MessageLookupByLibrary.simpleMessage("ふつう"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("Metronome Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("Minesweeper Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("Mint Translate"),
    "Minute_Count": m0,
    "Mistake": MessageLookupByLibrary.simpleMessage("ミス"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "より強い手なら、はるかに良い局面を維持できました。",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("家計簿"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("その他のアプリ"),
    "Move_Count": m1,
    "Move_Of": m2,
    "Next": MessageLookupByLibrary.simpleMessage("次へ"),
    "Next_Puzzle": MessageLookupByLibrary.simpleMessage("次のパズル"),
    "No_Limit": MessageLookupByLibrary.simpleMessage("無制限"),
    "No_Saved_Games": MessageLookupByLibrary.simpleMessage(
      "完了またはインポートした対局がここに表示されます。",
    ),
    "Novels_Hub": MessageLookupByLibrary.simpleMessage("小説ライブラリ"),
    "Onlynote": MessageLookupByLibrary.simpleMessage("Onlynote"),
    "Opening_Complete": MessageLookupByLibrary.simpleMessage(
      "ライン完了！すべて正しく指せました。",
    ),
    "Opening_Italian": MessageLookupByLibrary.simpleMessage("イタリアン・ゲーム"),
    "Opening_Italian_Description": MessageLookupByLibrary.simpleMessage(
      "素早く駒を展開し、弱点のf7に圧力をかけます。",
    ),
    "Opening_London": MessageLookupByLibrary.simpleMessage("ロンドン・システム"),
    "Opening_London_Description": MessageLookupByLibrary.simpleMessage(
      "黒マスのビショップをポーンチェーンの外に出し、堅実な形を築きます。",
    ),
    "Opening_Move_Prompt": m3,
    "Opening_Queens_Gambit": MessageLookupByLibrary.simpleMessage(
      "クイーンズ・ギャンビット",
    ),
    "Opening_Queens_Gambit_Description": MessageLookupByLibrary.simpleMessage(
      "サイドのポーンを差し出し、中央を長く支配します。",
    ),
    "Opening_Ruy_Lopez": MessageLookupByLibrary.simpleMessage("ルイ・ロペス"),
    "Opening_Ruy_Lopez_Description": MessageLookupByLibrary.simpleMessage(
      "早い段階でビショップによるピンを仕掛け、黒の中央の守備駒を攻めます。",
    ),
    "Opening_Sicilian": MessageLookupByLibrary.simpleMessage("シシリアン・ディフェンス"),
    "Opening_Sicilian_Description": MessageLookupByLibrary.simpleMessage(
      "白のキングポーン・オープニングに対して非対称な戦いを作ります。",
    ),
    "Opening_Trainer": MessageLookupByLibrary.simpleMessage("オープニングトレーナー"),
    "Opening_Trainer_Description": MessageLookupByLibrary.simpleMessage(
      "信頼できる5つのオープニングの考え方と序盤の手を学びます。",
    ),
    "Opening_Try_Again": MessageLookupByLibrary.simpleMessage(
      "この手はトレーニングラインにありません。もう一度お試しください。",
    ),
    "PGN_Copied": MessageLookupByLibrary.simpleMessage("PGNをクリップボードにコピーしました。"),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage("PGNをインポートしました。"),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage("このPGNはインポートできませんでした。"),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("PGNの対局を貼り付け"),
    "Pawns_Lost": m4,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("陣営を選択"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("実戦の手"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("もう一度練習"),
    "Previous": MessageLookupByLibrary.simpleMessage("前へ"),
    "Purchase_Cancelled": MessageLookupByLibrary.simpleMessage("購入をキャンセルしました。"),
    "Purchase_Failed": MessageLookupByLibrary.simpleMessage(
      "購入に失敗しました。もう一度お試しください。",
    ),
    "Purchase_In_Progress": MessageLookupByLibrary.simpleMessage("購入処理中…"),
    "Purchase_Pending": MessageLookupByLibrary.simpleMessage("購入は承認待ちです。"),
    "Purchase_Restored": MessageLookupByLibrary.simpleMessage(
      "購入を復元しました。広告は削除されました。",
    ),
    "Purchase_Success": MessageLookupByLibrary.simpleMessage(
      "購入が完了しました。広告は削除されました。",
    ),
    "Puzzle_Complete": MessageLookupByLibrary.simpleMessage("パズルクリア！"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "白または黒の手番です。1手でチェックメイトしてください。",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("パズルライブラリ"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "テーマ別の問題を自分のペースで練習できます。進捗はこの端末に保存されます。",
    ),
    "Puzzle_Number": m5,
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage("本日のパズルは完了しています。"),
    "Puzzle_Streak": m6,
    "Puzzles_Solved": m7,
    "Remove_Ads": MessageLookupByLibrary.simpleMessage("広告を削除"),
    "Remove_Ads_Description": MessageLookupByLibrary.simpleMessage(
      "このアプリから広告を完全に削除します。",
    ),
    "Remove_Ads_Loading": MessageLookupByLibrary.simpleMessage(
      "購入オプションを読み込み中…",
    ),
    "Remove_Ads_Purchased": MessageLookupByLibrary.simpleMessage(
      "この端末では広告が削除されています。",
    ),
    "Remove_Ads_Unavailable": MessageLookupByLibrary.simpleMessage(
      "現在、広告の削除は利用できません。",
    ),
    "Remove_Ads_With_Price": m8,
    "Replay": MessageLookupByLibrary.simpleMessage("再生"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "以前の広告削除の購入が見つかりませんでした。",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage("購入を復元"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("最大のミスを振り返る"),
    "Review_Move_Title": m9,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage("救急車を救え"),
    "Settings": MessageLookupByLibrary.simpleMessage("設定"),
    "Share_Result": MessageLookupByLibrary.simpleMessage("結果を共有"),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage("結果カードを作成中…"),
    "Shows": MessageLookupByLibrary.simpleMessage("番組"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage("シンプル電卓"),
    "Stalemate": MessageLookupByLibrary.simpleMessage("ステイルメイト"),
    "Start": MessageLookupByLibrary.simpleMessage("開始"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("Sudoku Lover"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("チェックメイト"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("ナイトのフォーク"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("ポーンの昇格"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("制限時間"),
    "Tip": MessageLookupByLibrary.simpleMessage("アドバイス"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("アドバイスボタンを表示"),
    "Training": MessageLookupByLibrary.simpleMessage("トレーニング"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "テーマ別パズルに取り組むか、信頼できるオープニングラインを学びましょう。",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage("もう一度お試しください"),
    "Two_Players": MessageLookupByLibrary.simpleMessage("2人で対戦"),
    "Undo": MessageLookupByLibrary.simpleMessage("待った/やり直し"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("未完了の対局"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("AIと対戦"),
    "We_Play_Piano": MessageLookupByLibrary.simpleMessage("We Play Piano"),
    "White": MessageLookupByLibrary.simpleMessage("白"),
    "White_Wins": MessageLookupByLibrary.simpleMessage("白の勝ち！"),
    "Whites_Turn": MessageLookupByLibrary.simpleMessage("白の番"),
    "World_Weather_Live": MessageLookupByLibrary.simpleMessage("世界の天気ライブ"),
    "Yes_Habit": MessageLookupByLibrary.simpleMessage("Yes Habit"),
    "You_Lose": MessageLookupByLibrary.simpleMessage("あなたの負けです"),
    "You_Win": MessageLookupByLibrary.simpleMessage("あなたの勝ちです"),
    "Your_Turn": MessageLookupByLibrary.simpleMessage("あなたの番です"),
  };
}
