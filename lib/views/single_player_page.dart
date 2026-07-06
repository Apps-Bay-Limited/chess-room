import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/main_menu_view/game_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import 'chess_view.dart';
import 'components/shared/banner_ad_slot.dart';
import 'components/shared/menu_button.dart';

class SinglePlayerView extends StatelessWidget {
  const SinglePlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration: BoxDecoration(gradient: appModel.theme.background),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top + 10),
                      GameOptions(appModel: appModel),
                      const SizedBox(height: 50),
                      MenuButton(
                        label: S.of(context).Start,
                        onTap: () {
                          appModel.newGame(context, notify: false);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ChessView(appModel: appModel),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      MenuButton(
                        label: S.of(context).Back,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
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
