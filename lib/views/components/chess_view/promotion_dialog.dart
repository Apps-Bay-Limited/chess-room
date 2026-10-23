import 'package:chess_room/logic/chess_piece.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/chess_view/promotion_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:chess_room/generated/l10n.dart';

const PROMOTIONS = [
  ChessPieceType.queen,
  ChessPieceType.rook,
  ChessPieceType.bishop,
  ChessPieceType.knight
];

class PromotionDialog extends StatefulWidget {
  final AppModel appModel;

  const PromotionDialog(this.appModel, {super.key});

  @override
  State<PromotionDialog> createState() => _PromotionDialogState();
}

class _PromotionDialogState extends State<PromotionDialog> {
  bool _selectionCommitted = false;

  void _selectPromotion(ChessPieceType promotionType) {
    // The outgoing dialog stays mounted during its pop animation. Share this
    // guard across every choice so queued taps cannot commit or pop twice.
    if (!mounted || _selectionCommitted) return;
    _selectionCommitted = true;
    widget.appModel.game?.promote(promotionType);
    widget.appModel.update();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Promotion is a required part of the move. Barrier dismissal is already
    // disabled by showCupertinoDialog, and this also consumes system back.
    // Choosing a piece still closes the dialog through Navigator.pop.
    return PopScope(
      canPop: false,
      child: CupertinoAlertDialog(
        title: Text(S.of(context).Theme_Promotion),
        actions: [
          SizedBox(
            height: 72,
            child: Row(
              children: PROMOTIONS
                  .map(
                    (promotionType) => Expanded(
                        child: PromotionOption(
                      widget.appModel,
                      promotionType,
                      onSelected: () => _selectPromotion(promotionType),
                    )),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
