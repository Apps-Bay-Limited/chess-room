import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/chess_view/chess_board_widget.dart';
import 'package:chess_room/views/components/chess_view/game_info_and_controls.dart';
import 'package:chess_room/views/components/chess_view/game_tip_button.dart';
import 'package:chess_room/views/components/chess_view/promotion_dialog.dart';
import 'package:chess_room/features/game_review/game_review_page.dart';
import 'package:chess_room/features/share_result/result_share_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import 'components/chess_view/game_info_and_controls/game_status.dart';
import 'components/shared/banner_ad_slot.dart';
import 'components/shared/menu_button.dart';

class ChessView extends StatefulWidget {
  final AppModel appModel;

  const ChessView({super.key, required this.appModel});

  @override
  _ChessViewState createState() => _ChessViewState(appModel);
}

class _ChessViewState extends State<ChessView> {
  AppModel appModel;

  _ChessViewState(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        if (appModel.promotionRequested) {
          appModel.promotionRequested = false;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showPromotionDialog(appModel));
        }
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            if (didPop) {
              appModel.exitChessView();
            }
          },
          child: Container(
            decoration: BoxDecoration(gradient: appModel.theme.background),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        GameInfoAndControls(appModel: appModel),
                        const SizedBox(height: 30),
                        ChessBoardWidget(appModel),
                        const SizedBox(height: 30),
                        GameStatus(),
                        if (!appModel.gameOver && appModel.showTipButton) ...[
                          const SizedBox(height: 14),
                          GameTipButton(
                            key: const ValueKey('game-tip-button'),
                            label: S.of(context).Tip,
                            isLoading: appModel.tipInProgress,
                            onTap: appModel.isAIsTurn || appModel.tipInProgress
                                ? null
                                : appModel.game?.showTip,
                          ),
                        ],
                        if (appModel.gameOver) ...[
                          const SizedBox(height: 24),
                          if (appModel.biggestMistake != null) ...[
                            MenuButton(
                              key: const ValueKey('review-game-button'),
                              label: S.of(context).Review_Game,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => GameReviewPage(
                                      record: appModel.biggestMistake!,
                                      pieceTheme: appModel.pieceTheme,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                          ResultShareSection(appModel: appModel),
                        ],
                      ],
                    ),
                  ),
                ),
                const BannerAdSlot(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPromotionDialog(AppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel);
      },
    );
  }
}
