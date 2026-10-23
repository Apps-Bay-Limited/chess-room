import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/logic/shared_functions.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_piece_labels.dart';
import 'package:chess_room/util/app_design.dart';

class PromotionOption extends StatelessWidget {
  final AppModel appModel;
  final ChessPieceType promotionType;
  final VoidCallback? onSelected;

  const PromotionOption(this.appModel, this.promotionType, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: chessPieceLabel(S.of(context), promotionType, appModel.turn),
      button: true,
      child: CupertinoButton(
        minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
        padding: const EdgeInsets.all(8),
        child: Image(
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
          image: AssetImage(
            'assets/images/pieces/${formatPieceTheme(appModel.pieceTheme)}' +
                '/${pieceTypeToString(promotionType)}_${_playerColor()}.png',
          ),
        ),
        onPressed: onSelected ??
            () {
              appModel.game?.promote(promotionType);
              appModel.update();
              Navigator.pop(context);
            },
      ),
    );
  }

  String _playerColor() {
    return appModel.turn == Player.player1 ? 'white' : 'black';
  }
}
