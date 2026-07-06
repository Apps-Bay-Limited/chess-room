import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/more_apps_page.dart';
import 'package:chess_room/views/settings_view.dart';
import 'package:chess_room/views/single_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../util/ads_manager.dart';
import 'components/shared/banner_ad_slot.dart';
import 'components/shared/menu_button.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  void initState() {
    super.initState();

    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    WidgetsBinding.instance.addObserver(AppLifecycleReactor(appOpenAdManager: appOpenAdManager));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.height < 800 ? 110 : 140;

    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration: BoxDecoration(gradient: appModel.theme.background),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    const SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 30, 10, 0),
                      child: Image.asset(
                        'assets/images/chess-piece.png',
                        width: width,
                      ),
                    ),
                    const SizedBox(height: 40),
                    MenuButton(
                      label: S.of(context).Vs_AI_Player,
                      onTap: () {
                        appModel.setPlayerCount(1);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const SinglePlayerView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    MenuButton(
                      label: S.of(context).Two_Players,
                      onTap: () {
                        appModel.setPlayerCount(2);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const SinglePlayerView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    MenuButton(
                      label: S.of(context).Settings,
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SettingsView(appModel: appModel),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    MenuButton(
                      label: S.of(context).More_Apps,
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const MoreAppsPage(),
                          ),
                        );
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
