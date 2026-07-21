import 'package:chess_room/features/how_to_play/how_to_play_page.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import 'more_apps_page.dart';
import 'components/settings_view/remove_ads_section.dart';
import 'components/settings_view/toggles.dart';
import 'components/shared/banner_ad_slot.dart';
import 'components/shared/menu_button.dart';
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
                  MenuButton(
                    key: const ValueKey('settings-how-to-play-button'),
                    label: S.of(context).How_To_Play_Chess,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const HowToPlayPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  MenuButton(
                    key: const ValueKey('settings-more-apps-button'),
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
                  const SizedBox(height: 20),
                  MenuButton(
                    label: S.of(context).Back,
                    onTap: () {
                      Navigator.pop(context);
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
