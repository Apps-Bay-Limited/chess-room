import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/main_menu_view/game_options.dart';
import 'package:chess_room/views/components/main_menu_view/confirm_new_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import 'chess_view.dart';
import 'components/shared/banner_ad_slot.dart';
import 'components/shared/menu_button.dart';
import 'components/shared/app_page.dart';

class SinglePlayerView extends StatefulWidget {
  const SinglePlayerView({super.key});

  @override
  State<SinglePlayerView> createState() => _SinglePlayerViewState();
}

class _SinglePlayerViewState extends State<SinglePlayerView> {
  bool _startingGame = false;

  Future<void> _startGame(AppModel appModel) async {
    if (_startingGame) return;
    setState(() => _startingGame = true);
    try {
      if (!await confirmNewGame(context, appModel) || !mounted) return;
      appModel.newGame(context, notify: false);
      await Navigator.push<void>(
        context,
        CupertinoPageRoute(builder: (_) => ChessView(appModel: appModel)),
      );
    } finally {
      if (mounted) setState(() => _startingGame = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        final strings = S.of(context);
        return AppPage(
          title: appModel.playerCount == 1
              ? strings.Vs_AI_Player
              : strings.Two_Players,
          leading: CupertinoNavigationBarBackButton(
            key: const ValueKey('setup-back-button'),
            onPressed: () => Navigator.pop(context),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: AppContent(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          appModel.playerCount == 1
                              ? strings.Game_Setup_Description
                              : strings.Home_Local_Description,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        GameOptions(appModel: appModel),
                        const SizedBox(height: AppSpacing.xxl),
                        MenuButton(
                          key: const ValueKey('start-game-button'),
                          label: strings.Start,
                          width: double.infinity,
                          onTap:
                              _startingGame ? null : () => _startGame(appModel),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
              const BannerAdSlot(),
            ],
          ),
        );
      },
    );
  }
}
