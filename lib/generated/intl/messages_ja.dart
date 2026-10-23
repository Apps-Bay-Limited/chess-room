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

  static String m0(square) => "空きマス ${square}";

  static String m1(count) => "${count}分";

  static String m2(count) => "${count}手";

  static String m3(current, total) => "${total}手中${current}手目";

  static String m4(current, total, side) =>
      "${total}手中${current}手目：${side}を指してください";

  static String m5(completed, total) => "オープニング ${total} 件中 ${completed} 件完了";

  static String m6(value) => "${value}ポーン分の評価値を失いました";

  static String m7(piece, square) => "${square}の${piece}";

  static String m8(current, total) => "${total}問中${current}問目";

  static String m9(piece, support, square) =>
      "逃げ道を封鎖：${support}の${piece}が${square}を押さえています。";

  static String m10(from, king, target) =>
      "${from}のナイトが${king}のキングにチェックし、同時に${target}も攻撃します。";

  static String m11(line) => "解答例：${line}。";

  static String m12(square) =>
      "${square}のキングはチェックメイトです。逃げる、取る、間に駒を置く、いずれの合法手もありません。";

  static String m13(piece, from, to) => "${piece}：${from} → ${to}。";

  static String m14(squares) => "守る側の${squares}のポーンが、自分のキングの逃げ道をふさいでいます。";

  static String m15(square, piece) => "ポーンが${square}に到達し、${piece}に昇格します。";

  static String m16(reply, finish) => "${reply}に対し、${finish}でチェックメイトです。";

  static String m17(piece, support, square) =>
      "支え：${support}の${piece}が${square}を守っています。";

  static String m18(count) => "連続正解：${count}";

  static String m19(completed, total) => "パズル ${total} 問中 ${completed} 問完了";

  static String m20(solved, total) => "${total}問中${solved}問クリア";

  static String m21(price) => "広告を削除 ${price}";

  static String m22(current, total, classification) =>
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
    "Board_Coordinates": MessageLookupByLibrary.simpleMessage("盤の座標"),
    "Board_Coordinates_Description": MessageLookupByLibrary.simpleMessage(
      "盤の周りに列と段の座標を表示します。",
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
    "Chess_Room": MessageLookupByLibrary.simpleMessage("Chess Room"),
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
    "Clock_Active": MessageLookupByLibrary.simpleMessage("手番"),
    "Clock_Black": MessageLookupByLibrary.simpleMessage("黒"),
    "Clock_White": MessageLookupByLibrary.simpleMessage("白"),
    "Continue_Game": MessageLookupByLibrary.simpleMessage("対局を再開"),
    "Continue_Game_Description": MessageLookupByLibrary.simpleMessage(
      "中断したところから続ける",
    ),
    "Correct": MessageLookupByLibrary.simpleMessage("正解！チェックメイトです。"),
    "Daily_Practice_Complete": MessageLookupByLibrary.simpleMessage(
      "今日の課題は完了 · 練習を続けよう",
    ),
    "Daily_Practice_Ready": MessageLookupByLibrary.simpleMessage("今日の新しいチャレンジ"),
    "Daily_Puzzle": MessageLookupByLibrary.simpleMessage("デイリーパズル"),
    "Delete": MessageLookupByLibrary.simpleMessage("削除"),
    "Delete_Game_Failed": MessageLookupByLibrary.simpleMessage(
      "この対局を削除できませんでした。もう一度お試しください。",
    ),
    "Delete_Game_Message": MessageLookupByLibrary.simpleMessage(
      "保存した対局をこの端末から削除します。この操作は取り消せません。",
    ),
    "Delete_Game_Title": MessageLookupByLibrary.simpleMessage("この対局を削除しますか？"),
    "Done": MessageLookupByLibrary.simpleMessage("完了"),
    "Draw": MessageLookupByLibrary.simpleMessage("引き分け"),
    "Easy": MessageLookupByLibrary.simpleMessage("かんたん"),
    "Easy_Unit": MessageLookupByLibrary.simpleMessage("Easy Unit"),
    "Empty_Square": m0,
    "Export_PGN": MessageLookupByLibrary.simpleMessage("PGNをコピー"),
    "Extreme": MessageLookupByLibrary.simpleMessage("最強"),
    "Falling_Block_Puzzle": MessageLookupByLibrary.simpleMessage("落ちものブロックパズル"),
    "Find_Best_Move": MessageLookupByLibrary.simpleMessage("最善手を見つけてください。"),
    "First_Move": MessageLookupByLibrary.simpleMessage("最初の手"),
    "Fling_Knife": MessageLookupByLibrary.simpleMessage("ナイフ投げ"),
    "Flip_Board": MessageLookupByLibrary.simpleMessage("盤を反転"),
    "Full_Game_Review": MessageLookupByLibrary.simpleMessage("対局の完全レビュー"),
    "Game_History": MessageLookupByLibrary.simpleMessage("対局履歴"),
    "Game_Replay": MessageLookupByLibrary.simpleMessage("対局再生"),
    "Game_Setup_Description": MessageLookupByLibrary.simpleMessage(
      "自分に合った強さを選び、最初の一手を指しましょう。",
    ),
    "Gameplay_Settings": MessageLookupByLibrary.simpleMessage("対局設定"),
    "Good_Move": MessageLookupByLibrary.simpleMessage("好手"),
    "Good_Move_Explanation": MessageLookupByLibrary.simpleMessage(
      "この手はエンジンの最善手に近い選択です。",
    ),
    "Hard": MessageLookupByLibrary.simpleMessage("むずかしい"),
    "Help_And_Privacy": MessageLookupByLibrary.simpleMessage("ヘルプとプライバシー"),
    "Hints": MessageLookupByLibrary.simpleMessage("合法手"),
    "Hints_Description": MessageLookupByLibrary.simpleMessage(
      "駒を選ぶと移動できるマスを表示します。",
    ),
    "Home_AI_Description": MessageLookupByLibrary.simpleMessage(
      "強さ・手番・持ち時間を選択",
    ),
    "Home_Local_Description": MessageLookupByLibrary.simpleMessage(
      "1台の端末で2人対局",
    ),
    "Home_Play_Options": MessageLookupByLibrary.simpleMessage("その他の対局方法"),
    "Home_Subtitle": MessageLookupByLibrary.simpleMessage("一局ごとに、次の一手を磨こう。"),
    "Home_Training_Description": MessageLookupByLibrary.simpleMessage(
      "パズルとオープニング練習",
    ),
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
    "Last_Move": MessageLookupByLibrary.simpleMessage("最後の手"),
    "Local_Data_Unavailable": MessageLookupByLibrary.simpleMessage(
      "保存済みデータを一時的に読み込めません。もう一度お試しください。",
    ),
    "Mate_In_One": MessageLookupByLibrary.simpleMessage("1手詰め"),
    "Mate_In_Two": MessageLookupByLibrary.simpleMessage("2手でメイト"),
    "Medium": MessageLookupByLibrary.simpleMessage("ふつう"),
    "Metronome_Go": MessageLookupByLibrary.simpleMessage("Metronome Go"),
    "Minesweeper_Go": MessageLookupByLibrary.simpleMessage("Minesweeper Go"),
    "Mint_Translate": MessageLookupByLibrary.simpleMessage("Mint Translate"),
    "Minute_Count": m1,
    "Mistake": MessageLookupByLibrary.simpleMessage("ミス"),
    "Mistake_Explanation": MessageLookupByLibrary.simpleMessage(
      "より強い手なら、はるかに良い局面を維持できました。",
    ),
    "Money_Tracker": MessageLookupByLibrary.simpleMessage("家計簿"),
    "More_Apps": MessageLookupByLibrary.simpleMessage("その他のアプリ"),
    "Move_Count": m2,
    "Move_Of": m3,
    "Next": MessageLookupByLibrary.simpleMessage("次へ"),
    "Next_Move": MessageLookupByLibrary.simpleMessage("次の手"),
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
    "Opening_Move_Prompt": m4,
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
    "Openings_Completed_Count": m5,
    "PGN_Copied": MessageLookupByLibrary.simpleMessage("PGNをクリップボードにコピーしました。"),
    "PGN_Imported": MessageLookupByLibrary.simpleMessage("PGNをインポートしました。"),
    "PGN_Invalid": MessageLookupByLibrary.simpleMessage("このPGNはインポートできませんでした。"),
    "Paste_PGN": MessageLookupByLibrary.simpleMessage("PGNの対局を貼り付け"),
    "Pawns_Lost": m6,
    "Pick_Your_Side": MessageLookupByLibrary.simpleMessage("陣営を選択"),
    "Piece_Black_Bishop": MessageLookupByLibrary.simpleMessage("黒のビショップ"),
    "Piece_Black_King": MessageLookupByLibrary.simpleMessage("黒のキング"),
    "Piece_Black_Knight": MessageLookupByLibrary.simpleMessage("黒のナイト"),
    "Piece_Black_Pawn": MessageLookupByLibrary.simpleMessage("黒のポーン"),
    "Piece_Black_Queen": MessageLookupByLibrary.simpleMessage("黒のクイーン"),
    "Piece_Black_Rook": MessageLookupByLibrary.simpleMessage("黒のルーク"),
    "Piece_On_Square": m7,
    "Piece_White_Bishop": MessageLookupByLibrary.simpleMessage("白のビショップ"),
    "Piece_White_King": MessageLookupByLibrary.simpleMessage("白のキング"),
    "Piece_White_Knight": MessageLookupByLibrary.simpleMessage("白のナイト"),
    "Piece_White_Pawn": MessageLookupByLibrary.simpleMessage("白のポーン"),
    "Piece_White_Queen": MessageLookupByLibrary.simpleMessage("白のクイーン"),
    "Piece_White_Rook": MessageLookupByLibrary.simpleMessage("白のルーク"),
    "Played_Move": MessageLookupByLibrary.simpleMessage("実戦の手"),
    "Practice_Again": MessageLookupByLibrary.simpleMessage("もう一度練習"),
    "Previous": MessageLookupByLibrary.simpleMessage("前へ"),
    "Previous_Move": MessageLookupByLibrary.simpleMessage("前の手"),
    "Privacy_Choices": MessageLookupByLibrary.simpleMessage("プライバシー設定"),
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
    "Puzzle_Easy": MessageLookupByLibrary.simpleMessage("かんたん"),
    "Puzzle_Explain_Back_Rank": MessageLookupByLibrary.simpleMessage(
      "ポーンがキングの逃げ道をふさいでいます。最終ランクでチェックして対局を決めましょう。",
    ),
    "Puzzle_Explain_Bishop_Mate": MessageLookupByLibrary.simpleMessage(
      "ビショップと他の駒を連携させ、キングの逃げ道をふさぎましょう。",
    ),
    "Puzzle_Explain_Combination": MessageLookupByLibrary.simpleMessage(
      "チェックを連続させて相手の応手を絞り、チェックメイトにつなげましょう。",
    ),
    "Puzzle_Explain_Fork": MessageLookupByLibrary.simpleMessage(
      "キングにチェックをかけながら、別の価値の高い駒も同時に攻撃しましょう。",
    ),
    "Puzzle_Explain_Knight_Mate": MessageLookupByLibrary.simpleMessage(
      "ナイトでキングにチェックをかけ、他の駒で逃げ道をふさぎます。",
    ),
    "Puzzle_Explain_Promotion": MessageLookupByLibrary.simpleMessage(
      "ポーンを安全に昇格させてクイーンを手に入れましょう。",
    ),
    "Puzzle_Explain_Queen_Net": MessageLookupByLibrary.simpleMessage(
      "クイーンと支えの駒を連携させ、すべての逃げ道をふさぎましょう。",
    ),
    "Puzzle_Explain_Rook_Mate": MessageLookupByLibrary.simpleMessage(
      "キングの逃げ道をふさいでから、盤の端に沿ってチェックしましょう。",
    ),
    "Puzzle_Hard": MessageLookupByLibrary.simpleMessage("むずかしい"),
    "Puzzle_Hint": MessageLookupByLibrary.simpleMessage("ヒントを表示"),
    "Puzzle_Instruction": MessageLookupByLibrary.simpleMessage(
      "白または黒の手番です。1手でチェックメイトしてください。",
    ),
    "Puzzle_Library": MessageLookupByLibrary.simpleMessage("パズルライブラリ"),
    "Puzzle_Library_Description": MessageLookupByLibrary.simpleMessage(
      "テーマ別の問題を自分のペースで練習できます。進捗はこの端末に保存されます。",
    ),
    "Puzzle_Line_Progress": MessageLookupByLibrary.simpleMessage(
      "コンビネーションを続けよう",
    ),
    "Puzzle_Medium": MessageLookupByLibrary.simpleMessage("ふつう"),
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
    "Puzzle_Practice_Next": MessageLookupByLibrary.simpleMessage("練習を続ける"),
    "Puzzle_Solved": MessageLookupByLibrary.simpleMessage("本日のパズルは完了しています。"),
    "Puzzle_Streak": m18,
    "Puzzle_Why_This_Works": MessageLookupByLibrary.simpleMessage("この手が有効な理由"),
    "Puzzles_Completed_Count": m19,
    "Puzzles_Solved": m20,
    "Quick_Play": MessageLookupByLibrary.simpleMessage("クイック対局"),
    "Quick_Play_Description": MessageLookupByLibrary.simpleMessage(
      "前回の設定でAIと対戦",
    ),
    "Redo_Move": MessageLookupByLibrary.simpleMessage("手をやり直す"),
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
    "Remove_Ads_With_Price": m21,
    "Replace_Unfinished_Game": MessageLookupByLibrary.simpleMessage(
      "新しい対局を始めますか？",
    ),
    "Replace_Unfinished_Game_Description": MessageLookupByLibrary.simpleMessage(
      "中断中の対局は新しい対局に置き換わります。",
    ),
    "Replay": MessageLookupByLibrary.simpleMessage("再生"),
    "Restore_Not_Found": MessageLookupByLibrary.simpleMessage(
      "以前の広告削除の購入が見つかりませんでした。",
    ),
    "Restore_Purchases": MessageLookupByLibrary.simpleMessage("購入を復元"),
    "Resume_Game_Unavailable": MessageLookupByLibrary.simpleMessage(
      "この対局を復元できませんでした。新しい対局を始められます。",
    ),
    "Retry": MessageLookupByLibrary.simpleMessage("再試行"),
    "Review_Game": MessageLookupByLibrary.simpleMessage("対局を振り返る"),
    "Review_Move_Title": m22,
    "Saving_Ambulance": MessageLookupByLibrary.simpleMessage("救急車を救え"),
    "Settings": MessageLookupByLibrary.simpleMessage("設定"),
    "Share_Result": MessageLookupByLibrary.simpleMessage("結果を共有"),
    "Sharing_Result": MessageLookupByLibrary.simpleMessage("結果カードを作成中…"),
    "Shows": MessageLookupByLibrary.simpleMessage("番組"),
    "Simple_Calculator": MessageLookupByLibrary.simpleMessage("シンプル電卓"),
    "Sound": MessageLookupByLibrary.simpleMessage("サウンド"),
    "Sound_Description": MessageLookupByLibrary.simpleMessage(
      "駒を動かすときに音を鳴らします。",
    ),
    "Stalemate": MessageLookupByLibrary.simpleMessage("ステイルメイト"),
    "Start": MessageLookupByLibrary.simpleMessage("開始"),
    "Sudoku_Lover": MessageLookupByLibrary.simpleMessage("Sudoku Lover"),
    "Theme_Back_Rank": MessageLookupByLibrary.simpleMessage("バックランクメイト"),
    "Theme_Bishop_Mate": MessageLookupByLibrary.simpleMessage("ビショップでメイト"),
    "Theme_Checkmate": MessageLookupByLibrary.simpleMessage("チェックメイト"),
    "Theme_Combination": MessageLookupByLibrary.simpleMessage("コンビネーション"),
    "Theme_Double_Attack": MessageLookupByLibrary.simpleMessage("ダブルアタック"),
    "Theme_Forks": MessageLookupByLibrary.simpleMessage("ナイトのフォーク"),
    "Theme_Knight_Mate": MessageLookupByLibrary.simpleMessage("ナイトでメイト"),
    "Theme_Promotion": MessageLookupByLibrary.simpleMessage("ポーンの昇格"),
    "Theme_Queen_Net": MessageLookupByLibrary.simpleMessage("クイーンでメイト"),
    "Theme_Rook_Mate": MessageLookupByLibrary.simpleMessage("ルークでメイト"),
    "Time_Limit": MessageLookupByLibrary.simpleMessage("制限時間"),
    "Tip": MessageLookupByLibrary.simpleMessage("手を提案"),
    "Tip_Button": MessageLookupByLibrary.simpleMessage("指し手の提案ボタン"),
    "Tip_Button_Description": MessageLookupByLibrary.simpleMessage(
      "より良い指し手を提案するボタンを表示します。",
    ),
    "Training": MessageLookupByLibrary.simpleMessage("トレーニング"),
    "Training_Description": MessageLookupByLibrary.simpleMessage(
      "テーマ別パズルに取り組むか、信頼できるオープニングラインを学びましょう。",
    ),
    "Training_Progress": MessageLookupByLibrary.simpleMessage("練習の進捗"),
    "Training_Progress_Unavailable": MessageLookupByLibrary.simpleMessage(
      "進捗を一時的に読み込めません。もう一度お試しください。",
    ),
    "Try_Again": MessageLookupByLibrary.simpleMessage("もう一度お試しください"),
    "Two_Players": MessageLookupByLibrary.simpleMessage("2人で対戦"),
    "Undo": MessageLookupByLibrary.simpleMessage("待った/やり直し"),
    "Undo_Description": MessageLookupByLibrary.simpleMessage(
      "指し手の取り消しとやり直しを許可します。",
    ),
    "Undo_Move": MessageLookupByLibrary.simpleMessage("手を取り消す"),
    "Unfinished": MessageLookupByLibrary.simpleMessage("未完了の対局"),
    "Vs_AI_Player": MessageLookupByLibrary.simpleMessage("AI対局を設定"),
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
