import 'package:chess_room/features/game_history/game_history_page.dart';
import 'package:chess_room/features/how_to_play/how_to_play_page.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/ads_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import 'more_apps_page.dart';
import 'components/settings_view/remove_ads_section.dart';
import 'components/settings_view/settings_navigation_buttons.dart';
import 'components/settings_view/toggles.dart';
import 'components/shared/banner_ad_slot.dart';
import 'components/shared/text_variable.dart';

class SettingsView extends StatelessWidget {
  final AppModel appModel;

  const SettingsView({
    super.key,
    required this.appModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Container(
        decoration: BoxDecoration(gradient: appModel.theme.background),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 20),
                  TextLarge(S.of(context).Settings),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  Toggles(appModel),
                  const SizedBox(height: 30),
                  RemoveAdsSection(appModel: appModel),
                  const SizedBox(height: 50),
                  ValueListenableBuilder<bool>(
                    valueListenable: AdsManager.privacyOptionsRequired,
                    builder: (context, privacyOptionsRequired, child) {
                      return SettingsNavigationButtons(
                        showPrivacyChoices: privacyOptionsRequired,
                        onHowToPlay: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const HowToPlayPage(),
                            ),
                          );
                        },
                        onGameHistory: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GameHistoryPage(
                                store: appModel.gameHistoryStore,
                                pieceTheme: appModel.pieceTheme,
                              ),
                            ),
                          );
                        },
                        onPrivacyChoices: AdsManager.showPrivacyOptionsForm,
                        onMoreApps: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const MoreAppsPage(),
                            ),
                          );
                        },
                        onBack: () => Navigator.pop(context),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const BannerAdSlot(),
          ],
        ),
      ),
    );
  }
}
